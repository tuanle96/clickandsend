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

class PersonalizationVC: UIViewController {
    
    var template: TemplateObject!

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
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
        
        self.title = self.template.name
        
        if template.name.hasPrefix("Hợp đồng thuê phần mềm") {
            self.txtPassword.isHidden = true
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
            //show sent mail view controller
            let mailVc = configuredMailComposeViewController(to: email, and: body)
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailVc, animated: true, completion: nil)
            }
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
        controller.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
