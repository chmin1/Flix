//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Chavane Minto on 6/21/17.
//  Copyright © 2017 Chavane Minto. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Global variable used to hold dictionary of moives
    
    var movies: [[String: Any]] = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl() //used to refresh app
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        fetchMovies()
        
        
    }
    
    //function to see if user pulled down to refresh
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        //Create Network Request: url, request, session & task
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=fe2f217e9c2c68b9ea9de1fe42905fb0")
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                //grab a dictionary of JSON objects. in this case, movie objects.
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //grab a dictionary of objects nested inside of the original dictionary. This is a dictionary of "results"
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create cell that calls to your custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        //grab movie info at index of the array for cell
        let movie = movies[indexPath.row]
        //for each movie, the cell will grab 3 things:
        let title = movie["title"] as! String // grabs the movie title from dictionary
        let overview = movie["overview"] as! String // grabs the movie overview from dictionary
        
        // Third will be the image. this requires multiple components: the poster path and the base URL:
        let posterPathString = movie["poster_path"] as! String //grabs the posterpath needed for the URL of the image
        let baseURLString = "https://image.tmdb.org/t/p/w500" //hardcoded the base URL of the image source
        
        // combine the two above for the URL source of the movie image
        let posterURL = URL(string: baseURLString + posterPathString)!
        
        //pass info from dictionaries to the components of custom cell
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
