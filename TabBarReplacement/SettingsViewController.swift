//
//  SettingsViewController.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tabBarItem.image = TabBarReplacementStyleKit.imageOfSettings(focused: false)
        self.tabBarItem.selectedImage = TabBarReplacementStyleKit.imageOfSettings(focused: true)
    }

}
