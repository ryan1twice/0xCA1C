//
//  byteVC.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/26/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import UIKit

class calcVC: UIViewController {
    
    // Label sets for deactivating
    @IBOutlet private var nonBinaryLabels: [UIButton]!
    @IBOutlet private var nonOctalLabels: [UIButton]!
    @IBOutlet private var nonDecLabels: [UIButton]!
    @IBOutlet private var binaryoperationLabels: [UIButton]!
    @IBOutlet private var unaryOctalLabels: [UIButton]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dimLabels(section: nonBinaryLabels)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dimLabels(section: [UIButton]) {
        for label in section {
            label.alpha = 0.5
            label.isEnabled = false
        }
    }

}
