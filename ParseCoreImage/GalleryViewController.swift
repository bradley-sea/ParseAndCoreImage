//
//  GalleryViewController.swift
//  ParseCoreImage
//
//  Created by Bradley Johnson on 3/5/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit
import Photos

protocol GalleryDelegate: class {
  func userDidSelectImage(image : UIImage)
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  @IBOutlet weak var collectionView: UICollectionView!
  
  weak var delegate : GalleryDelegate!
  var scale : CGFloat = 1.0
  
  //photos framework properties
  var assetsFetchResults : PHFetchResult!
  var assetCollection : PHAssetCollection!
  var imageManager = PHCachingImageManager()
  var destinationImageSize : CGSize!
  
  var flowLayout : UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.imageManager = PHCachingImageManager()
      self.assetsFetchResults = PHAsset.fetchAssetsWithOptions(nil)

      
      self.collectionView.dataSource = self
      self.collectionView.delegate = self
      let pinch = UIPinchGestureRecognizer(target: self, action: "pinchRecognized:")
  self.collectionView.addGestureRecognizer(pinch)
      
      self.flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      
      
      
        // Do any additional setup after loading the view.
    }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.assetsFetchResults.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! GalleryCell
    
    let asset = self.assetsFetchResults[indexPath.row] as! PHAsset
    self.imageManager.requestImageForAsset(asset, targetSize: self.flowLayout.itemSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (requestedImage, info) -> Void in
      cell.imageView.image = requestedImage
    }

    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(75 * self.scale, 75 * self.scale)
  }
  
  func pinchRecognized(sender : UIPinchGestureRecognizer) {
    
    if sender.state == UIGestureRecognizerState.Changed {
      self.scale = sender.scale
      self.collectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    let asset = self.assetsFetchResults[indexPath.row] as! PHAsset
    self.imageManager.requestImageForAsset(asset, targetSize: CGSize(width: 300, height: 400), contentMode: PHImageContentMode.AspectFill, options: nil) { (requestedImage, info) -> Void in
     self.delegate?.userDidSelectImage(requestedImage)
      self.navigationController?.popToRootViewControllerAnimated(true)
    }

  }



}
