import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.UI

Item {
  id: root
  property var pluginApi: null

  property var taskLists: []
  property var currentTasks: []
  property string currentListId: ""
  property bool isLoggedIn: false
  property bool isSyncing: false

  // Settings
  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  property int syncInterval: cfg.syncInterval ?? defaults.syncInterval ?? 300
  property bool _initialized: false

  property string localEnvClientId: ""
  property string localEnvClientSecret: ""

  function getActiveClientId() {
      return pluginApi?.pluginSettings?.clientId || root.localEnvClientId || "";
  }

  function getActiveClientSecret() {
      return pluginApi?.pluginSettings?.clientSecret || root.localEnvClientSecret || "";
  }

  // Timer for periodic sync
  Timer {
    id: syncTimer
    interval: syncInterval * 1000
    repeat: true
    running: cfg.autoStartSync ?? defaults.autoStartSync ?? false
    onTriggered: {
      if (isLoggedIn && currentListId !== "") {
        fetchTasksProcess.buffer = "";
        fetchTasksProcess.listId = currentListId;
        fetchTasksProcess.running = true;
      }
    }
  }

  function runCommand() {
    if (!pluginApi) return [];
    var clientId = root.getActiveClientId();
    var clientSecret = root.getActiveClientSecret();
    var baseArgs = [pluginApi.pluginDir + "/google-todo-sync"];
    if (clientId !== "") {
        baseArgs.push("--client-id");
        baseArgs.push(clientId);
    }
    if (clientSecret !== "") {
        baseArgs.push("--client-secret");
        baseArgs.push(clientSecret);
    }
    return baseArgs;
  }

  // Fetch lists
  Process {
    id: fetchListsProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string buffer: ""
    command: root.runCommand().concat(["get-lists"])
    running: false
    onExited: function(code) {
      buffer = String(fetchListsProcess.stdout.text || "").trim();
      if (code === 0 && buffer.length > 0) {
        try {
          var response = JSON.parse(buffer);
          if (response.error) {
            if (response.error === "Not logged in") {
              isLoggedIn = false;
            } else {
              Logger.e("Google Todo: Error fetching lists: " + response.error);
            }
          } else if (response.items) {
            isLoggedIn = true;
            taskLists = response.items;
            if (taskLists.length > 0 && currentListId === "") {
              currentListId = taskLists[0].id;
              fetchTasksProcess.buffer = "";
              fetchTasksProcess.listId = currentListId;
              fetchTasksProcess.running = true;
            }
          }
        } catch (e) {
          Logger.e("Google Todo: Parse error lists: " + e);
        }
      }
      buffer = "";
    }
  }

  // Fetch tasks
  Process {
    id: fetchTasksProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string buffer: ""
    property string listId: ""
    command: root.runCommand().concat(["get-tasks", "--list-id", listId])
    running: false
    onExited: function(code) {
      buffer = String(fetchTasksProcess.stdout.text || "").trim();
      if (code === 0 && buffer.length > 0) {
        try {
          var response = JSON.parse(buffer);
          if (!response.error) {
            if (response.items) {
              currentTasks = response.items;
            } else {
              currentTasks = [];
            }
          }
        } catch (e) {
          Logger.e("Google Todo: Parse error tasks: " + e);
        }
      }
      buffer = "";
    }
  }

  // Process to run login
  Process {
    id: loginProcess
    command: root.runCommand().concat(["login"])
    running: false
    stdout: StdioCollector {
      id: loginStdout
    }
    onExited: function(code) {
      if (code === 0) {
        var strData = String(loginStdout.text || "").trim();
        var lines = strData.split('\n');
        for (var i = 0; i < lines.length; i++) {
          var line = lines[i].trim();
          if (line.startsWith('{')) {
            try {
              var response = JSON.parse(line);
              if (response.success) {
                root.fetchLists();
              } else if (response.error) {
                Logger.e("Google Todo Login Error: " + response.error);
              }
            } catch(e) {
              // Ignore partial JSON parses
            }
          }
        }
      }
    }
  }

  // Add a list
  Process {
    id: addListProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string title: ""
    command: root.runCommand().concat(["add-list", "--title", title])
    running: false
    onExited: function(code) {
      if (code === 0) {
        fetchListsProcess.buffer = "";
        fetchListsProcess.running = true; // refresh
      }
    }
  }

  // Add a task
  Process {
    id: addTaskProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string buffer: ""
    property string listId: ""
    property string title: ""
    property string notes: ""
    property string due: ""
    property string parent: ""
    
    command: (function() {
      var base = root.runCommand();
      var args = ["add-task", "--list-id", listId, "--title", title];
      if (notes !== "") { args.push("--notes"); args.push(notes); }
      if (due !== "") { args.push("--due"); args.push(due); }
      if (parent !== "") { args.push("--parent"); args.push(parent); }
      return base.concat(args);
    })()
    running: false
    onExited: function(code) {
      if (code === 0) {
        fetchTasksProcess.buffer = "";
        fetchTasksProcess.running = true; // refresh
      }
    }
  }

  // Complete a task
  Process {
    id: completeTaskProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string listId: ""
    property string taskId: ""
    command: root.runCommand().concat(["complete-task", "--list-id", listId, "--task-id", taskId])
    running: false
    onExited: function(code) {
      if (code === 0) {
        fetchTasksProcess.buffer = "";
        fetchTasksProcess.running = true; // refresh after completion
      }
    }
  }

  // Uncomplete a task
  Process {
    id: uncompleteTaskProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string listId: ""
    property string taskId: ""
    command: root.runCommand().concat(["uncomplete-task", "--list-id", listId, "--task-id", taskId])
    running: false
    onExited: function(code) {
      if (code === 0) {
        fetchTasksProcess.buffer = "";
        fetchTasksProcess.running = true; // refresh after completion
      }
    }
  }

  // Delete a task
  Process {
    id: deleteTaskProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string listId: ""
    property string taskId: ""
    command: root.runCommand().concat(["delete-task", "--list-id", listId, "--task-id", taskId])
    running: false
    onExited: function(code) {
      if (code === 0) {
        fetchTasksProcess.buffer = "";
        fetchTasksProcess.running = true; // refresh after deletion
      }
    }
  }

  // Update a task (e.g. deadline)
  Process {
    id: updateTaskProcess
    stdout: StdioCollector {}
    stderr: StdioCollector {}
    property string listId: ""
    property string taskId: ""
    property string due: ""
    command: root.runCommand().concat(["update-task", "--list-id", listId, "--task-id", taskId, "--due", due])
    running: false
    onExited: function(code) {
      if (code === 0) {
        fetchTasksProcess.buffer = "";
        fetchTasksProcess.running = true; // refresh after update
      }
    }
  }

  // Process to read local .env fallback for developer keys
  Process {
    id: readEnvProcess
    command: ["cat", pluginApi.pluginDir + "/backend/.env"]
    running: false
    stdout: StdioCollector {}
    onExited: function(code) {
      if (code === 0) {
        try {
          var data = JSON.parse(readEnvProcess.stdout.text);
          if (data && data.installed) {
            root.localEnvClientId = data.installed.client_id || "";
            root.localEnvClientSecret = data.installed.client_secret || "";
          }
        } catch(e) {
          Logger.w("GoogleTodo", "Failed to parse local .env credentials as JSON");
        }
      }
      
      // Now that we have loaded the env (or failed), we can do the initial fetch
      fetchListsProcess.running = true;
    }
  }

  // IPC Handlers
  IpcHandler {
    target: "plugin:google-todo"

    function toggle() {
      if (pluginApi && pluginApi.withCurrentScreen) {
        pluginApi.withCurrentScreen(screen => {
          pluginApi.togglePanel(screen);
        });
      }
    }
  }

  Process {
    id: openBrowserProcess
    property string url: ""
    command: ["sh", "-c", "xdg-open '" + url + "'"]
    running: false
  }

  Process {
    id: openFileProcess
    property string file: ""
    command: ["sh", "-c", "xdg-open '" + file + "'"]
    running: false
  }

  function openSetupGuide() {
    openFileProcess.file = pluginApi.pluginDir + "/SETUP.md";
    openFileProcess.running = true;
  }

  function triggerLogin(forceFallback) {
    var clientId = root.getActiveClientId();
    
    if (clientId === "" && !forceFallback) {
        return false;
    }

    if (clientId === "") {
        clientId = "393145303655-qg81bpk1rl814rqc2cl584kp12eogc3f.apps.googleusercontent.com";
    }

    var redirectUri = "http://127.0.0.1:8080";
    var url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + clientId + "&redirect_uri=" + redirectUri + "&response_type=code&scope=https://www.googleapis.com/auth/tasks";
    
    // 1. Open the URL natively using a Process component to bypass any Wayland or scope issues
    openBrowserProcess.url = url;
    openBrowserProcess.running = true;

    // 2. Start the Rust binary to spin up the local server and catch the token
    loginProcess.running = true;
    return true;
  }

  function logout() {
    isLoggedIn = false;
    currentListId = "";
    taskLists = [];
    currentTasks = [];
    
    // Attempt to delete token file via rust CLI
    // Note: Rust CLI doesn't have a logout command yet, 
    // but the actual auth token is stored in ~/.config/noctalia/google-todo/token.json
    // Ideally we would delete that file here. For now, restarting the plugin drops state.
  }

  function addList(title) {
    if (title.trim() !== "") {
      addListProcess.title = title.trim();
      addListProcess.running = true;
    }
  }

  function addTask(title, notes, due, parent) {
    if (currentListId !== "" && title.trim() !== "") {
      addTaskProcess.listId = currentListId;
      addTaskProcess.title = title;
      addTaskProcess.notes = notes || "";
      addTaskProcess.due = due || "";
      addTaskProcess.parent = parent || "";
      addTaskProcess.buffer = "";
      addTaskProcess.running = true;
    }
  }

  function completeTask(taskId) {
    if (currentListId !== "") {
      // Optimistic UI update
      var tasks = currentTasks.slice();
      for (var i = 0; i < tasks.length; i++) {
        if (tasks[i].id === taskId) {
          tasks[i].status = "completed";
          break;
        }
      }
      currentTasks = tasks;

      completeTaskProcess.listId = currentListId;
      completeTaskProcess.taskId = taskId;
      completeTaskProcess.running = true;
    }
  }
  
  function uncompleteTask(taskId) {
    if (currentListId !== "") {
      // Optimistic UI update
      var tasks = currentTasks.slice();
      for (var i = 0; i < tasks.length; i++) {
        if (tasks[i].id === taskId) {
          tasks[i].status = "needsAction";
          break;
        }
      }
      currentTasks = tasks;

      uncompleteTaskProcess.listId = currentListId;
      uncompleteTaskProcess.taskId = taskId;
      uncompleteTaskProcess.running = true;
    }
  }

  function fetchLists() {
    fetchListsProcess.buffer = "";
    fetchListsProcess.running = true;
  }

  function fetchTasks(listId) {
    if (listId !== "") {
      fetchTasksProcess.buffer = "";
      fetchTasksProcess.listId = listId;
      fetchTasksProcess.running = true;
    }
  }

  function deleteTask(taskId) {
    if (currentListId !== "") {
      deleteTaskProcess.listId = currentListId;
      deleteTaskProcess.taskId = taskId;
      deleteTaskProcess.running = true;
    }
  }

  function updateTaskDue(taskId, due) {
    if (currentListId !== "") {
      updateTaskProcess.listId = currentListId;
      updateTaskProcess.taskId = taskId;
      updateTaskProcess.due = due;
      updateTaskProcess.running = true;
    }
  }

  Component.onCompleted: {
    if (pluginApi) {
      if (!pluginApi.pluginSettings.addedToBar) {
        try {
          pluginApi.withCurrentScreen(screen => {
            if (screen) {
              var screenName = screen.name;
              var widgets = Settings.getScreenOverride(screenName, "widgets") || {};
              if (!widgets["right"]) widgets["right"] = [];
              
              var widgetId = "plugin:844fd1:google-todo";
              var found = false;
              for (var i = 0; i < widgets["right"].length; i++) {
                if (widgets["right"][i].id === widgetId) found = true;
              }

              if (!found) {
                widgets["right"].push({ "id": widgetId });
                Settings.setScreenOverride(screenName, "widgets", widgets);
                BarService.widgetsRevision++;
              }
            }
          });
        } catch (e) {
          Logger.w("GoogleTodo", "Failed to auto-add widget to bar:", e);
        }
        
        pluginApi.pluginSettings.addedToBar = true;
        pluginApi.saveSettings();
      }

      // Read local env fallback, then fetch lists
      readEnvProcess.running = true;
    }
  }
}