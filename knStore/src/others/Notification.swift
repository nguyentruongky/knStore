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
    func createNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        return request
    }
    
    func createNotificationContent(data: knNotification) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.body = data.body
        content.sound = data.sound
        content.badge = NSNumber(value: data.badge)
        return content
    }
    
    func addActionsToNotification(actions: [UNNotificationAction], content: UNMutableNotificationContent) {
        let categoryId = UUID().uuidString
        let category = UNNotificationCategory(identifier: categoryId, actions: actions, intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = categoryId
    }
    
    func createAction(id: String, title: String, options: UNNotificationActionOptions = []) -> UNNotificationAction {
        return UNNotificationAction(identifier: id, title: title, options: options)
    }
}


class SecondsNotification: LocalNotification {
    func scheduleNotification(delaySeconds: Double,
                              repeats: Bool = false,
                              data: knNotification) {
        let content = createNotificationContent(data: data)
        let trigger = triggerInSeconds(delaySeconds, doesRepeat: repeats)
        let request = createNotificationRequest(content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func triggerInSeconds(_ seconds: Double, doesRepeat: Bool = false) -> UNCalendarNotificationTrigger {
        let date = Date(timeIntervalSinceNow: seconds)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: doesRepeat)
        return trigger
    }
}


class LocationNotification: LocalNotification {
    func shoot(inRegion region: CLRegion, repeats: Bool = false, data: knNotification) {
        let content = createNotificationContent(data: data)
        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        let request = createNotificationRequest(content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}


class DateNotification: LocalNotification {
    func scheduleNotification(at date: Date,
                              repeats: Bool = false,
                              data: knNotification) {
        let content = createNotificationContent(data: data)
        let trigger = triggerAtDate(date, doesRepeat: repeats)
        let request = createNotificationRequest(content: content, trigger: trigger)
        
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
