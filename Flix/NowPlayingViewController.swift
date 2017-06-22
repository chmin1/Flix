//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Chavane Minto on 6/21/17.
//  Copyright © 2017 Chavane Minto. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
                //use a for loop to go thruogh the array of objects
                for movie in movies {
                    //store the "title" key-value pairs in the array of objects
                    let title = movie["title"] as! String
                    print(title)
                }
                
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
