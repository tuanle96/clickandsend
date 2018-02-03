//
//  TemplateObject.swift
//  ClickAndSend
//
//  Created by Lê Anh Tuấn on 2/1/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TemplateObject: NSObject {
    var name: String
    var subject: String
    var html: String
    var sms: String
    
    init(name: String, subject: String, html: String) {
        self.name = name
        self.html = html
        self.subject = subject
        self.sms = "Chao Ban @FULLNAME@. Toi Nguyen Viet Nam Son day hoc lap trinh day. Toi da gui qua dia chi mail cua ban: @EMAIL@ HOP DONG THUE PHAN MEM. Ban kiem tra lai mail va dien day du thong tin, gui lai ban Hop Dong cho Toi theo nhu huong dan nhe.Neu khong tim thay mail Ban kiem tra trong hop thu Quang Cao co the mail bi roi vao day. Co van de gi Ban lien he voi Toi: 01267666702 - nvnamson@gmail.com. Chuc Ban mot ngay vui ve!"
    }
}
