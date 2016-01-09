//
//  PITabBarButton.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class PITabBarButton: UIButton {
    
    override func sizeToFit() {
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        super.sizeToFit()
    }

}
