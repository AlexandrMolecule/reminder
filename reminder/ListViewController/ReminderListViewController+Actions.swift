//
//  ReminderListViewController+Actions.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 06.04.2022.
//

import UIKit
extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton){
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: false)
    }
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            if (reminder.title.isEmpty){
                self?.dismiss(animated: true)
                return
            }
            self?.reminders.append(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
            self?.dismiss(animated: true)
        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: true)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
