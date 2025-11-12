import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false  // 关闭主窗体不退出程序
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // 添加状态栏菜单
  private var statusBarItem: NSStatusItem!
  private var statusBarMenu: NSMenu!

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // 创建状态栏图标
    setupStatusBar()
  }

  private func setupStatusBar() {
    // 创建状态栏项目
    statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    // 设置状态栏图标（使用新的托盘图标）
    if let button = statusBarItem.button {
      // 从资产目录加载托盘图标
      button.image = NSImage(named: "StatusBarIcon")
      button.action = #selector(statusBarButtonClicked)
      button.target = self
    }

    // 创建状态栏菜单
    statusBarMenu = NSMenu()
    statusBarMenu.addItem(
      NSMenuItem(title: "关于 UniSub", action: #selector(showAbout), keyEquivalent: ""))
    statusBarMenu.addItem(NSMenuItem.separator())
    statusBarMenu.addItem(
      NSMenuItem(title: "显示主窗口", action: #selector(showMainWindow), keyEquivalent: ""))
    statusBarMenu.addItem(
      NSMenuItem(title: "偏好设置...", action: #selector(showPreferences), keyEquivalent: ","))
    statusBarMenu.addItem(NSMenuItem.separator())
    statusBarMenu.addItem(
      NSMenuItem(title: "退出 UniSub", action: #selector(terminateApp), keyEquivalent: "q"))

    statusBarItem.menu = statusBarMenu
  }

  @objc private func statusBarButtonClicked() {
    // 状态栏图标点击事件
  }

  @objc private func showAbout() {
    // 显示关于窗口
    NSApp.orderFrontStandardAboutPanel()
  }

  @objc private func showMainWindow() {
    // 显示主窗口
    if let window = NSApp.windows.first {
      window.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
    }
  }

  @objc private func showPreferences() {
    // 显示偏好设置
    // TODO: 实现偏好设置窗口
  }

  @objc private func terminateApp() {
    // 退出应用
    NSApp.terminate(nil)
  }
}
