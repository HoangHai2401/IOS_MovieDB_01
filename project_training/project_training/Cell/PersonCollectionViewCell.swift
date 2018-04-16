//
//  PersonCollectionViewCell.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/10/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personCharacterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentOfCell(person: Person) {
        if let url = person.getFullLink() {
            personImageView.downloadedFrom(link: url)
        }
        personNameLabel.text = person.name
        if let character = person.character {
            personCharacterLabel.text = character
        } else {
            personCharacterLabel.text = person.personJob
        }
    }
}
