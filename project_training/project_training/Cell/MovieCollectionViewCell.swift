//
//  MovieCollectionViewCell.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setElementForCell()
    }

    public func setElementForCell() {
        itemImageView.contentMode = .scaleToFill
        itemLabel.textAlignment = .center
        itemLabel.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }

    public func setContentForCell(movie: Movie) {
        if let url = movie.getFullLink() {
            itemImageView.downloadedFrom(link: url)
            itemLabel.text = movie.title
        }
    }
}
