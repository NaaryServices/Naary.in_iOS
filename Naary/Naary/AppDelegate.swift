//
//  AppDelegate.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//


import UIKit
import GoogleSignIn
import Swinject
import SwinjectStoryboard
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = GIDConfiguration(clientID: "53394674274-me9ufkcb0f0s3678ue9iq2tn5io5i3dv.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        
        let container = Container()
        let assembler = Assembler([AppAssembly()], container: container)
        
        SwinjectStoryboard.defaultContainer = assembler.resolver as! Container
        
        FirebaseApp.configure()
        
        // Firebase Messaging Delegate setup
        Messaging.messaging().delegate = self
        
        // Set the UNUserNotificationCenter delegate to handle foreground notifications
        UNUserNotificationCenter.current().delegate = self
        
        // Request Notification Permissions
        application.registerForRemoteNotifications()
        return true
    }
    
    // Handle Remote Notification Registration
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass the device token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Handle errors when registering for remote notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    // Handle received remote notifications manually (foreground and background)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Pass the notification payload to Firebase Messaging
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)  // Call the completion handler after handling the notification
    }
}

// MessagingDelegate to receive FCM token updates
extension AppDelegate: MessagingDelegate {
    
    // This method is called when a new FCM token is generated
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase FCM token: \(fcmToken ?? "")")
        // Optionally send this FCM token to your backend server if required
    }
}

// UNUserNotificationCenterDelegate to handle foreground notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notifications when the app is in the foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle tapping on notification
        completionHandler()
    }
}
