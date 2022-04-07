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
}
