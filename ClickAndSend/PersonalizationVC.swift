//
//  PersonalizationVC.swift
//  ClickAndSend
//
//  Created by Lê Anh Tuấn on 2/1/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import Alamofire
import SkyFloatingLabelTextField

class PersonalizationVC: UIViewController {
    
    var template: TemplateObject!
    var isSMS: Bool = false

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }

    func setUpUI() {
        
/*
        var matched: [String] = []
        
        let regex = try? NSRegularExpression(pattern: "@[A-Z]{5,}@", options: [])
        
        let matches = regex?.matches(in: self.template.html, options: [], range: NSRange(location: 0, length: self.template.html.characters.count))
        
        for match in matches! {
            
        }
    */
        self.txtFullName.becomeFirstResponder()
        
        self.title = self.template.name
        
        if template.name.hasPrefix("Hợp đồng thuê phần mềm") {
            self.txtPassword.isHidden = true
            
            self.txtPhoneNumber.transform = CGAffineTransform(translationX: 0, y: -65)
            
        } else {
            self.txtPhoneNumber.isHidden = true
        }
        
    }
    
    
    @IBAction func btnSendEmailClicked(_ sender: Any) {
        
        if !self.txtFullName.hasText {
            self.showAlert("Vui lòng nhập Họ tên", title: "Thông báo", buttons: nil)
            return
        }
        
        if !self.txtEmail.hasText {
            self.showAlert("Vui lòng nhập Email", title: "Thông báo", buttons: nil)
            return
        }
        
        //get text in textInput
        
        guard let fullName = txtFullName.text, let email = txtEmail.text else {
            return
        }
        
        
        //replace in html 
        
        let body = self.template.html.replacingOccurrences(of: "@FULLNAME@", with: fullName)
        
        if !template.name.hasPrefix("Hợp đồng thuê phần mềm") {
            
            if !self.txtPassword.hasText {
                self.showAlert("Vui lòng nhập Mật khẩu", title: "Thông báo", buttons: nil)
                return
            }
            
            guard let password = self.txtPassword.text else {
                return
            }
            
            let temp = body.replacingOccurrences(of: "@EMAIL@", with: email)
            let newBody = temp.replacingOccurrences(of: "@PASSWORD@", with: password)
            let newSubject = self.template.subject.replacingOccurrences(of: "@FULLNAME@", with: fullName)
            
            //show sent mail view controller
            let mailVc = configuredMailComposeViewController(to: email, with: newSubject, and: newBody)
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailVc, animated: true, completion: nil)
            }
            
        } else {
            
            
            if !self.txtPhoneNumber.hasText {
                self.showAlert("Vui lòng nhập Số điện thoại", title: "Thông báo", buttons: nil)
                return
            }
            
            guard let _ = self.txtPhoneNumber.text else {
                return
            }
            
            //ask to send sms
            let yes = UIAlertAction(title: "Đồng ý", style: UIAlertActionStyle.default, handler: { (action) in
                self.isSMS = true
                
                //show sent mail view controller
                let mailVc = self.configuredMailComposeViewController(to: email, and: body)
                
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailVc, animated: true, completion: nil)
                }
            })
            
            let no = UIAlertAction(title: "Không", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.isSMS = false
                
                //show sent mail view controller
                let mailVc = self.configuredMailComposeViewController(to: email, and: body)
                
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailVc, animated: true, completion: nil)
                }
            })
            
            self.showAlert("Bạn có muốn gửi email cùng với sms không?", title: "Thông báo", buttons: [yes, no])
        }
    }
}

extension PersonalizationVC: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController(to email: String, with subject: String = "", and body: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([email])
        
        if subject.isEmpty {
            mailComposerVC.setSubject(self.template.subject)
        } else {
            mailComposerVC.setSubject(subject)
        }
        
        mailComposerVC.setMessageBody("\(body)", isHTML: true)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .sent:
            if self.isSMS {
                if let phoneNumber = self.txtPhoneNumber.text, let email = self.txtEmail.text, let fullName = self.txtFullName.text {
                    
                    //replace email & full name
                    let temp = self.template.sms.replacingOccurrences(of: "@EMAIL@", with: email)
                    let newEntry = temp.replacingOccurrences(of: "@FULLNAME@", with: fullName)
                    
                    self.sendSMS(with: phoneNumber, and: newEntry)
                }
            }
        default:
            break
        }
        
        
        controller.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension PersonalizationVC {
    func sendSMS(with phoneNumber: String, and entry: String) {
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "entry": entry
        ]
        
        //http://35.201.241.250/api/sendSMS
        
        Alamofire.request("http://35.201.241.250/api/sendSMS", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let res = response.result.value as? [String: Any] else {
                return
            }
            
            if let error = res["error"] as? String {
                
                let alert = UIAlertController(title: "Thông báo", message: error, preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Đã hiểu", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                return
            }
            
            if let _ = res["success"] as? String {
                
                let alert = UIAlertController(title: "Thông báo", message: "Gửi SMS thành công", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Đã hiểu", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
