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
    
    private var reminderStore: ReminderStore { ReminderStore.instance}
    
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) -> Void{
        let ids = idsThatChanged.filter { id in filteredReminders.contains(where: { $0.id == id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map{$0.id})
        if(!ids.isEmpty) {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
        headerView?.progress = progress
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
    
    func reminderStoreChanged(){
        Task{
            reminders = try await reminderStore.readAll()
            updateSnapshot()
        }
    }
    
    func deleteReminder(with id: Reminder.ID) {
        do{
            try reminderStore.remove(with: id)
            let index = reminders.indexOfReminder(id)
            reminders.remove(at: index)
            
        }catch ReminderError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    func reminder(for id: Reminder.ID) -> Reminder{
        let index = reminders.indexOfReminder(id)
        return reminders[index]
    }
    
    func add(_ reminder: Reminder) {
        var reminder = reminder
        do{
            let idFromStore = try reminderStore.save(reminder)
            reminder.id = idFromStore
            reminders.append(reminder)
        }catch ReminderError.accessDenied {
            
        }catch {
            showError(error)
        }
    }
    
    func update(_ reminder: Reminder, id: Reminder.ID) -> Void {
        do{
            try reminderStore.save(reminder)
            let index = reminders.indexOfReminder(id)
            reminders[index] = reminder
        } catch ReminderError.accessDenied {
            
        }
        catch  {
            showError(error)
        }
        
    }
    
    func prepareReminderStore() {
        Task {
            do {
                try await reminderStore.requestAccess()
                reminders = try await reminderStore.readAll()
                NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged(_:)), name: .EKEventStoreChanged, object: nil)
            }catch ReminderError.accessDenied, ReminderError.accessRestricted {
#if DEBUG
                reminders = Reminder.sampleData
#endif
            }catch {
                showError(error as! ReminderError)
            }
            updateSnapshot()
        }
    }
    
    func completeReminder(with id: Reminder.ID){
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, id: id)
        updateSnapshot(reloading: [id])
    }
}
