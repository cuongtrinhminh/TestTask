//
//  MainViewController.swift
//  TestTask
//
//  Created by Trinh Cuong on 24/01/2021.
//

import UIKit

class MainViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "ImageCell"
    private let networkUtility = ImageUtility()
    private var imageDataList : [Data] = [Data]()
    private var itemPerRow = 7
    private var itemSpacing = 2
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self;
        collectionView.delegate = self;
    }
    
    private func addNewImage() {
        self.indicator.startAnimating()
        networkUtility.addNewImage(for: "") { (result) in
            switch result {
            case .success(let data) :
                self.imageDataList.append(data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
                }
            case .failure(let error) :
                print("Could not load the random image cause \(error)")
            }
        }
    }
}

// MARK : - UIBarButtonItemFunction
extension MainViewController {
    
    @IBAction func reloadAllPressed(_ sender: UIBarButtonItem) {
        self.indicator.startAnimating()
        imageDataList.removeAll()
        collectionView.reloadData()
        for _ in 0...Constants.numberImagesToReload-1 {
            addNewImage()
        }
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        self.addNewImage()
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = UIImage(data: self.imageDataList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacingBetweenItems = (itemPerRow-1)*itemSpacing
        let itemWidth = (Int(collectionView.frame.width) - totalSpacingBetweenItems)/itemPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}

