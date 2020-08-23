//
//  FilmViewController.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/22/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class FilmViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    // MARK: - vars and misc.
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filmArray = [Film]()
    var page = 1
    var search = ""
    var searchArray = [String]()
    let defaults = UserDefaults.standard
    var suggestionsController : FilmSearchController!
    var resultsSearchController: UISearchController!
    let maxCount = 10
    @IBOutlet weak var filmTableView: UITableView!
    
    /* custom font  */
    let GillSans = UIFont(name: "Gill Sans", size: UIFont.labelFontSize)
    
    /* custom tint color  */
    let plum = hexStringToUIColor(hex: "#554660")
    
    
    // MARK: - The Child View Controller
    private lazy var filmSearchController: FilmSearchController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "filmSearchController") as! FilmSearchController
        
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        viewController.filmViewController = self
        
        return viewController
    }()
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* remove history for testing
         previously the app would crash if there was no history*/
//        UserDefaults.standard.removeObject(forKey: "searches")
        
        
        
        /* setup the view's controller hierarchy  */ 
        setupView()
        
        
        /* make sure that the searchArray has 10 slots only  */
        searchArray.reserveCapacity(maxCount)
        for _ in 0..<10 {
            searchArray.append(String())
        }
        
        /* set the tableview's delegate and datasource to this class*/
        filmTableView.estimatedRowHeight = 250
        filmTableView.rowHeight = UITableView.automaticDimension
        
        /* suggestionsController controls the behavior of the search suggestion tableView  */
        suggestionsController = FilmSearchController()
        resultsSearchController = UISearchController(searchResultsController: suggestionsController)
        
        loadSearchArray()
        
        /* set up the searchController   */
        self.resultsSearchController = ({
            let controller = UISearchController(searchResultsController: filmSearchController)
            
            /* change the icon of the magnifying glass to white  */
            let glassIconView = controller.searchBar.searchTextField.leftView as! UIImageView
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            glassIconView.tintColor = .white
            
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.view.tintColor = .white
            controller.searchBar.searchTextField.placeholder = "Film title here"
            controller.searchBar.barStyle = .black
            controller.searchBar.barTintColor = plum
            controller.searchBar.backgroundColor = .clear
            controller.searchBar.searchTextField.textColor = .white
            controller.searchBar.searchTextField.font = GillSans
            controller.searchBar.delegate = self
            controller.obscuresBackgroundDuringPresentation = true
            self.filmTableView.tableHeaderView = controller.searchBar
            
            controller.delegate = self
            definesPresentationContext = true
            
            return controller
        })()
        
    }
    
    /* method to ensure that the searchArray is not empty  */
    func loadSearchArray(){
        guard let searchedArray = self.defaults.object(forKey: "searches") as? [String] else { return }
        self.searchArray = searchedArray
    }
    
    // MARK: - table view delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filmTableView.dequeueReusableCell(withIdentifier: "Cell") as! FilmTableViewCell
        
        let film = filmArray[indexPath.row]
        
        cell.titleLabel.text = film.title
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.releaseDateLabel.text = film.release_date
        cell.overViewLabel.text = film.overview
        cell.overViewLabel.adjustsFontSizeToFitWidth = true
        cell.posterImage.load(string: film.poster_path)
        
        return cell
    }
    
    
    // MARK: - API Methods
    
    /* method to show error message  */
    func error(error: FilmManager.FilmErrors){
        let alertController = UIAlertController(title: "An Error Occurred", message: error.localizedDescription, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(dismiss)
        alertController.view.tintColor = plum
        present(alertController, animated: true, completion: nil)
    }
    
    
    /* method to initiate the API Request  */
    func getData(title : String){
        
        FilmManager.shared.getFilmData(query: title, page: String (page))
        { [weak self ] results in
            guard let self = self else {return}
            switch results {
                case .success(let results):
                    
                    self.filmArray = results
                    self.search = title
                    self.updateSearchSuggestions(title: title)
                    self.filmTableView.reloadData()
                
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error(error: error)
                        
                }
                
            }
        }
        
    }
    
    /* call this in the viewDidLoad and setup the child VC  */
    func setupView(){
        updateView()
        reloadChildViews()
    }
    
    /* reload the tableView of the childVC  */
    func reloadChildViews(){
        suggestionsController?.searchTableView.reloadData()
    }
    
    /* this is where showing the controller happens  */
    // MARK: - updateView Method
    private func updateView() {
        
        if searchBar?.searchTextField.isEditing ?? false {
            presentSearchController(resultsSearchController)
            
            self.reloadChildViews()
            
        }
        

        /* this method is to add a childView to the parentView  */
        // MARK: - add a child View
        func add(asChildViewController viewController: UIViewController) {
            // Add Child View as Subview
            view.addSubview(viewController.view)
            
            // Configure Child View
            viewController.view.frame = view.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        
    }
    
    /* this method is to remove a childView from the superView but I didn't end up needing it.   */
    // MARK: - remove a child view
    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}
/* this is for setting the tint color to the same as the one in the storyboard.
 I decided that this was easier than finding the rgb values*/
// MARK: - hexStringToUIColor
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return .gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
