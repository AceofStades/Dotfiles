use clap::{Parser, Subcommand};
use directories::ProjectDirs;
use reqwest::Client;
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::PathBuf;
use std::sync::Arc;
use std::io::Write;
use tiny_http::{Response, Server};
use tokio::sync::Mutex;
use url::Url;

// Secrets provided via CLI arguments for BYOK model
const REDIRECT_URI: &str = "http://127.0.0.1:8080";
const AUTH_URL: &str = "https://accounts.google.com/o/oauth2/v2/auth";
const TOKEN_URL: &str = "https://oauth2.googleapis.com/token";
const TASKS_API_BASE: &str = "https://tasks.googleapis.com/tasks/v1";

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[arg(long, global = true)]
    client_id: Option<String>,
    
    #[arg(long, global = true)]
    client_secret: Option<String>,

    #[command(subcommand)]
    command: Commands,
}

// Baked in via .env at compile time as a fallback
const DEFAULT_CLIENT_ID: &str = env!("CLIENT_ID", "You must set CLIENT_ID in .env before compiling");
const DEFAULT_CLIENT_SECRET: &str = env!("CLIENT_SECRET", "You must set CLIENT_SECRET in .env before compiling");

#[derive(Subcommand)]
enum Commands {
    Login,
    GetLists,
    AddList {
        #[arg(long)]
        title: String,
    },
    GetTasks {
        #[arg(long)]
        list_id: String,
    },
    AddTask {
        #[arg(long)]
        list_id: String,
        #[arg(long)]
        title: String,
        #[arg(long)]
        notes: Option<String>,
        #[arg(long)]
        due: Option<String>,
        #[arg(long)]
        parent: Option<String>,
    },
    CompleteTask {
        #[arg(long)]
        list_id: String,
        #[arg(long)]
        task_id: String,
    },
    UncompleteTask {
        #[arg(long)]
        list_id: String,
        #[arg(long)]
        task_id: String,
    },
    DeleteTask {
        #[arg(long)]
        list_id: String,
        #[arg(long)]
        task_id: String,
    },
    UpdateTask {
        #[arg(long)]
        list_id: String,
        #[arg(long)]
        task_id: String,
        #[arg(long)]
        due: String,
    },
}

#[derive(Serialize, Deserialize, Debug, Clone)]
struct TokenData {
    access_token: String,
    refresh_token: Option<String>,
    expires_in: i64,
    token_type: String,
}

struct AppState {
    client: Client,
    token_path: PathBuf,
    client_id: String,
    client_secret: String,
}

impl AppState {
    fn new(client_id: String, client_secret: String) -> Self {
        let proj_dirs = ProjectDirs::from("dev", "noctalia", "google-todo").unwrap();
        let config_dir = proj_dirs.config_dir();
        fs::create_dir_all(config_dir).unwrap();
        let token_path = config_dir.join("token.json");

        Self {
            client: Client::new(),
            token_path,
            client_id,
            client_secret,
        }
    }

    fn save_token(&self, token: &TokenData) {
        let json = serde_json::to_string_pretty(token).unwrap();
        fs::write(&self.token_path, json).unwrap();
    }

    fn load_token(&self) -> Option<TokenData> {
        let json = fs::read_to_string(&self.token_path).ok()?;
        serde_json::from_str(&json).ok()
    }
}

async fn function_to_get_token_from_auth_code(state: &AppState, code: &str) -> Option<TokenData> {
    let params = [
        ("client_id", state.client_id.as_str()),
        ("client_secret", state.client_secret.as_str()),
        ("code", code),
        ("grant_type", "authorization_code"),
        ("redirect_uri", REDIRECT_URI),
    ];
    if let Ok(res) = state.client.post(TOKEN_URL).form(&params).send().await {
        return res.json::<TokenData>().await.ok();
    }
    None
}

async fn refresh_token_if_needed(state: &AppState, token: &mut TokenData) -> bool {
    // For simplicity, we just try to refresh every time if we have a refresh token
    // In a real app, you'd check expiration time
    if let Some(refresh_token) = &token.refresh_token {
        let params = [
            ("client_id", state.client_id.as_str()),
            ("client_secret", state.client_secret.as_str()),
            ("refresh_token", refresh_token.as_str()),
            ("grant_type", "refresh_token"),
        ];
        if let Ok(res) = state.client.post(TOKEN_URL).form(&params).send().await {
            if let Ok(new_token) = res.json::<TokenData>().await {
                token.access_token = new_token.access_token;
                token.expires_in = new_token.expires_in;
                // Google might not return a new refresh token, so keep the old one
                state.save_token(token);
                return true;
            }
        }
    }
    false
}

async fn handle_login(state: &AppState) {
    let auth_url = format!(
        "{}?client_id={}&redirect_uri={}&response_type=code&scope=https://www.googleapis.com/auth/tasks",
        AUTH_URL, state.client_id, REDIRECT_URI
    );

    if webbrowser::open(&auth_url).is_err() {
        // Send the URL back to QML so the native UI can open it
        println!("{{\"url\": \"{}\"}}", auth_url);
    }

    let server = Server::http("127.0.0.1:8080").unwrap();
    for request in server.incoming_requests() {
        let url = format!("http://127.0.0.1:8080{}", request.url());
        let parsed = Url::parse(&url).unwrap();
        let code = parsed
            .query_pairs()
            .find(|(k, _)| k == "code")
            .map(|(_, v)| v.into_owned());

        if let Some(code) = code {
            let _ = request.respond(Response::from_string(
                "Login successful! You can close this tab.",
            ));
            if let Some(token) = function_to_get_token_from_auth_code(state, &code).await {                state.save_token(&token);
                println!("{{\"success\": true}}");
            } else {
                println!("{{\"error\": \"Failed to exchange token\"}}");
            }
            break;
        } else {
            let _ = request.respond(Response::from_string("Error: No code found in request."));
        }
    }
}

async fn get_valid_token(state: &AppState) -> Option<String> {
    let mut token = state.load_token()?;
    // We try to use it. If we need to, we refresh. We'll aggressively refresh here for simplicity.
    refresh_token_if_needed(state, &mut token).await;
    Some(token.access_token)
}

async fn handle_get_lists(state: &AppState) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let url = format!("{}/users/@me/lists", TASKS_API_BASE);
    let res = state
        .client
        .get(&url)
        .bearer_auth(access_token)
        .send()
        .await;
    match res {
        Ok(response) => {
            let text = response.text().await.unwrap_or_default();
            println!("{}", text);
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

async fn handle_get_tasks(state: &AppState, list_id: &str) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let url = format!(
        "{}/lists/{}/tasks?showCompleted=true&showHidden=true",
        TASKS_API_BASE, list_id
    );
    let res = state
        .client
        .get(&url)
        .bearer_auth(access_token)
        .send()
        .await;
    match res {
        Ok(response) => {
            let text = response.text().await.unwrap_or_default();
            println!("{}", text);
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

async fn handle_add_list(state: &AppState, title: &str) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let mut body = serde_json::Map::new();
    body.insert("title".to_string(), serde_json::Value::String(title.to_string()));

    let url = format!("{}/users/@me/lists", TASKS_API_BASE);
    let res = state
        .client
        .post(&url)
        .bearer_auth(access_token)
        .json(&body)
        .send()
        .await;
    match res {
        Ok(response) => {
            let text = response.text().await.unwrap_or_default();
            println!("{}", text);
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

async fn handle_add_task(
    state: &AppState,
    list_id: &str,
    title: &str,
    notes: Option<String>,
    due: Option<String>,
    parent: Option<String>,
) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let mut body = serde_json::Map::new();
    body.insert("title".to_string(), serde_json::Value::String(title.to_string()));
    if let Some(n) = notes {
        body.insert("notes".to_string(), serde_json::Value::String(n));
    }
    if let Some(d) = due {
        body.insert("due".to_string(), serde_json::Value::String(d));
    }

    let mut url = format!("{}/lists/{}/tasks", TASKS_API_BASE, list_id);
    if let Some(p) = parent {
        url = format!("{}?parent={}", url, p);
    }
    
    let res = state
        .client
        .post(&url)
        .bearer_auth(access_token)
        .json(&body)
        .send()
        .await;
    match res {
        Ok(response) => {
            let text = response.text().await.unwrap_or_default();
            println!("{}", text);
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

async fn handle_delete_task(state: &AppState, list_id: &str, task_id: &str) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let url = format!("{}/lists/{}/tasks/{}", TASKS_API_BASE, list_id, task_id);
    let res = state.client.delete(&url).bearer_auth(access_token).send().await;
    match res {
        Ok(response) => {
            if response.status().is_success() {
                println!("{{\"success\": true}}");
            } else {
                let text = response.text().await.unwrap_or_default();
                println!("{}", text);
            }
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

async fn handle_update_task(state: &AppState, list_id: &str, task_id: &str, due: &str) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let mut body = serde_json::Map::new();
    body.insert("due".to_string(), serde_json::Value::String(due.to_string()));

    let url = format!("{}/lists/{}/tasks/{}", TASKS_API_BASE, list_id, task_id);
    let res = state.client.patch(&url).bearer_auth(access_token).json(&body).send().await;
    match res {
        Ok(response) => {
            let text = response.text().await.unwrap_or_default();
            println!("{}", text);
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

async fn handle_uncomplete_task(state: &AppState, list_id: &str, task_id: &str) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let mut body = serde_json::Map::new();
    body.insert(
        "status".to_string(),
        serde_json::Value::String("needsAction".to_string()),
    );
    body.insert(
        "completed".to_string(),
        serde_json::Value::Null,
    );

    let url = format!("{}/users/@me/lists/{}/tasks/{}", TASKS_API_BASE, list_id, task_id);
    let res = state
        .client
        .patch(&url)
        .bearer_auth(access_token)
        .json(&body)
        .send()
        .await;
    match res {
        Ok(response) => {
            let text = response.text().await.unwrap_or_default();
            println!("{}", text);
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

async fn handle_complete_task(state: &AppState, list_id: &str, task_id: &str) {
    let access_token = match get_valid_token(state).await {
        Some(t) => t,
        None => {
            println!("{{\"error\": \"Not logged in\"}}");
            return;
        }
    };

    let mut body = serde_json::Map::new();
    body.insert(
        "status".to_string(),
        serde_json::Value::String("completed".to_string()),
    );

    let url = format!("{}/lists/{}/tasks/{}", TASKS_API_BASE, list_id, task_id);
    // Google Tasks API uses PUT or PATCH to update. We will use PATCH.
    let res = state
        .client
        .patch(&url)
        .bearer_auth(access_token)
        .json(&body)
        .send()
        .await;
    match res {
        Ok(response) => {
            let text = response.text().await.unwrap_or_default();
            println!("{}", text);
        }
        Err(e) => println!("{{\"error\": \"{}\"}}", e),
    }
}

#[tokio::main]
async fn main() {
    let cli = Cli::parse();
    let c_id = cli.client_id.unwrap_or_else(|| DEFAULT_CLIENT_ID.to_string());
    let c_secret = cli.client_secret.unwrap_or_else(|| DEFAULT_CLIENT_SECRET.to_string());
    let state = AppState::new(c_id, c_secret);

    match &cli.command {
        Commands::Login => handle_login(&state).await,
        Commands::GetLists => handle_get_lists(&state).await,
        Commands::AddList { title } => handle_add_list(&state, title).await,
        Commands::GetTasks { list_id } => handle_get_tasks(&state, list_id).await,
        Commands::AddTask {
            list_id,
            title,
            notes,
            due,
            parent,
        } => handle_add_task(&state, list_id, title, notes.clone(), due.clone(), parent.clone()).await,
        Commands::CompleteTask { list_id, task_id } => {
            handle_complete_task(&state, list_id, task_id).await
        }
        Commands::UncompleteTask { list_id, task_id } => {
            handle_uncomplete_task(&state, list_id, task_id).await
        }
        Commands::DeleteTask { list_id, task_id } => {
            handle_delete_task(&state, list_id, task_id).await
        }
        Commands::UpdateTask { list_id, task_id, due } => {
            handle_update_task(&state, list_id, task_id, due).await
        }
    }
}
