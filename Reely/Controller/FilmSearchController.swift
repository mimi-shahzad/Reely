//
//  FilmSearchController.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/23/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation
import UIKit


@available(iOS 13.0, *)
class FilmSearchController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var searchedArray = [String]()
    let GillSans = UIFont(name: "Gill Sans", size: UIFont.labelFontSize)
    
    var filmViewController : FilmViewController?
    let plum = hexStringToUIColor(hex: "#554660")
    let maxSearchResultCount = 10
    
    @IBOutlet weak var searchTableView: UITableView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* set the delegates to the tableView  */
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.reloadData()
        
    }
    
    /* make the API request and reload the tableView  */
    func search(title: String){
        
        filmViewController?.getData(title: title)
        filmViewController?.filmTableView.reloadData()
    }
    
    
    // MARK: - viewWillAppear() & viewWillDisappear() for testing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Search Controller Will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Search View Controller Will Disappear")
    }
    
    
    // MARK: - tableView delegate methods.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchBarCell")! as! SearchBarCell
        
        /* if the amount of cells is less than the size of the array
         note: the array holds the search query titles */
        guard indexPath.row < searchedArray.count else { return cell }
        
        //set the name of the search suggestions to be the previously entered values
        cell.textLabel?.text = searchedArray[indexPath.row]
        cell.textLabel?.textColor = plum
        cell.textLabel?.font = GillSans
        cell.backgroundColor = .white
        cell.contentView.tintColor = plum
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxSearchResultCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTableView.reloadData()
        search(title: searchedArray[indexPath.row])
        filmViewController?.filmTableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
}


