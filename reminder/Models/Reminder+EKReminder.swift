//
//  Reminder+EKReminder.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 10.05.2022.
//

import Foundation

import EventKit

extension Reminder {
    init(with ekReminder: EKReminder) throws {
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw Error.reminderHasNoDueDate
        }
        
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        self.dueDate = dueDate
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
