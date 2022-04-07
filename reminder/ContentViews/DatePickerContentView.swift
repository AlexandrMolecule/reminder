//
//  DatePickerContentView.swift
//  reminder
//
//  Created by Alexandr Gerasimov on 07.04.2022.
//

import UIKit

class DatePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var date  = Date()
        var onChange: (Date)->Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }
    
    let datePicker = UIDatePicker()
    var configuration: UIContentConfiguration{
        didSet{
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration){
        guard let configuration = configuration as? Configuration else{return}
        datePicker.date = configuration.date
    }
    @objc func didChange(_ sender: UIDatePicker){
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        configuration.onChange(datePicker.date)
    }
}

extension UICollectionViewListCell{
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
