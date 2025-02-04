//
//  DateViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol  DateViewControllerDelegate {
    func selectedDate(date: Date)
}

class DateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bgView: UIView!
    
    var delegate: DateViewControllerDelegate?
    
    private var dateFormmater: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let touch = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped(_:)))
        bgView.addGestureRecognizer(touch)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        delegate?.selectedDate(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
}
