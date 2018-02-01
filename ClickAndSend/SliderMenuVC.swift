//
//  SliderMenuVC.swift
//  ClickAndSend
//
//  Created by Lê Anh Tuấn on 1/31/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SliderMenuVC: UIViewController {

    @IBOutlet weak var btnHideMenu: UIButton!
    @IBOutlet weak var menuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuView.transform = CGAffineTransform(translationX: -200, y: 0)
        self.btnHideMenu.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animate()
    }
    
    func test() {
        print("OK")
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .curveEaseOut], animations: {
            self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
            self.menuView.transform = CGAffineTransform.identity
        }) { (finish) in
            UIView.animate(withDuration: 5, animations: {
                self.btnHideMenu.isHidden = false
            })
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: { 
            self.menuView.transform = CGAffineTransform(translationX: -200, y: 0)
            self.view.backgroundColor = UIColor.clear
        }) { (finish) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
            self.willMove(toParentViewController: nil)
        }
    }

    @IBAction func btnHideMenuClicked(_ sender: Any) {
        removeAnimate()
        
    }
 
}
