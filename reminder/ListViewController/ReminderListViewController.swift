//
//  ViewController.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 05.04.2022.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let date = Date.now
        //print(date.formatted(date: .o, time: .standard))
        
        let listLayout = listLayout()
        self.collectionView.collectionViewLayout = listLayout
        
        //регистрируем ячейки для коллекции
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
        
    }
    // вызывается при начале клика
    // если тру покажет что ячейка выделена
    //из-за кастомного цвета не показывается
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.item].id
        showDetail(for: id)
        return true
    }
    
    //переход на детальный
    func showDetail(for id: Reminder.ID) {
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.update(reminder, id: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // создаем композиционный layout
    private func listLayout() -> UICollectionViewCompositionalLayout{
        
        //конфигурация списка
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        // создаем композиционный layout содержащий только лист
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    
}

