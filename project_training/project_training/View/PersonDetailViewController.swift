//
//  PersonDetailViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/13/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class PersonDetailViewController: BaseViewController, AlertViewControllerExtension {
    var personId: Int?
    var movieList = [Movie]()
    var heightDescription = 0

    let cellsPerRow = 5
    private let personRepository: PersonRepository = PersonRepositoryImpl(api: ApiService.share)
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    @IBOutlet weak var personBackgroundImageView: UIImageView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personPlaceOfBirthLabel: UILabel!
    @IBOutlet weak var personBirthDayLabel: UILabel!
    @IBOutlet weak var personOverViewLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var overviewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var officeSiteLabel: UILabel!
    @IBOutlet weak var alsoKnownAsLabel: UILabel!

    @IBAction func seeMoreButtonAction(_ sender: Any) {
        overviewHeightContraint.constant = CGFloat(heightDescription)
        seeMoreButton.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setView() {
        if let personId = personId {
            getData(personId: personId)
        }
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }

    func getData(personId: Int) {
        personRepository.getPersonDetail(personId: personId, page: 1) { result in
            switch result {
            case .success(let data):
                if let personData = data {
                    DispatchQueue.main.async {
                        if let imageUrl = personData.getFullLink() {
                            self.personImageView.downloadedFrom(link: imageUrl)
                        }
                        self.personImageView.contentMode = .scaleToFill
                        self.personNameLabel.text = personData.name
                        if let description = personData.biography {
                            let descriptionBounds = TextSize.size(description,
                                                                  font: UIFont.systemFont(ofSize: 13.0),
                                                                  width: self.descriptionView.frame.width)
                            if descriptionBounds.height > 70 {
                                self.seeMoreButton.isHidden = false
                                self.heightDescription = Int(descriptionBounds.height)
                            } else {
                                self.seeMoreButton.isHidden = true
                                self.overviewHeightContraint.constant = descriptionBounds.height
                            }
                            self.personOverViewLabel.text = description
                        }
                        if let gender = personData.gender {
                            self.genderLabel.text = "Gender: " + Common.getGender(gender: gender)
                        }
                        let placeOfBirth = personData.placeOfBirth ?? Common.defaultResult
                            self.personPlaceOfBirthLabel.text = "Place of birth: " + placeOfBirth
                        let birthday = personData.birthday ?? Common.defaultResult
                            self.personBirthDayLabel.text = "Birthday: " + birthday
                        if let alsoKnownAs = personData.alsoKnownAs {
                            var alsoKnownAsString = ""
                            for item in alsoKnownAs {
                                alsoKnownAsString += item + "\n"
                            }
                            self.alsoKnownAsLabel.text = alsoKnownAsString
                        } else {
                            self.alsoKnownAsLabel.text = "no info"
                        }
                    }
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
            }
            self.getMovieByPerson(personId: personId)
        }
    }

    func getMovieByPerson(personId: Int) {
        movieRepository.getMovieByPerson(personId: personId, page: 1) { result in
            switch result {
            case .success(let MovieList):
                if let castList = MovieList?.castList {
                    self.movieList += castList
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
            }
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
}

extension PersonDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(
            withIdentifier: "detailViewController") as? DetailMovieViewController
        viewController?.movieData = self.movieList[indexPath.row]
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}

// MARK: extension UICollectionViewDataSource for movieCollectionView in PersonDetailViewController
extension PersonDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(movieList.count)
        return movieList.count > Common.numberCellInRow ? Common.numberCellInRow : movieList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                            for: indexPath) as? MovieCollectionViewCell else {
                                                                let cell = collectionView.dequeueReusableCell(
                                                                    withReuseIdentifier: "MovieCollectionViewCell",
                                                                    for: indexPath)
                                                                return cell
        }
        if movieList.count > indexPath.row {
            cell.setContentForCell(movie: movieList[indexPath.row])
        }
        return cell
    }
}

// MARK: extension UICollectionViewDelegateFlowLayout for movieCollectionView in PersonDetailViewController
extension PersonDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
        let width = Int(CGFloat(collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        let height = Int(CGFloat(collectionView.bounds.width * 1.5) / CGFloat(cellsPerRow))
        return CGSize(width: width, height: height)
    }
}
