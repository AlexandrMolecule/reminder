//
//  Error.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 10.05.2022.
//

import Foundation


enum Error: LocalizedError {
    case failedReadingReminders
    case reminderHasNoDueDate
    case accessDenied
    case unknown
    case accessRestricted
    
    var errorDescription: String?{
        switch self {
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
            
        case .reminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date.", comment: "reminder has no due date error description")
            
        case .accessDenied:
            return NSLocalizedString("The app doesn't have permission to read reminders.", comment: "access denied error description")
        case .unknown:
            return NSLocalizedString("An unknown error occurred.", comment: "unknown error description")
        case .accessRestricted:
            return NSLocalizedString("This device doesn't allow access to reminders.", comment: "access restricted error description")
        }
        
        
    }
}
