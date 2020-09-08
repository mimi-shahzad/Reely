//
//  UISearchBarDelegate.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/22/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@available(iOS 13.0, *)


// MARK: - extension: SearchBar
extension FilmViewController :  UISearchControllerDelegate{
    
    
    /* decide whether or not the controller should appear  */
    func presentSearchController(_ searchController: UISearchController) {
        if #available(iOS 13.0, *) {
            searchController.showsSearchResultsController = true
        } else {
            show(searchController.searchResultsController!, sender: nil )
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        guard let searchedString = searchBar.text, !searchedString.isEmpty else {
            return
            
        }
        
        getData(title: searchedString)
        self.suggestionsController?.searchTableView?.reloadData()
        self.resultsSearchController.isActive = false
        resultsSearchController.dismiss(animated: true, completion: nil)
    }
    
    
}


