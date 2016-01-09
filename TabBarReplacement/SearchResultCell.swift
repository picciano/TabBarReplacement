//
//  SearchResultCell.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var title = "" {
        
        didSet {
            titleLabel.text = title
        }
        
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        var transform: CGAffineTransform!
        
        if context.previouslyFocusedView == self {
            transform = CGAffineTransformIdentity
        } else {
            transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 35), 1.2, 1.2)
        }
        
        if let titleLabel = self.titleLabel {
            coordinator.addCoordinatedAnimations({
                titleLabel.transform = transform
                }, completion: nil)
        }
    }
    
}
