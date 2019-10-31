//
//  SecondViewController.swift
//  SampleJTAppleCalender
//
//  Created by Shunsuke Igusa on 2019/10/31.
//  Copyright © 2019 Shunsuke Igusa. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var didChangeSwitchStatusHandler: ((Bool)->Void)?
    
    static func makeInstance() -> SecondViewController {
        let vc = UIStoryboard.init(name: "Second", bundle: nil).instantiateInitialViewController() as! SecondViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didChangeStatus(_ sender: UISwitch) {
        //Switch turns off, footer view will be hidden. Then you are going to see collapse layout inside UIStackView.
        didChangeSwitchStatusHandler!(sender.isOn)
        self.dismiss(animated: true, completion: nil)
    }
}
