//
//  PITabBarController.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class PITabBarController: UIViewController {
    weak var delegate: UITabBarControllerDelegate?
    
    var tabBar: PITabBar { get { return _tabBar } }
    
    private var _tabBar: PITabBar
    private var _selectedIndex: Int?
    private var _contentView: UIView!
    private var _viewControllerDictionary = [UITabBarItem: UIViewController]()
    private var _tapMenuGestureRec: UITapGestureRecognizer!
    
    private struct Constants {
        static let tabBarWidth = CGFloat(1920)
        static let tabBarHeight = CGFloat(140)
        static let initialTabBarFrame = CGRectMake(0, 0, tabBarWidth, tabBarHeight)
        static let viewTransitionAnimationDuration = 0.5
        static let tabBarAnimationDuration = 0.3
    }
    
    required init?(coder aDecoder: NSCoder) {
        _tabBar = PITabBar()
        _contentView = UIView()
        
        super.init(coder: aDecoder);
        
        _tabBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        _tabBar.frame = Constants.initialTabBarFrame
        _contentView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(_tabBar, atIndex: 0)
        view.insertSubview(_contentView, atIndex: 0)
        
        _tapMenuGestureRec = UITapGestureRecognizer(target: self, action: "tapMenu:")
        _tapMenuGestureRec.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        _tapMenuGestureRec.delegate = self
        view.addGestureRecognizer(_tapMenuGestureRec)
    }
    
    func tapMenu(recognizer: UITapGestureRecognizer) {
        if tabBarHidden {
            tabBarHidden = false
            setNeedsFocusUpdate()
        }
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let nextFocusedView = context.nextFocusedView {
            tabBarHidden = !(nextFocusedView is PITabBarButton)
        }
    }
    
    override weak var preferredFocusedView: UIView? {
        
        if tabBarHidden {
            return selectedViewController?.view
        }
        
        if let target = _tabBar.preferredFocusedView {
            return target
        }
        
        return super.preferredFocusedView
    }
    
    @IBOutlet var viewControllers: [UIViewController]! {
        
        didSet {
            var items: [UITabBarItem] = []
            
            for viewController in viewControllers {
                items.append(viewController.tabBarItem)
                
                _viewControllerDictionary[viewController.tabBarItem] = viewController
            }
            
            tabBar.setItems(items, animated: false)
        }
        
    }
    
    weak var selectedViewController: UIViewController? {
        
        get {
            if let selectedIndex = _selectedIndex where selectedIndex < viewControllers.count {
                return viewControllers[selectedIndex]
            }
            
            return nil
        }
        
        set {
            if newValue != nil && viewControllers.contains(newValue!) {
                _selectedIndex = viewControllers.indexOf(newValue!)
                _tabBar.selectedItem = newValue!.tabBarItem
            } else {
                _selectedIndex = nil
                _tabBar.selectedItem = nil
            }
        }
        
    }
    
    private func selectItem(item: UITabBarItem) {
        // If toViewController is nil, just return.
        guard let toViewController = _viewControllerDictionary[item] else { return }
        
        let fromViewController = selectedViewController
        
        // If it's the same view controller, just return.
        if fromViewController == toViewController { return }
        
        // If it's a new child view controller, add it to child array.
        let isNewChildViewController = !childViewControllers.contains(toViewController)
        if isNewChildViewController {
            addChildViewController(toViewController)
        }
        
        // Set the toViewController.view frame onto the _contentView
        toViewController.view.frame = self._contentView.bounds
        
        // Finish the new child view controller move to parent.
        if isNewChildViewController {
            toViewController.didMoveToParentViewController(self)
        }
        
        // Configure for the new tab
        selectedViewController = toViewController
        _tabBar.setPreferredFocusedView((toViewController.view)!)
        
        /* If the fromViewController is not nil, animate the change */
        if let fromViewController = fromViewController {
            UIView.transitionFromView(fromViewController.view, toView: toViewController.view, duration: 0.5, options: [.TransitionCrossDissolve, .AllowUserInteraction, .BeginFromCurrentState], completion: { (finished) -> Void in
            })
        } else {    /* The fromViewController is nil, just set the toViewController without animation */
            // Finish the two view controllers change
            _contentView.addSubview((toViewController.view)!)
        }
    }
    
    private var tabBarHidden = false {
        
        willSet {
            if newValue {
                tabBarWillHide(animated: true)
            } else {
                tabBarWillShow(animated: true)
            }
        }
        
        didSet {
            if tabBarHidden {
                tabBarDidHide(animated: true)
            } else {
                tabBarDidShow(animated: true)
            }
            
            if oldValue != tabBarHidden {
                UIView.animateWithDuration(Constants.tabBarAnimationDuration, animations: { () -> Void in
                    self._tabBar.layer.transform = self.tabBarHidden ? CATransform3DMakeTranslation(0.0, Constants.tabBarHeight * -1, 0.0) : CATransform3DIdentity
                })
            }
            
            _tabBar.setPreferredFocusedView(tabBarHidden ? _tabBar : selectedViewController!.view)
        }
        
    }
    
    func tabBarWillHide(animated animated: Bool) {}
    func tabBarWillShow(animated animated: Bool) {}
    func tabBarDidHide(animated animated: Bool) {}
    func tabBarDidShow(animated animated: Bool) {}
    
}

extension PITabBarController : PITabBarDelegate {
    
    func tabBar(tabBar: PITabBar, didSelectItem item: UITabBarItem) {
        self.selectItem(item)
    }
    
    func tabBar(tabBar: PITabBar, didPrimaryAction item: UITabBarItem) {
        tabBarHidden = true
        self.setNeedsFocusUpdate()
    }
    
}

extension PITabBarController : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === _tapMenuGestureRec {
            return tabBarHidden
        }
        
        return true
    }
    
}
