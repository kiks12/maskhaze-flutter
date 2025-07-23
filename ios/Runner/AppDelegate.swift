import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let factory = CameraPlatformViewFactory(messenger: controller.binaryMessenger)
        registrar(forPlugin: "native_camera_plugin")?.register(factory, withId: "native_camera_view")

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
