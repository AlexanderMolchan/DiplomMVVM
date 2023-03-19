//
//  NotificationManager.swift
//  DiplomProject
//
//  Created by Александр Молчан on 19.03.23.
//

import Foundation
import UserNotifications

final class NotificationManager {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotifications() {
        notificationCenter.requestAuthorization(options: [.sound, .badge, .alert]) { access, error in
            if access {
                print("All is good")
            }
        }
    }
    
    func checkNotificationStatus() {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print(1)
            } else if settings.authorizationStatus == .notDetermined {
                print(2)
            } else if settings.authorizationStatus == .denied {
                print(3)
            }
        }
    }
    
    func createPushFor(_ model: DebtModel) {
        let content = UNMutableNotificationContent()
        content.title = "Напоминание о долге \(model.debterName)"
        content.subtitle = "Сумма возврата: \(String.formatSumm(summ: model.summ))"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: model.notificationDate ?? Date.now)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: model.id, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    func removePushFor(_ model: DebtModel) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [model.id])
    }
    
}