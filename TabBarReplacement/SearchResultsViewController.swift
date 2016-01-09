//
//  SearchResultsViewController.swift
//  TabBarReplacement
//
//  Created by Anthony Picciano on 1/9/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

protocol SearchResultsViewControllerDelegate: class {
    func itemSelected(item: AnyObject)
}

class SearchResultsViewController: UIViewController {
    
    static let storyboardIdentifier = "SearchResultsViewController"
    static let searchResultCellIdentifier = "SearchResultCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resultCountLabel: UILabel!
    @IBOutlet weak var notFoundView: UIView!
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var items: [String] = []
    private var filteredItems: [String] = []
    
    var searchString = "" {
        didSet {
            guard searchString != oldValue else { return }
            
            if searchString.characters.count  < 1 {
                self.filteredItems = []
                self.updateDisplay(true)
            }
            else {
                self.searchFor(searchString)
            }
            
            self.collectionView!.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate items
        items = [ "Amy", "Bonnie", "Cathy", "Dianna", "Ellen", "Francis", "Gabrielle", "Hannah", "Isabelle", "Julie", "Kelly", "Lori", "Mary", "Nancy" ]
        
        self.updateDisplay(true)
    }
    
    func searchFor(searchText: String){
        self.filteredItems = []
        
        // NOTE: filter media items based on string
        self.items.forEach({if $0.lowercaseString.containsString(searchText.lowercaseString){self.filteredItems.append($0)}})
        
        self.updateDisplay()
    }
    
    func updateDisplay(notFoundMessageSuppressed: Bool = false) {
        if self.filteredItems.count == 0 {
            self.notFoundView.hidden = notFoundMessageSuppressed
            self.resultCountLabel.text = Strings.emptyString
        } else {
            self.notFoundView.hidden = true
            self.resultCountLabel.text = "\(self.filteredItems.count) \(self.filteredItems.count == 1 ? Strings.result : Strings.results)"
        }
    }
    
}


extension SearchResultsViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SearchResultsViewController.searchResultCellIdentifier, forIndexPath: indexPath) as! SearchResultCell
        cell.title = filteredItems[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension SearchResultsViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchString = searchController.searchBar.text ?? Strings.emptyString
    }
}