//
//  SearchViewController.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class SearchViewController: UINavigationController {
    
    static let searchBarVerticalOffset = CGFloat(80)
    
    var adjustedSearchBarFrame = CGRectZero
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tabBarItem.image = TabBarReplacementStyleKit.imageOfSearch(focused: false)
        self.tabBarItem.selectedImage = TabBarReplacementStyleKit.imageOfSearch(focused: true)
        self.addContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // NOTE: Move the search controller down so that it is below the tab bar
        if let container = self.viewControllers.first as? UISearchContainerViewController {
            if  adjustedSearchBarFrame == CGRectZero {
                adjustedSearchBarFrame = container.searchController.view.frame
                adjustedSearchBarFrame.origin.y = SearchViewController.searchBarVerticalOffset
                adjustedSearchBarFrame.size.height = adjustedSearchBarFrame.size.height - SearchViewController.searchBarVerticalOffset
            }
            
            container.searchController.view.frame = adjustedSearchBarFrame
        }
    }
    
    func addContent() {
        let resultsController = self.getViewControllerWithStoryboardName(StoryboardName.Main, identifier: StoryboardIdentifier.SearchResultsViewController) as! SearchResultsViewController
        resultsController.delegate = self
        
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        searchController.searchBar.keyboardAppearance = .Dark
        searchController.searchBar.placeholder = Strings.searchFieldPlaceholderText
        searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 0);
        
        // Hide obscurity layer for tvOS 9.1 (not available in tvOS 9.0)
        if #available(tvOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        
        let container = UISearchContainerViewController(searchController: searchController)
        
        self.viewControllers = [container]
    }
    
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    
    func itemSelected(item: AnyObject) {
        // TODO: Implement this
    }
    
}