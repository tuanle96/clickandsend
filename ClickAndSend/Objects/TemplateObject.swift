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
    
    init(name: String, subject: String, html: String) {
        self.name = name
        self.html = html
        self.subject = subject
    }
}
