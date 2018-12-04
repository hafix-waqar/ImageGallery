//
//  ImageGalleryVC.swift
//  ImageGallery
//
//  Created by Mutee Ur Rehman on 01/12/2018.
//  Copyright © 2018 Mutee Ur Rehman. All rights reserved.
//

import UIKit
import SVProgressHUD

class ImageGalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    

    //MARK: - IBOUTLETS
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var tagsTextField: UITextField!
    
    //MARK: - PROPERTIES
    var photos: [Photo] = []
    let marginsAndInsets = 10
    let cellsPerRow = 2
    
    //MARK: - VC's LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillLayoutSubviews() {
        guard let collectionView = imagesCollectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
    }

    //MARK: - SERVICE CALLS
    func getPhotosFromServer() {
        weak var weakSelf = self
        SVProgressHUD.show(withStatus: "Loading images")
        ImageService.getImagesBy(tag: tagsTextField.text!, page: 1) { (photos, error) in
            SVProgressHUD.dismiss()
            if weakSelf != nil {
                if error != nil {
                    return
                }
                weakSelf!.photos = photos!
                weakSelf!.imagesCollectionView.reloadData()
            }
        }
    }
    //MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.ImageCollectionViewCell.rawValue, for: indexPath) as! ImageCell
        
        ImageService.getLargeSquarePhotoUrlWith(photoId: photos[indexPath.row].id) { (urlString, error) in
            if error != nil {
                return
            }
            cell.imageView.setImageURL(URL(string: urlString!))
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        // flow layout have all the important info like spacing, inset of collection view cell, fetch it to find out the attributes specified in xib file
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        // subtract section left/ right insets mentioned in xib view
        
        let widthAvailbleForAllItems =  (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)
        
        // Suppose we have to create nColunmns
        // widthForOneItem achieved by sunbtracting item spacing if any
        
        let widthForOneItem = widthAvailbleForAllItems / 2.0 - flowLayout.minimumInteritemSpacing
        
        
        // here height is mentioned in xib file or storyboard
        return CGSize(width: CGFloat(widthForOneItem), height: widthForOneItem )
    }
    
    //MARK: - TEXTFIELD DELEGATES
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getPhotosFromServer()
        return true
    }


}
