//
//  MainVC.swift
//  ClickAndSend
//
//  Created by Lê Anh Tuấn on 1/31/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class MainVC: UIViewController {

    @IBOutlet weak var btnShowMenu: UIButton!
    @IBOutlet weak var tblTemplate: UITableView!
    
    var templates: [TemplateObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTemplate.delegate = self
        tblTemplate.dataSource = self
        
        tblTemplate.register(UINib(nibName: "TemplateCell", bundle: nil), forCellReuseIdentifier: "TemplateCell")
        tblTemplate.estimatedRowHeight = 40
        
        
        loadTemplate()
        
        btnShowMenu.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func loadTemplate() {
        
        guard let htmlFile1 = Bundle.main.path(forResource: "template-1", ofType: "html"), let htmlFile2 = Bundle.main.path(forResource: "template-2", ofType: "html") else {
            return
        }
        
        guard let htmlString1 = try? String(contentsOfFile: htmlFile1, encoding: String.Encoding.utf8), let htmlString2 = try? String(contentsOfFile: htmlFile2, encoding: String.Encoding.utf8) else {
                return
        }
       
        self.templates.append(TemplateObject(name: "Hợp đồng hệ thống gửi đến bạn", subject: "HỢP ĐỒNG HỆ THỐNG GỬI ĐẾN BẠN @FULLNAME@", html: htmlString1))
        self.templates.append(TemplateObject(name: "Hợp đồng thuê phần mềm", subject: "HỢP ĐỒNG THUÊ PHẦN MỀM", html: htmlString2))
    }
    
    @IBAction func btnShowMenuClicked(_ sender: Any) {
        guard let menuVc = self.storyboard?.instantiateViewController(withIdentifier: "SliderMenuVC") as? SliderMenuVC else {
            return
        }
        
        self.addChildViewController(menuVc)
        self.view.addSubview(menuVc.view)
        self.didMove(toParentViewController: menuVc)
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCell", for: indexPath) as? TemplateCell else {
            return UITableViewCell()
        }
        
        cell.lblTemplate.text = self.templates[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalizationVC") as? PersonalizationVC else {
            return
        }
        
        vc.template = self.templates[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


