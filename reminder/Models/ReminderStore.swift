//
//  ReminderStore.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 10.05.2022.
//

import Foundation
import EventKit

class ReminderStore {
    static let instance = ReminderStore()
    
    private let ekStore = EKEventStore()
    
    var isAvailable: Bool{
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    func readAll() async throws -> [Reminder]{
        guard isAvailable else {
            throw Error.accessDenied
        }
        
        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.fetchReminders(matching: predicate)
        let reminders: [Reminder] = try  ekReminders.compactMap{
            ekReminder in
            do{
                return try Reminder(with: ekReminder)
            }
            catch Error.reminderHasNoDueDate {
                return nil
            }
        }
        return reminders
    }
    
    func requestAccess()async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw Error.accessDenied
            }
        case .denied:
            throw Error.accessDenied
        case .restricted:
            throw Error.accessRestricted
        @unknown default:
                    throw Error.unknown
        }
        
    }
}
