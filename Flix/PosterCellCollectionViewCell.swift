//
//  PosterCellCollectionViewCell.swift
//  Flix
//
//  Created by Chavane Minto on 6/23/17.
//  Copyright © 2017 Chavane Minto. All rights reserved.
//

import UIKit
import AlamofireImage

class PosterCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            
            posterImageView.af_setImage(withURL: movie.posterPathURL!)
            
        }
    }

    
}
