# Google Todo List Plugin

A robust and modern Google Tasks client that syncs your tasks bi-directionally with Google's servers.

## Features

- **Bi-directional Sync:** Tasks are synced directly with Google Tasks.
- **Multiple Task Lists:** Switch between your Google task lists via a dropdown.
- **Due Dates:** View tasks with assigned due dates.
- **Rust Backend:** Uses a frictionless native executable to handle complex OAuth2 flows without needing Python or external dependencies.
- **Modern UI:** Built with Noctalia's `N*` widgets for a consistent and responsive appearance.

## Dependencies

- **Rust / Cargo:** During initial installation, Cargo is required to compile the `google-todo-sync` backend.
  (Run `build.sh` inside the plugin directory to compile).

## Usage

1. Open the plugin settings.
2. Click **Login with Google**. This will open a browser window to authenticate.
3. Once authenticated, the plugin will fetch your lists and tasks.
4. Click the check icon next to tasks to complete them.

## Tags

`Bar`, `Desktop`, `Panel`, `Productivity`
