import Flutter
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Provide your Google Maps API key here
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
