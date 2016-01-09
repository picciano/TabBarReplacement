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
            self.setNeedsFocusUpdate()
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
        let fromViewController = self.selectedViewController
        let toViewController = _viewControllerDictionary[item]
        
        if fromViewController == toViewController { return }
        
        selectedViewController = toViewController
        
        fromViewController?.viewWillDisappear(true)
        toViewController?.viewWillAppear(true)
        
        if let view = toViewController?.view {
            view.frame = _contentView.bounds
            view.alpha = 0.0
            _contentView.addSubview(view)
            _tabBar.setPreferredFocusedView(view)
            
            UIView.animateWithDuration(Constants.viewTransitionAnimationDuration, animations: { () -> Void in
                view.alpha = 1.0
                fromViewController?.view.alpha = 0.0
                }, completion: { (completed) -> Void in
                    fromViewController?.view.removeFromSuperview()
                    fromViewController?.viewDidDisappear(true)
            })
        }
        
        toViewController?.viewDidAppear(true)
    }
    
    private var tabBarHidden = false {
        
        didSet {
            if oldValue != tabBarHidden {
                UIView.animateWithDuration(Constants.tabBarAnimationDuration, animations: { () -> Void in
                    self._tabBar.layer.transform = self.tabBarHidden ? CATransform3DMakeTranslation(0.0, Constants.tabBarHeight * -1, 0.0) : CATransform3DIdentity
                })
            }
            
            _tabBar.setPreferredFocusedView(tabBarHidden ? _tabBar : selectedViewController!.view)
        }
        
    }
    
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
