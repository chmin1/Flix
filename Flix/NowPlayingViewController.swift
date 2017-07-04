//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Chavane Minto on 6/21/17.
//  Copyright © 2017 Chavane Minto. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Global variable used to hold dictionary of moives
    
    var movies: [Movie] = []
    
    var refreshControl: UIRefreshControl!
    var alertController: UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        HUD.flash(.progress, delay: 10)
        activityIndicator.startAnimating()
        
        refreshControl = UIRefreshControl() //used to refresh app
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        isConnected()
        fetchMovies()
        
    }
    
    //function to see if user pulled down to refresh
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    
    func fetchMovies() {
        
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                HUD.flash(.success, delay: 1.0)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create cell that calls to your custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.movie = movies[indexPath.row]
        
        
        return cell
    }
    
    //segue Movie information to the DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get selected cell
        let cell = sender as! UITableViewCell
        //Grab the index of the selected cell (if not nil)
        if let indexPath = tableView.indexPath(for: cell) {
            //grab the movie information from the cell at this index
            let movie = movies[indexPath.row]
            
            // create segue controller
            let detailVC = segue.destination as! DetailViewController
            
            //pass info from the indexed movie dictionary to the detail view controller dictionary
            detailVC.movie = movie
        }
    }
    
    // function to check if connected to internet
    func isConnected() {
        self.alertController = UIAlertController(title: "Network Error", message: "Make sure you are connected to the internet", preferredStyle: .alert)
        
        //try to connect again
        let connect = UIAlertAction(title: "Connect", style: .cancel) { (action) in
            self.fetchMovies()
        }
        
        // add action to alertController
        alertController.addAction(connect)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
