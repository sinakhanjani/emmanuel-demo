//
//  ProfileTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ProfileTableViewController: UITableViewController, UITextFieldDelegate, DateViewControllerDelegate, SelectionViewControllerDelegate {
    func selected(id: Int, name: String,type: SectionType) {
        if type == .province {
            self.provinceButton.setTitle(name, for: .normal)
            self.selectedProvince = Province(id: id, name: name)
            self.fetchCity(provinceId: id,comepletion: {})
        }
        if type == .city {
            self.cityButton.setTitle(name, for: .normal)
            self.selectedCity = Province(id: id, name: name)
        }
    }
    
    func selectedDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        year = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        day = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.birthdayTextField.text = dateFormatter.string(from: date)
    }
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nationalCodeTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var birthdayTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var gendreSwitch: UISwitch!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    
    var provinces = [Province]()
    var cities = [Province]()
    var selectedProvince: Province?
    var selectedCity: Province?
    var profile: Profile?

    var day: String = ""
    var month: String = ""
    var year: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        addBarButton()
        setupUI()
        fetchProfile()
        fetchProvinces()
        backBarButtonAttribute(color: .white, name: "")
        cityButton.tintImageColor(color: .red)
        provinceButton.tintImageColor(color: .red)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 5 {
            let vc = DateViewController.create()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    func setupUI() {
        phoneTextField.keyboardType = .asciiCapableNumberPad
        mobileTextField.keyboardType = .asciiCapableNumberPad
//        nationalCodeTextField.keyboardType = .asciiCapableNumberPad
        phoneTextField.delegate = self
        nationalCodeTextField.delegate = self
        mobileTextField.delegate = self
    }
    
    func updateUI() {
        if let profile = profile {
            self.nameTextField.text = profile.name
            self.nationalCodeTextField.text = profile.nationalCode
            if let phoneNumbers = profile.phoneNumbers {
                if !phoneNumbers.isEmpty {
                    self.mobileTextField.text = phoneNumbers[0]
                    if phoneNumbers.count >= 2 {
                        self.phoneTextField.text = phoneNumbers[1]
                    }
                }
            }
            let btd = profile.birthday?.components(separatedBy: "-")
            if let btd = btd {
                if btd.count >= 3 {
                    self.day = btd[2]
                    self.month = btd[1]
                    self.year = btd[0]
                }
            }
            self.selectedCity = Province(id: profile.city ?? 0, name: "Select city")
            self.selectedProvince = Province(id: profile.province ?? 0, name: "Select province")
            self.birthdayTextField.text = profile.birthday
            for data in self.provinces {
                if data.id == profile.province {
                    self.provinceButton.setTitle(data.name, for: .normal)
                    self.fetchCity(provinceId: data.id,comepletion: {
                        for i in self.cities {
                            if i.id == profile.city {
                                DispatchQueue.main.async {
                                    self.cityButton.setTitle(i.name, for: .normal)
                                }
                            }
                        }
                    })
                }
            }
            self.gendreSwitch.isOn = profile.gender == 1 ? true:false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == nationalCodeTextField {
            maxLength = 20
        } else {
            maxLength = 20
        }
        return newString.length <= maxLength
    }

//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.text = ""
//
//        return true
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }
}

extension ProfileTableViewController {
    func addBarButton() {
        // Right
        let rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(doneBarButtonTapped))
        rightBarButtonItem.image = UIImage(named: "ic_toolbar_app_tik")
        rightBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationItem.rightBarButtonItem = rightBarButtonItem
        // Left
        let leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.image = UIImage(named: "down_icon")
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        // update profile
        updateProfile()
    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func provinceButtonTapped(_ sender: UIBarButtonItem) {
        let vc = SelectionViewController.create()
        vc.delegate = self
        vc.title = "Province"
        vc.type = .province
        vc.data = provinces
        show(vc, sender: sender)
    }
    
    @IBAction func cityButtonTapped(_ sender: UIBarButtonItem) {
        let vc = SelectionViewController.create()
        vc.delegate = self
        vc.title = "City"
        vc.type = .city
        vc.data = cities
        show(vc, sender: sender)
    }
}

extension ProfileTableViewController {
    func fetchProfile() {
        _ = Network<Profile,Empty>.init(path: "api/customer/info", ignoreAuth: false).get { (res) in
            res.ifSuccess { (profile) in
                DispatchQueue.main.async {
                    DataManager.shared.profile = profile
                    self.profile = profile
                    self.updateUI()
                }
            }
        }
    }
    
    func updateProfile() {
        guard let _ = self.selectedProvince, let _ = self.selectedCity, !self.year.isEmpty else {
            self.presentIOSAlertWarning(message: "Province, city or birthday is empty.", completion: {})
            return }
        guard self.nationalCodeTextField.text!.count == 10 else {
            self.presentIOSAlertWarning(message: "The national-code must be 10 digits.", completion: {})
            return
        }
        self.view.endEditing(true)
        let params = ["name": nameTextField.text!,
                      "national-code": nationalCodeTextField.text!,
                      "gender": self.gendreSwitch.isOn ? "1":"0",
                      "phone-numbers[0]":mobileTextField.text!,
                      "phone-numbers[1]":phoneTextField.text!,
        "address":"address",
        "province": "\(self.selectedProvince?.id ?? 0)",
        "city": "\(self.selectedCity?.id ?? 0)",
            "birthday[day]": self.day,
            "birthday[month]": self.month,
            "birthday[year]": self.year]
        let netword = Network<Empty,Empty>.init(path: "api/customer/update-info", ignoreAuth: false).setBodyType(type: .formdata)
        netword.params = params
        netword.post { (res) in
            res.ifSuccess { (_) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func fetchProvinces() {
        _ = Network<[Province], Empty>.init(path: "api/helper/provinces", ignoreAuth: true).get { (response) in
            response.ifSuccess { (provinces) in
                self.provinces = provinces
            }
        }
    }
    
    func fetchCity(provinceId: Int, comepletion: @escaping () -> Void) {
        _ = Network<[Province], Empty>.init(path: "api/helper/provinces/\(provinceId)/cities", ignoreAuth: true).get { (response) in
            response.ifSuccess { (cities) in
                self.cities = cities
                comepletion()
            }
        }
    }
}
