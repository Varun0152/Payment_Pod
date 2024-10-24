//
//  PayoneerFillAddressVC.swift
//  AstroYeti
//
//  Created by Astrotalk on 30/10/23.
//  Copyright © 2023 Puneet Gupta. All rights reserved.
//

import UIKit

final class PayoneerFillAddressVC: UIViewController {
    
    @IBOutlet weak var vwFieldBG: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressExtTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
    @IBOutlet weak var phoneNoCodeButton: UIButton!
    
    @IBOutlet weak var phoneNoCodeImageView: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    @IBOutlet weak var saveAddressButton: AstroSubmitButton!
    
    var submitCompletionhandler: (()->Void)?
    let viewModel = PayoneerFillViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNoCodeButton.addTarget(self, action: #selector(phoneNoCodeButtonTapped), for: .touchUpInside)
        
        addborderAndCorner_UIView(buttonObj: self.vwFieldBG, colorSelect: hexStringToUIColor(hex: "C7C7CC"), width: 0.5, cornerRadius: 10)
        addborderAndCorner_UIView(buttonObj: self.saveAddressButton, colorSelect: hexStringToUIColor(hex: "C7C7CC"), width: 0.8, cornerRadius: 10)
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        addressExtTextField.delegate = self
        cityTextField.delegate = self
        pinTextField.delegate = self
        stateTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        pinTextField.keyboardType = .numberPad
        phoneNumberTextField.keyboardType = .phonePad
        fillCountryCodeAndFlag()
    }
    
    private func getCountryNameAndSetIsoCode(for countryCode: Int) -> String? {
        for countryObj in CountryCodeJson {
            if countryCode == countryObj["code"] as? Int, let countryIsoCode =  countryObj["locale"] as? String {
                viewModel.countryIsoCode = countryIsoCode
                return countryObj["en"] as? String ?? ""
            }
        }
        
        return nil
    }
    
    private func fillCountryCodeAndFlag() {
        if let countryimage = kUserDefault.value(forKey: kCountryImage) {
            self.countryFlagImageView.image = self.retriveImage(dataimage: countryimage as! Data)
            self.phoneNoCodeImageView.image = self.retriveImage(dataimage: countryimage as! Data)
            
            var countryMobileCode = (kUserDefault.value(forKey: kCountryCode) as? String ?? "").trimmingCharacters(in: .whitespaces)
            self.lblCountryCode.text = countryMobileCode
            if let countryName = getCountryNameAndSetIsoCode(for: Int(countryMobileCode.trimmingCharacters(in: ["+"])) ?? 0) {
                self.countryTextField.text = countryName
            }
        }else {
            if let countryIsoCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                for countryObj in CountryCodeJson {
                    if countryIsoCode == countryObj["locale"] as? String {
                        let countryMobileCode = "+" + "\(countryObj["code"] as? Int ?? 91)"
                        let countryFlagImage = UIImage(named:"CountryPicker.bundle/\(countryIsoCode)")
                        self.countryFlagImageView.image = countryFlagImage
                        self.phoneNoCodeImageView.image = countryFlagImage
                        self.lblCountryCode.text = countryMobileCode
                        
                        viewModel.countryIsoCode = countryIsoCode
                        if let countryName = countryObj["en"] as? String {
                            self.countryTextField.text = countryName
                        }
                        return
                    }
                }
            }
        }
        
    }
    
    //MARK: Change country
    @IBAction private func changeCountryAction(_ sender: UIButton) {
        let countryView = CountrySelectView.shared
        countryView.layer.cornerRadius = 20
        countryView.layer.masksToBounds = true
        countryView.barTintColor = .red
        countryView.displayLanguage = .english
        countryView.show()
//        countryView.dropShadow()
        countryView.selectedCountryCallBack = { (countryDic) -> Void in
            self.countryFlagImageView.image = (countryDic["countryImage"] as? UIImage)!
            self.countryTextField.text = (countryDic["en"] as? String) ?? ""
            self.viewModel.countryIsoCode = (countryDic["locale"] as? String) ?? ""
        }
    }
    
    func retriveImage(dataimage:Data) -> UIImage {
        let image = UIImage.init(data: dataimage)
        return image!
    }
    
    //MARK: Change country code
    @objc private func phoneNoCodeButtonTapped() {
        let countryView = CountrySelectView.shared
        countryView.layer.cornerRadius = 20
        countryView.layer.masksToBounds = true
        countryView.barTintColor = .red
        countryView.displayLanguage = .english
        countryView.show()
//        countryView.dropShadow()
        countryView.selectedCountryCallBack = { (countryDic) -> Void in
            self.phoneNoCodeImageView.image = (countryDic["countryImage"] as? UIImage)!
            self.lblCountryCode.text = "+\(countryDic["code"] as! NSNumber)"
        }
    }
    
    //MARK: Save Address
    @IBAction private func saveAddressButtonAction(_ sender: UIButton) {
        addPressState(sender) {[weak self] in
            func failureHandler() {
                self?.dismiss(animated: true)
            }
            if let safeHandler = self?.submitCompletionhandler {
                func successHandler() {
                    safeHandler()
                    self?.dismiss(animated: true)
                }
                self?.viewModel.submitBillingAddressDetails(successHandler: successHandler, failureHandler: failureHandler)
            }
            
        }
    }
    
    @IBAction func btnCancleAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}


extension PayoneerFillAddressVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        switch textField {
        case nameTextField:
            viewModel.name = text
        case addressTextField:
            viewModel.address = text
        case addressExtTextField:
            viewModel.addressExt = text
        case cityTextField:
            viewModel.city = text
        case pinTextField:
            viewModel.pin = text
        case stateTextField:
            viewModel.state = text
        case phoneNumberTextField:
            viewModel.phoneNumber = text
        default:
            break
        }
        
        saveAddressButton.isActive = viewModel.shouldSaveButtonEnable
    }
}


func addborderAndCorner_UIView(buttonObj:UIView,colorSelect:UIColor,width: CGFloat,cornerRadius:CGFloat){
    buttonObj.layer.cornerRadius = cornerRadius
    buttonObj.layer.borderWidth = width
    buttonObj.layer.borderColor = colorSelect.cgColor
    buttonObj.layer.masksToBounds = true
}

func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class AstroSubmitButton: UIButton {
    var isActive: Bool {
        get {
            super.isEnabled
        }
        set {
            super.isEnabled = false
            self.backgroundColor = hexStringToUIColor(hex: "F2F2F7")
            self.setTitleColor(hexStringToUIColor(hex: "9A9A9A"), for: .normal)
        }
    }
}
