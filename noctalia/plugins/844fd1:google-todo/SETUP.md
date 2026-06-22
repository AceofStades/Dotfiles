# Setup Google Tasks OAuth

Because this plugin connects directly to your Google account and is currently unverified by Google, it operates on a secure **Bring Your Own Key (BYOK)** model. This guarantees that your data is safe and that the plugin can never be blocked by Google for exceeding unverified user quotas.

There are two ways to provide your Google API keys to the plugin:

## Option 1: Use the UI Settings (Recommended for most users)
1. Open Noctalia.
2. Right-click the Google Todo widget and click **Settings**.
3. Paste your `Client ID` and `Client Secret` into the provided fields and click **Save**.

## Option 2: Use a local `.env` file (Recommended for Developers)
If you are developing or don't want to type your keys into the UI every time you reinstall the plugin, you can drop your Google OAuth credentials file directly into the plugin folder.

1. Download your OAuth 2.0 Client IDs JSON file from the [Google Cloud Console](https://console.cloud.google.com/apis/credentials).
2. Rename the downloaded file to `.env`.
3. Place it inside the `backend/` folder: `noctalia-plugins/google-todo/backend/.env`.

The plugin will automatically parse this JSON file when it starts up and use your credentials to log in!

## How to Generate Your Own Keys
If you don't have your own Google Cloud keys yet, here is how to get them for free in 2 minutes:

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new Project (e.g., "Noctalia Tasks").
3. Go to **APIs & Services > Library**, search for **Google Tasks API**, and click **Enable**.
4. Go to **OAuth consent screen**, choose **External**, and fill in the required app name and your email.
5. Under **Scopes**, click "Add or Remove Scopes", and add `https://www.googleapis.com/auth/tasks`.
6. Add your own Google email address under **Test users**.
7. Go to **Credentials**, click **Create Credentials > OAuth client ID**.
8. Select **Desktop app** as the Application type.
9. Click **Download JSON** on the far right of your new credential.
10. Open the JSON file to find your `client_id` and `client_secret` (or just rename it to `.env` as described in Option 2).