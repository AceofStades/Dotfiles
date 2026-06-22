import QtQuick
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  readonly property string screenName: screen ? screen.name : ""
  readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"
  readonly property real barHeight: Style.getBarHeightForScreen(screenName)
  readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)
  readonly property real barFontSize: Style.getBarFontSizeForScreen(screenName)

  readonly property real contentWidth: root.isVertical ? root.capsuleHeight : (horizontalRow.implicitWidth + (Style.marginM * 2))
  readonly property real contentHeight: root.isVertical ? root.capsuleHeight : root.capsuleHeight

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  property bool isLoggedIn: pluginApi?.mainInstance?.isLoggedIn ?? false
  property var currentTasks: pluginApi?.mainInstance?.currentTasks || []
  property string barDisplayMode: cfg.barDisplayMode ?? defaults.barDisplayMode ?? "pending"
  
  property int taskCount: {
    if (!currentTasks) return 0;
    if (barDisplayMode === "both") return currentTasks.length;
    if (barDisplayMode === "completed") return currentTasks.filter(t => t.status === "completed").length;
    return currentTasks.filter(t => t.status !== "completed").length;
  }
  
  readonly property color contentColor: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface

  NPopupContextMenu {
    id: contextMenu
    model: [
      { "label": pluginApi?.tr("menu.create_task") || "Create Task", "action": "create_task", "icon": "plus" },
      { "label": pluginApi?.tr("menu.logout") || "Logout", "action": "logout", "icon": "x" },
      { "label": pluginApi?.tr("menu.settings") || "Settings", "action": "settings", "icon": "settings" }
    ]
    onTriggered: action => {
      contextMenu.close();
      PanelService.closeContextMenu(screen);
      if (action === "settings") {
        BarService.openPluginSettings(screen, pluginApi.manifest);
      } else if (action === "create_task") {
        if (pluginApi) pluginApi.togglePanel(screen);
      } else if (action === "logout") {
        if (pluginApi && pluginApi.mainInstance) pluginApi.mainInstance.logout();
      }
    }
  }

  Rectangle {
    id: visualCapsule
    x: Style.pixelAlignCenter(parent.width, width)
    y: Style.pixelAlignCenter(parent.height, height)
    width: root.contentWidth
    height: root.contentHeight
    radius: Style.radiusL
    color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    Row {
      id: horizontalRow
      anchors.centerIn: parent
      spacing: Style.marginS
      visible: !root.isVertical

      NIcon {
        anchors.verticalCenter: parent.verticalCenter
        icon: "clipboard-check"
        applyUiScale: false
        color: root.taskCount > 0 ? Color.mPrimary : root.contentColor
        visible: root.isLoggedIn
      }

      NText {
        anchors.verticalCenter: parent.verticalCenter
        text: root.isLoggedIn ? root.taskCount.toString() : "G"
        color: root.contentColor
        pointSize: root.barFontSize
        applyUiScale: false
      }
    }

    Column {
      id: verticalColumn
      anchors.centerIn: parent
      spacing: Style.marginS
      visible: root.isVertical

      NIcon {
        anchors.horizontalCenter: parent.horizontalCenter
        icon: "clipboard-check"
        applyUiScale: false
        color: root.taskCount > 0 ? Color.mPrimary : root.contentColor
        visible: root.isLoggedIn
      }
      
      NText {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "G"
        color: root.contentColor
        pointSize: root.barFontSize
        applyUiScale: false
        visible: !root.isLoggedIn
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
      if (mouse.button === Qt.LeftButton) {
        if (pluginApi) pluginApi.togglePanel(root.screen, root);
      } else if (mouse.button === Qt.RightButton) {
        PanelService.showContextMenu(contextMenu, root, screen);
      }
    }
  }
}
