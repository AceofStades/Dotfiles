import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null
  property var widgetSettings: null

  property var cfg: pluginApi?.pluginSettings || ({})

  property string editClientId: cfg.clientId ?? ""
  property string editClientSecret: cfg.clientSecret ?? ""
  property string editBarDisplayMode: cfg.barDisplayMode ?? "pending"

  spacing: Style.marginL

  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS
    visible: root.editClientId === ""
    
    NText {
      text: "⚠️ CONFIGURATION REQUIRED"
      font.bold: true
      color: Color.mError
    }
    
    NText {
      text: "You must generate your own Desktop Client ID and Secret in the Google Cloud Console and insert them below to log in. Your keys are stored locally on this device only."
      wrapMode: Text.Wrap
      Layout.fillWidth: true
      color: Color.mError
    }
  }

  NText {
    text: "Google Tasks API Credentials"
    font.bold: true
  }

  NTextInput {
    Layout.fillWidth: true
    placeholderText: "Client ID (optional)"
    text: root.editClientId
    onTextChanged: root.editClientId = text
  }

  NTextInput {
    Layout.fillWidth: true
    placeholderText: "Client Secret (optional)"
    text: root.editClientSecret
    onTextChanged: root.editClientSecret = text
    echoMode: TextInput.Password
  }

  NDivider { Layout.fillWidth: true }

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

  function saveSettings() {
    if (!pluginApi) return;
    pluginApi.pluginSettings.clientId = root.editClientId;
    pluginApi.pluginSettings.clientSecret = root.editClientSecret;
    pluginApi.pluginSettings.barDisplayMode = root.editBarDisplayMode;
    pluginApi.saveSettings();
  }
}