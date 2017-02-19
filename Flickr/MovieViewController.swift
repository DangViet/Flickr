//
//  MovieViewController.swift
//  Flickr
//
//  Created by Viet Dang Ba on 2/16/17.
//  Copyright © 2017 Viet Dang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableMovie: UITableView!
    
    let baseURL = "http://image.tmdb.org/t/p/w300"
    var endpoint:String = ""
    
    var movies = [NSDictionary]()
    var filterMovies = [NSDictionary]()
    
    @IBOutlet weak var naviBar: UINavigationItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segView: UISegmentedControl!
    
    @IBOutlet weak var errorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.isHidden = true
        
        segView.layer.borderColor = UIColor.white.cgColor;
        segView.layer.cornerRadius = 0.0;
        segView.layer.borderWidth = 4;
        
        // Do any additional setup after loading the view.
        self.naviBar.titleView = self.searchBar;
        //self.tableMovie.tableHeaderView = self.segView
    
        // Initilize table view
        tableMovie.delegate = self
        tableMovie.dataSource = self
        
        // Initilize search bar
        searchBar.delegate = self

        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MovieViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableMovie.insertSubview(refreshControl, at: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "http://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                
                                // Hide HUD once the network request comes back (must be done on main UI thread)
                                MBProgressHUD.hide(for: self.view, animated: true)
                                print("error: \(error)")
                                if error != nil {
                                    self.errorView.isHidden = false
                                } else {
                                    self.errorView.isHidden = true
                                    if let data = dataOrNil {
                                        if let responseDictionary = try! JSONSerialization.jsonObject(
                                            with: data, options:[]) as? NSDictionary {
                                            
                                            self.movies = responseDictionary["results"] as! [NSDictionary]
                                            self.filterMovies = self.movies
                                            
                                            self.tableMovie.reloadData()
                                        }
                                    }
                                }
            })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.filterMovies.count
        
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = UITableViewCell()
//        cell.textLabel?.text = self.movies[indexPath.row]["title"] as! String
        
        let cell = tableMovie.dequeueReusableCell(withIdentifier: "movieCell") as! MovieViewCell
//        cell.lblTiltle.text = self.movies[indexPath.row]["title"] as! String
//        cell.lblOverview.text = self.movies[indexPath.row]["overview"] as! String
//        
//        
//        if let imgPath = self.movies[indexPath.row]["poster_path"] as? String{
//            let imgURL = baseURL + imgPath
//            cell.imgPoster.setImageWith(NSURL(string: imgURL) as! URL)
//        }
        cell.lblTiltle.text = self.filterMovies[indexPath.row]["title"] as! String
        cell.lblOverview.text = self.filterMovies[indexPath.row]["overview"] as! String
        
        
        if let imgPath = self.filterMovies[indexPath.row]["poster_path"] as? String{
            let imgURL = baseURL + imgPath
            cell.imgPoster.setImageWith(NSURL(string: imgURL) as! URL)
        }

        
        return cell
    }
    
    // Called after the user changes the selection.
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! MovieDetailsViewController
        
        detailView.movieDetail = self.filterMovies[(self.tableMovie.indexPathForSelectedRow?.row)!]
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "http://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if error != nil {
                                    self.errorView.isHidden = false
                                } else {
                                    self.errorView.isHidden = true
                                    if let data = dataOrNil {
                                        if let responseDictionary = try! JSONSerialization.jsonObject(
                                            with: data, options:[]) as? NSDictionary {
                                            
                                            self.movies = responseDictionary["results"] as! [NSDictionary]
                                            
                                            self.searchBar(self.searchBar, textDidChange: self.searchBar.text!)
                                            
                                            self.tableMovie.reloadData()
                                            
                                        }
                                    }
                                }
                                refreshControl.endRefreshing()
                                
            })
        task.resume()

    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        filterMovies = movies
        self.tableMovie.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText != ""){
            let searchPredicate = NSPredicate(format: "title CONTAINS[C] %@", searchText)
            filterMovies = ((movies as NSArray).filtered(using: searchPredicate) as? [NSDictionary])!
        } else {
            filterMovies = movies
        }
        
        
        self.tableMovie.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchBar.endEditing(true)
    }
    
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
