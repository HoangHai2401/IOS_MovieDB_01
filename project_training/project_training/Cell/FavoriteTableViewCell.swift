//
//  FavoriteTableViewCell.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/16/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setContentForCell(movie: Movie) {
        if let url = movie.getFullLink() {
            movieImageView.downloadedFrom(link: url)
        }
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
    }
}
