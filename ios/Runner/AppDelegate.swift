import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register plugins first
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure window for iOS 12 compatibility
    if #available(iOS 13.0, *) {
      // iOS 13+ will use SceneDelegate
    } else {
      // iOS 12 and below: configure window here
      self.window = UIWindow(frame: UIScreen.main.bounds)
      self.window?.rootViewController = FlutterViewController()
      self.window?.makeKeyAndVisible()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle app lifecycle for iOS 12 and below
  override func applicationWillResignActive(_ application: UIApplication) {
    super.applicationWillResignActive(application)
  }
  
  override func applicationDidEnterBackground(_ application: UIApplication) {
    super.applicationDidEnterBackground(application)
  }
  
  override func applicationWillEnterForeground(_ application: UIApplication) {
    super.applicationWillEnterForeground(application)
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
  }
}
