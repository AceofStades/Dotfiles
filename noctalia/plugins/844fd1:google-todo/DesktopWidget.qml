import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root
  property var pluginApi: null

  width: 300 * Style.uiScaleRatio
  height: 400 * Style.uiScaleRatio

  property var currentTasks: pluginApi?.mainInstance?.currentTasks || []

  property bool isLoggedIn: pluginApi?.mainInstance?.isLoggedIn || false

  NPopupContextMenu {
    id: contextMenu
    model: [
      { "label": pluginApi?.tr("menu.create_task") || "Create Task", "action": "create_task", "icon": "plus" },
      { "label": root.isLoggedIn ? "Logout" : "Login", "action": root.isLoggedIn ? "logout" : "login", "icon": root.isLoggedIn ? "x" : "log-in" },
      { "label": pluginApi?.tr("menu.settings") || "Settings", "action": "settings", "icon": "settings" }
    ]
    onTriggered: action => {
      contextMenu.close();
      if (pluginApi && pluginApi.withCurrentScreen) {
        pluginApi.withCurrentScreen(screen => {
          qs.Services.UI.PanelService.closeContextMenu(screen);
          if (action === "settings") {
            qs.Services.UI.BarService.openPluginSettings(screen, pluginApi.manifest);
          } else if (action === "create_task") {
            pluginApi.togglePanel(screen);
          } else if (action === "logout") {
            if (pluginApi.mainInstance) pluginApi.mainInstance.logout();
          } else if (action === "login") {
            qs.Services.UI.PanelService.openPanel(screen, "google-todo", "login");
          }
        });
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    onClicked: mouse => {
      if (mouse.button === Qt.RightButton) {
        if (pluginApi && pluginApi.withCurrentScreen) {
          pluginApi.withCurrentScreen(screen => {
            qs.Services.UI.PanelService.showContextMenu(contextMenu, root, screen);
          });
        }
      }
    }
  }

  Rectangle {
    anchors.fill: parent
    color: Qt.rgba(Color.mSurfaceVariant.r, Color.mSurfaceVariant.g, Color.mSurfaceVariant.b, 0.5)
    radius: Style.radiusL
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Style.marginM
      spacing: Style.marginM

      RowLayout {
        Layout.fillWidth: true
        
        NIcon {
          icon: "check"
          color: Color.mPrimary
        }
        
        NText {
          text: pluginApi?.tr("widget.tasks_today") || "Tasks"
          font.bold: true
          Layout.fillWidth: true
        }

        NText {
          text: root.currentTasks.length.toString()
          color: Color.mOnSurfaceVariant
        }
      }

      NDivider { Layout.fillWidth: true }

      ListView {
        id: taskListView
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: Style.marginS
        model: root.currentTasks

        delegate: RowLayout {
          width: taskListView.width
          spacing: Style.marginS

          NIcon {
            icon: modelData.status === "completed" ? "clipboard-check" : "circle"
            color: modelData.status === "completed" ? Color.mSuccess : Color.mOnSurfaceVariant
            Layout.preferredWidth: Style.iconSizeS
            Layout.preferredHeight: Style.iconSizeS
          }

          NText {
            Layout.fillWidth: true
            text: modelData.title || ""
            color: modelData.status === "completed" ? Color.mOnSurfaceVariant : Color.mOnSurface
            font.strikeout: modelData.status === "completed"
            elide: Text.ElideRight
          }
        }
      }
    }
  }
}
