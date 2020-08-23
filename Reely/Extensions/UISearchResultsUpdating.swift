//
//  UISearchResultsUpdating.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/23/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
extension FilmViewController: UISearchResultsUpdating {
    
    // MARK: - searchController Delegate Method
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchedArray = self.defaults.array(forKey: "searches") as? [String],
            let searchSuggestions = searchController.searchResultsController as? FilmSearchController else { return }
        
        self.searchArray = searchedArray
        searchSuggestions.searchedArray = self.searchArray
        filmTableView.reloadData()
        
    }
    
    
    /* check to see if the array has the value   */
    func updateSearchSuggestions(title: String){
        guard searchArray.contains(title) == false else {
            return
        }
        /* if the array is full then replace the first value with the most recent search query  */
        if searchArray.count == 10 {
            searchArray.removeLast()
        }
        searchArray.insert(title, at: 0)
        
        self.defaults.set(self.searchArray, forKey: "searches")
        
        
    }
    
}
