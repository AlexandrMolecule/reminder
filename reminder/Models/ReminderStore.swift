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
            throw ReminderError.accessDenied
        }
        
        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.fetchReminders(matching: predicate)
        let reminders: [Reminder] = try  ekReminders.compactMap{
            ekReminder in
            do{
                return try Reminder(with: ekReminder)
            }
            catch ReminderError.reminderHasNoDueDate {
                return nil
            }
        }
        return reminders
    }
    
    func saveNew(with reminder: Reminder){
        //        ekStore.save
    }
    
    private func read(with id: Reminder.ID) throws -> EKReminder {
        guard let ekReminder = ekStore.calendarItem(withIdentifier: id) as? EKReminder else {
            throw ReminderError.failedReadingCalendarItem
        }
        return ekReminder
    }
    
    func requestAccess()async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw ReminderError.accessDenied
            }
        case .denied:
            throw ReminderError.accessDenied
        case .restricted:
            throw ReminderError.accessRestricted
        @unknown default:
            throw ReminderError.unknown
        }
        
    }
    
    @discardableResult
    func save(_ reminder: Reminder) throws -> Reminder.ID {
        guard isAvailable else {
            throw ReminderError.accessDenied
        }
        let ekReminder: EKReminder
        do {
            ekReminder = try read(with: reminder.id)
        }catch {
            ekReminder = EKReminder(eventStore: ekStore)
        }
        ekReminder.update(using: reminder, in: ekStore)
        try ekStore.save(ekReminder, commit: true)
        return ekReminder.calendarItemIdentifier
    }
    
    func remove(with id:Reminder.ID) throws -> Void{
        guard isAvailable else{
            throw ReminderError.accessDenied
        }
        let ekReminder = try read(with: id)
        try ekStore.remove(ekReminder, commit: true)
    }
}
