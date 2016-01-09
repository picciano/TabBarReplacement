//
//  ViewController.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class ViewController: PITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [
            getViewController(StoryboardIdentifier.ViewController1)!,
            getViewController(StoryboardIdentifier.ViewController2)!,
            getViewController(StoryboardIdentifier.ViewController3)!,
            getViewController(StoryboardIdentifier.ViewController4)!,
            getViewController(StoryboardIdentifier.ViewController5)!,
            getViewController(StoryboardIdentifier.ViewController6)!,
            getViewController(StoryboardIdentifier.ViewController7)!,
            getViewController(StoryboardIdentifier.ViewController8)!,
            getViewController(StoryboardIdentifier.SearchViewController)!,
            getViewController(StoryboardIdentifier.SettingsViewController)!
        ]
        
        self.tabBar.itemSpacing = 60
        self.tabBar.itemOffset = 160
    }

}
