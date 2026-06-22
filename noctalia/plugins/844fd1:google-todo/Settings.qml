import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property int editSyncInterval: cfg.syncInterval !== undefined ? cfg.syncInterval : (defaults.syncInterval !== undefined ? defaults.syncInterval : 300)
  property bool editShowCompleted: cfg.showCompleted !== undefined ? cfg.showCompleted : (defaults.showCompleted !== undefined ? defaults.showCompleted : true)
  property bool editAutoStartSync: cfg.autoStartSync !== undefined ? cfg.autoStartSync : (defaults.autoStartSync !== undefined ? defaults.autoStartSync : false)
  property string editBarDisplayMode: cfg.barDisplayMode !== undefined ? cfg.barDisplayMode : (defaults.barDisplayMode !== undefined ? defaults.barDisplayMode : "pending")
  property string editClientId: cfg.clientId !== undefined ? cfg.clientId : ""
  property string editClientSecret: cfg.clientSecret !== undefined ? cfg.clientSecret : ""

  spacing: Style.marginL

  // --- Security Warning ---
  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS
    visible: root.editClientId === ""
    
    NText {
      text: "⚠️ CONFIGURATION WARNING"
      font.bold: true
      color: Color.mWarning
    }
    
    NText {
      text: "You are currently using the developer's default Google OAuth keys. These are unverified and may hit rate limits. For the best experience, generate your own Client ID/Secret in the Google Cloud Console and insert them below."
      wrapMode: Text.Wrap
      Layout.fillWidth: true
      color: Color.mOnSurfaceVariant
    }
  }

  // --- API Credentials ---
  NText {
    text: "Google Tasks API Credentials"
    font.bold: true
  }

  NTextInput {
    id: clientIdInput
    Layout.fillWidth: true
    placeholderText: "Client ID (optional)"
    text: root.editClientId
    onTextChanged: root.editClientId = text
  }

  NTextInput {
    id: clientSecretInput
    Layout.fillWidth: true
    placeholderText: "Client Secret (optional)"
    text: root.editClientSecret
    onTextChanged: root.editClientSecret = text
    echoMode: TextInput.Password
  }

  NDivider { Layout.fillWidth: true }

  // --- Display Settings ---
  NComboBox {
    Layout.fillWidth: true
    label: "Bar Widget Display"
    description: "What information should the bar widget show?"
    model: [
      { key: "pending", name: "Pending Tasks Only" },
      { key: "completed", name: "Completed Tasks Only" },
      { key: "both", name: "Total Tasks (Both)" }
    ]
    currentKey: root.editBarDisplayMode
    onSelected: key => root.editBarDisplayMode = key
  }

  NSpinBox {
    Layout.fillWidth: true
    label: "Sync Interval (seconds)"
    value: root.editSyncInterval
    from: 60
    to: 3600
    onValueChanged: root.editSyncInterval = value
  }

  NSwitch {
    Layout.fillWidth: true
    label: "Auto-start Sync"
    checked: root.editAutoStartSync
    onCheckedChanged: root.editAutoStartSync = checked
  }

  NSwitch {
    Layout.fillWidth: true
    label: "Show Completed Tasks"
    checked: root.editShowCompleted
    onCheckedChanged: root.editShowCompleted = checked
  }

  function saveSettings() {
    if (!pluginApi) return;
    pluginApi.pluginSettings.syncInterval = root.editSyncInterval;
    pluginApi.pluginSettings.showCompleted = root.editShowCompleted;
    pluginApi.pluginSettings.autoStartSync = root.editAutoStartSync;
    pluginApi.pluginSettings.barDisplayMode = root.editBarDisplayMode;
    pluginApi.pluginSettings.clientId = root.editClientId;
    pluginApi.pluginSettings.clientSecret = root.editClientSecret;
    pluginApi.saveSettings();
  }
}