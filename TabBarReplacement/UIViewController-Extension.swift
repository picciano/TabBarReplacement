//
//  UIViewController-Extension.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

struct StoryboardName {
    static let Main = "Main"
}

struct StoryboardIdentifier {
    static let ViewController1              = "ViewController1"
    static let ViewController2              = "ViewController2"
    static let ViewController3              = "ViewController3"
    static let ViewController4              = "ViewController4"
    static let ViewController5              = "ViewController5"
    static let ViewController6              = "ViewController6"
    static let ViewController7              = "ViewController7"
    static let ViewController8              = "ViewController8"
    static let SearchViewController         = "SearchViewController"
    static let SearchResultsViewController  = "SearchResultsViewController"
    static let SettingsViewController       = "SettingsViewController"
}

extension UIViewController {
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    /// Get the main storyboard
    /// \return - the main storyboard
    ///////////////////////////////////////////////////////////////////////////////////////////////
    func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: StoryboardName.Main, bundle: nil)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    /// Get view controller from the specified storyboard
    /// \param storyboardName - The name of the storyboard
    /// \param identifier - The view controller identifier
    /// \return - The desired view controller
    ///////////////////////////////////////////////////////////////////////////////////////////////
    func getViewControllerWithStoryboardName(storyboardName: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    /// Get view controller from the specified storyboard
    /// \param storyboardName - The name of the storyboard
    /// \param identifier - The view controller identifier
    /// \return - The desired view controller
    ///////////////////////////////////////////////////////////////////////////////////////////////
    func getViewController(identifier: String) -> UIViewController? {
        return getMainStoryboard().instantiateViewControllerWithIdentifier(identifier)
    }
}