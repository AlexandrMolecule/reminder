//
//  ViewController.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 05.04.2022.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let listLayout = listLayout()
        self.collectionView.collectionViewLayout = listLayout
        
        //регистрируем ячейки для коллекции
        let cellRegistration = UICollectionView.CellRegistration{
            (cell : UICollectionViewListCell, indexPath: IndexPath, id: String) in
            
            let item = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            
            contentConfiguration.text = item.title
            
            cell.contentConfiguration = contentConfiguration
            
            
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map{$0.title})
        
        dataSource.apply(snapshot)
        
        collectionView.dataSource = dataSource
        
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

