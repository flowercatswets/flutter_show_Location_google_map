import UIKit
import Flutter
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Add the following line, with your API key
    GMSServices.provideAPIKey("AIzaSyBNeRDfXCpNh-lmKQF3Su32zDrkyvNLk2k")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
