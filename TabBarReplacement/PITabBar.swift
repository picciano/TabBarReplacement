//
//  PITabBar.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

@objc protocol PITabBarDelegate {
    
    optional func tabBar(tabBar: PITabBar, didSelectItem item: UITabBarItem)
    optional func tabBar(tabBar: PITabBar, didPrimaryAction item: UITabBarItem)
    
}

class PITabBar: UIView {
    weak var delegate: PITabBarDelegate?
    weak var selectedItem: UITabBarItem?
    
    private var _shadowImageView: UIImageView!
    private var _focusGuide: UIFocusGuide!
    private var _buttonDictionary = [UITabBarItem: PITabBarButton]()
    
    private struct Constants {
        static let shadowImageHeight = CGFloat(10.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        _shadowImageView = UIImageView()
        _shadowImageView.contentMode = .ScaleToFill
        _focusGuide = UIFocusGuide()
        
        self.addSubview(_shadowImageView)
        self.addLayoutGuide(_focusGuide)
    }
    
    func setPreferredFocusedView(view: UIView) {
        if view == self {
            _focusGuide.preferredFocusedView = _buttonDictionary[selectedItem!]
        } else {
            _focusGuide.preferredFocusedView = view
        }
    }
    
    var items: [UITabBarItem]? {
        
        didSet {
            self.setNeedsDisplay()
        }
        
    }
    
    func setItems(items: [UITabBarItem]?, animated: Bool) {
        self.items = items
        self.updateDisplay()
    }
    
    var barTintColor: UIColor?
    var itemSpacing: CGFloat = 40.0
    var itemOffset: CGFloat = 0.0
    var itemWidth: CGFloat = CGFloat.NaN
    var translucent: Bool = true
    var backgroundImage: UIImage?
    var selectionIndicatorImage: UIImage?
    
    var titleColor = UIColor.grayColor() {
        
        didSet {
            configureButtons()
        }
        
    }
    
    var focusedTitleColor = UIColor.whiteColor() {
        
        didSet {
            configureButtons()
        }
        
    }
    
    var shadowImage: UIImage? {
        
        didSet {
            _shadowImageView.image = shadowImage
        }
        
    }
    
    func updateDisplay() {
        subviews.forEach { if ($0 is PITabBarButton) { $0.removeFromSuperview() } }
        
        if let items = items {
            for (index, item) in items.enumerate() {
                let button = PITabBarButton(type: .Custom)
                button.tag = index
                configure(button, item: item)
                button.addTarget(self, action: "buttonPressed:event:", forControlEvents: .PrimaryActionTriggered)
                button.sizeToFit()
                
                _buttonDictionary[item] = button
                self.addSubview(button)
            }
        }
    }
    
    private func configureButtons() {
        let buttons = subviews.filter { $0 is PITabBarButton }
        
        for (index, subview) in buttons.enumerate() {
            if let button = subview as? PITabBarButton {
                configure(button, item: items![index])
            }
        }
    }
    
    private func configure(button: PITabBarButton, item: UITabBarItem) {
        button.setImage(item.image, forState: .Normal)
        button.setImage(item.selectedImage, forState: .Focused)
        button.setTitle(item.title, forState: .Normal)
        
        let attributes = item.titleTextAttributesForState(.Normal)
        let color = attributes?[NSForegroundColorAttributeName] as? UIColor ?? titleColor
        button.setTitleColor(color, forState: .Normal)
        
        let focusedAttributes = item.titleTextAttributesForState(.Focused)
        let focusedColor = focusedAttributes?[NSForegroundColorAttributeName] as? UIColor ?? focusedTitleColor
        button.setTitleColor(focusedColor, forState: .Focused)
    }
    
    func buttonPressed(button: UIButton!, event: UIEvent?) {
        guard let delegate = delegate else { return }
        guard let items = items else { return }
        
        let item = items[button.tag]
        delegate.tabBar?(self, didPrimaryAction: item)
    }
    
    override func layoutSubviews() {
        var sumOfSubviewWidths:CGFloat = 0.0
        let sumOfItemSpacing:CGFloat = CGFloat(items?.count ?? 0) * itemSpacing
        
        for subview in subviews {
            if subview is PITabBarButton {
                sumOfSubviewWidths += subview.frame.size.width
            }
        }
        
        var xPos: CGFloat = ( self.frame.width - (sumOfSubviewWidths + sumOfItemSpacing) ) / 2.0 + itemOffset
        
        for subview in subviews {
            switch subview {
            case is PITabBarButton:
                var frame = CGRectZero
                frame.size = subview.frame.size
                frame.origin.y = (140.0 - subview.frame.size.height) / 2.0
                frame.origin.x = xPos
                subview.frame = frame
                xPos += subview.frame.width + itemSpacing
            case _shadowImageView:
                _shadowImageView.frame = CGRectMake(0.0, self.frame.height, self.frame.width, Constants.shadowImageHeight)
            default:
                break
            }
            
        }
        
        _focusGuide.widthAnchor.constraintEqualToAnchor(_shadowImageView.widthAnchor).active = true
        _focusGuide.heightAnchor.constraintEqualToAnchor(_shadowImageView.heightAnchor).active = true
        _focusGuide.centerXAnchor.constraintEqualToAnchor(_shadowImageView.centerXAnchor).active = true
        _focusGuide.centerYAnchor.constraintEqualToAnchor(_shadowImageView.centerYAnchor).active = true
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        guard let delegate = delegate else { return }
        guard let items = items else { return }
        guard let nextFocusedView = context.nextFocusedView else { return }
        
        switch nextFocusedView {
        case is PITabBarButton:
            let item = items[nextFocusedView.tag]
            delegate.tabBar?(self, didSelectItem: item)
        default:
            break
        }
    }
    
    override weak var preferredFocusedView: UIView? {
        if let selectedItem = selectedItem {
            return _buttonDictionary[selectedItem]
        }
        
        return super.preferredFocusedView
    }

}
