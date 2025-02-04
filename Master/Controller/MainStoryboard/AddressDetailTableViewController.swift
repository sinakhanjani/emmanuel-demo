//
//  AddressDetailTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/14/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol callbackDelegate {
    func back()
}

class AddressDetailTableViewController: UITableViewController,SelectionViewControllerDelegate , UITextFieldDelegate {

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
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var postalCodeTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var postalAddressTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    
    var provinces = [Province]()
    var cities = [Province]()
    var selectedProvince: Province?
    var selectedCity: Province?
    var index: Int?
    
    var data: AddressElement?
    
    var delegate: callbackDelegate?
    
    var isNew: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.codeTextField.keyboardType = .asciiCapableNumberPad
        backBarButtonAttribute(color: .white, name: "")
        addBarButton()
        phoneTextField.keyboardType = .asciiCapableNumberPad
        mobileTextField.keyboardType = .asciiCapableNumberPad
//        codeTextField.keyboardType = .asciiCapableNumberPad
//        postalCodeTextField.keyboardType = .asciiCapableNumberPad
        postalCodeTextField.delegate = self
        phoneTextField.delegate = self
        codeTextField.delegate = self
        mobileTextField.delegate = self
        addKeyboardNotification()
        fetchProvinces()
        updateUI()
    }
    
    func updateUI() {
        if let data = data {
            self.phoneTextField.text = data.phoneNumbers.phoneNumber
            self.mobileTextField.text = data.phoneNumbers.mobilePhoneNumber
            self.codeTextField.text = data.phoneNumbers.areaCode
            self.nameTextField.text = data.name
            self.postalCodeTextField.text = data.zipcode
            self.postalAddressTextField.text = data.address
            if !data.cities.isEmpty {
                self.selectedProvince = Province(id: data.cities[0].provinceID, name: data.province)
                for city in data.cities {
                    if city.name == data.city {
                        self.selectedCity = Province(id: city.id, name: city.name)
                        self.cityButton.setTitle(data.city, for: .normal)
                        self.provinceButton.setTitle(data.province, for: .normal)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == mobileTextField {
            maxLength = 20 //11
        } else if textField == phoneTextField {
             maxLength = 20 //1
        } else if textField == codeTextField {
            maxLength = 4
        } else {
            maxLength = 20//10
        }
        return newString.length <= maxLength
    }

//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.text = ""
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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

extension AddressDetailTableViewController {
    func addBarButton() {
         //Right
        let rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(doneBarButtonTapped))
        rightBarButtonItem.image = UIImage(named: "ic_toolbar_app_tik")
        rightBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationItem.rightBarButtonItem = rightBarButtonItem
         //Left
        let leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.image = UIImage(named: "down_icon")
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        guard self.phoneTextField.text!.count >= 4 && self.mobileTextField.text!.count >= 11 && self.postalCodeTextField.text!.count >= 10 else {
            print(self.phoneTextField.text!.count,self.mobileTextField.text!.count,self.postalCodeTextField.text!.count)
            self.presentIOSAlertWarning(message: "The zipcode, phone and mobile must be 10 digits.", completion: {})
            return
        }
        guard !self.nameTextField.text!.isEmpty && self.selectedCity != nil && self.selectedProvince != nil && !self.codeTextField.text!.isEmpty && !self.postalAddressTextField.text!.isEmpty else {
            print(self.nameTextField.text!,self.selectedCity,self.selectedProvince,self.codeTextField.text!,self.postalAddressTextField.text!)
            self.presentIOSAlertWarning(message: "all field is required.", completion: {})
            return
        }
        if isNew {
            self.addNewAddress()
        } else {
            self.addNewAddress()
        }
    }
    
    func addNewAddress() {
        var route = ""
        if isNew {
            route = "api/customer/addresses/add"
        } else {
            if let index = index {
                route = "api/customer/addresses/\(index)/edit"
            }
        }
        let params = ["name":self.nameTextField.text!,"phone-numbers[area-code]":self.codeTextField.text!,"phone-numbers[phone-number]":self.phoneTextField.text!,"phone-numbers[mobile-phone-number]":self.mobileTextField.text!,"zipcode":self.postalCodeTextField.text!,"address":self.postalAddressTextField.text!,"province":"\(self.selectedProvince!.id)","city":"\(self.selectedCity!.id)"]
        print(params)
        _ = Network<Empty,Empty>.init(path: route, ignoreAuth: false).setBodyType(type: .formdata).addAllParameters(params).post { (res) in
            res.ifSuccess { (_) in
                DispatchQueue.main.async {
                    self.delegate?.back()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
//    func editAddress() {
//
//    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddressDetailTableViewController {
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


//// ---- KEYBOARD FOR SCROLL ----
extension AddressDetailTableViewController {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo
        let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
    }

    @objc func keyboardDidHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
