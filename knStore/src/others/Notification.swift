//
//  Notification.swift
//  knStore
//
//  Created by Apple on 8/21/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

struct knNotification {
    var title: String
    var body: String
    var sound = UNNotificationSound.default
    var badge = 0
    
    init(title: String, body: String, sound: UNNotificationSound = .default, badge: Int = 0) {
        self.title = title
        self.body = body
        self.sound = sound
        self.badge = badge
    }
}

class knNotificationCenter: NSObject {
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                
            } else {
                
            }
        }
    }
    
    func updateAppBadge(value: Int) {
        UIApplication.shared.applicationIconBadgeNumber = value
    }
}


class LocalNotification {
    static fileprivate func createNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        return request
    }
    
    static func createNotificationContent(data: knNotification) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.body = data.body
        content.sound = data.sound
        content.badge = NSNumber(value: data.badge)
        return content
    }
    
    static func addActionsToNotification(actions: [UNNotificationAction], content: UNMutableNotificationContent) {
        let categoryId = UUID().uuidString
        let category = UNNotificationCategory(identifier: categoryId, actions: actions, intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = categoryId
    }
    
    static func createAction(id: String, title: String, options: UNNotificationActionOptions = []) -> UNNotificationAction {
        return UNNotificationAction(identifier: id, title: title, options: options)
    }
    
    static func shoot(data: knNotification, trigger: UNNotificationTrigger, actions: [UNNotificationAction]) {
        let content = LocalNotification.createNotificationContent(data: data)
        addActionsToNotification(actions: actions, content: content)
        let request = LocalNotification.createNotificationRequest(content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}


class SecondsNotification {
    func shoot(delaySeconds: Double,
               repeats: Bool = false,
               data: knNotification) {
        let content = LocalNotification.createNotificationContent(data: data)
        let trigger = triggerInSeconds(delaySeconds, doesRepeat: repeats)
        let request = LocalNotification.createNotificationRequest(content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func triggerInSeconds(_ seconds: Double, doesRepeat: Bool = false) -> UNNotificationTrigger {
        if doesRepeat && seconds < 60 {
            fatalError("time interval must be at least 60 if repeating")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: doesRepeat)
        return trigger
    }
}


class LocationNotification {
    func shoot(inRegion region: CLRegion, repeats: Bool = false, data: knNotification) {
        let content = LocalNotification.createNotificationContent(data: data)
        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        let request = LocalNotification.createNotificationRequest(content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}


class DateNotification {
    func shoot(at date: Date,
               repeats: Bool = false,
               data: knNotification) {
        let content = LocalNotification.createNotificationContent(data: data)
        let trigger = triggerAtDate(date, doesRepeat: repeats)
        let request = LocalNotification.createNotificationRequest(content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func triggerAtDate(_ date: Date, doesRepeat: Bool) -> UNCalendarNotificationTrigger {
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        return trigger
    }
}


extension knNotificationCenter: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // TODO: Handle here
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: Handle here
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        completionHandler()
    }
}
