//
//  ReminderListViewController+DataSource.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 06.04.2022.
//

import UIKit
extension ReminderListViewController{
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    func updateSnapshot(reloading ids: [Reminder.ID] = []) -> Void{
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map{$0.id})
        if(!ids.isEmpty) {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let item = reminder(for: id)
        //конфигурация ячейки
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = item.title
        contentConfiguration.secondaryText = item.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: item)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
        
        //так в ячейку добавляются элементы
        cell.accessories = [.customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
    }
    
    //законфигурировали кнопочку
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_: )), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func reminder(for id: Reminder.ID) -> Reminder{
        let index = reminders.indexOfReminder(id)
        return reminders[index]
    }
    func update(_ reminder: Reminder, id: Reminder.ID) -> Void {
        let index = reminders.indexOfReminder(id)
        reminders[index] = reminder
        
    }
    
    func completeReminder(with id: Reminder.ID){
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, id: id)
        updateSnapshot(reloading: [id])
    }
}
