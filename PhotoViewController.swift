//
//  PhotoViewController.swift
//  ParseCoreImage
//
//  Created by Bradley Johnson on 3/2/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit
import CoreImage

class PhotoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, GalleryDelegate {

  @IBOutlet weak var imageView: UIImageView!
  let alertView = UIAlertController(title: "Options", message: "Select an Option", preferredStyle: UIAlertControllerStyle.ActionSheet)
  var gpuContext : CIContext!
  var filters = Array<(UIImage, CIContext)->(UIImage)>()
  var thumbnail : UIImage!
  
  var currentImage : UIImage! {
    didSet(previousImage) {
      self.imageView.image = currentImage
      self.thumbnail = self.createThumbnail(currentImage)
      self.collectionView.reloadData()
    }
  }

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var photoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post"
      self.tabBarItem = UITabBarItem(title: "Post", image: UIImage(named: "picture-50"), selectedImage: UIImage(named: "picture-50"))
      self.currentImage = UIImage(named: "photo.jpg")
      //setup GPU context
      let options = [kCIContextWorkingColorSpace : NSNull()] // helps keep things fast
      let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
      self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
      self.filters.append(Filters.blur)
      self.filters.append(Filters.instant)
      self.filters.append(Filters.chrome)
      self.filters.append(Filters.noir)
      self.filters.append(Filters.sepia)
      self.thumbnail = self.createThumbnail(self.imageView.image!)
      self.collectionView.dataSource = self 

    
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
          let imagePicker = UIImagePickerController()
          imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
          imagePicker.delegate = self
          imagePicker.editing = true
          self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        self.alertView.addAction(cameraAction)
      }
    
//      let sepiaAction = UIAlertAction(title: "Sepia", style: UIAlertActionStyle.Default) { (action) -> Void in
//        let startImage = CIImage(image: self.imageView.image)
//        let filter = CIFilter(name: "CISepiaTone")
//        filter.setDefaults()
//        filter.setValue(startImage, forKey: kCIInputImageKey)
//        let result = filter.valueForKey(kCIOutputImageKey) as! CIImage
//        let extent = result.extent()
//        let imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
//        self.imageView.image = Filters.instant(self.imageView.image!, context: self.gpuContext)
//      }
     //self.alertView.addAction(sepiaAction)
      
      let postAction = UIAlertAction(title: "Post", style: UIAlertActionStyle.Default) { (action) -> Void in
        println(self.imageView.image!.size)
        //resize image before upload
        let desiredSize = CGSize(width: 600, height: 600)
        UIGraphicsBeginImageContext(desiredSize)
        self.imageView.image!.drawInRect(CGRect(x: 0, y: 0, width: 600, height: 600))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        println(resizedImage.size)
        let imageData = UIImageJPEGRepresentation(resizedImage, 1.0)
        
        let file = PFFile(name: "post.jpeg", data: imageData)
        let imagePost = PFObject(className: "ImagePost")
        imagePost["image"] = file
        imagePost.saveInBackgroundWithBlock { (succeeded, error) -> Void in
          println("save completed!")
        }
      }
      self.alertView.addAction(postAction)
      
      let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
        
        self.collectionViewBottomConstraint.constant = 10
        //remove and add height
        self.view.removeConstraint(self.imageViewHeightConstraint)
        self.imageViewHeightConstraint = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 0.6, constant: 0)
        self.view.addConstraint(self.imageViewHeightConstraint)
        
        //remove and add width
        self.view.removeConstraint(self.imageViewWidthConstraint)
        self.imageViewWidthConstraint = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 0.6, constant: 0.0)
        self.view.addConstraint(self.imageViewWidthConstraint)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
          self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
  
          })
      }
      self.alertView.addAction(filterAction)
      
      let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
        self.performSegueWithIdentifier("ShowGallery", sender: self)
      }
      self.alertView.addAction(galleryAction)

        // Do any additional setup after loading the view.
    }
  
  func createThumbnail(originalImage : UIImage) -> UIImage {
    let desiredSize = CGSize(width: 200, height: 200)
    UIGraphicsBeginImageContext(desiredSize)
    self.imageView.image!.drawInRect(CGRect(x: 0, y: 0, width: 200, height: 200))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
  }

  func donePressed() {
    
    self.collectionViewBottomConstraint.constant = -100
    
    //remove and add new height constraint
    self.view.removeConstraint(self.imageViewHeightConstraint)
    self.imageViewHeightConstraint = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 0.7, constant: 0.0)
    self.view.addConstraint(self.imageViewHeightConstraint)
    
    //remove and add new width constraint
    self.view.removeConstraint(self.imageViewWidthConstraint)
    self.imageViewWidthConstraint = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 0.7, constant: 0.0)
    self.view.addConstraint(self.imageViewWidthConstraint)
    
    //self.imageViewWidthConstraint.multiplier
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
      }, completion: { (finished) -> Void in
        self.navigationItem.rightBarButtonItem = nil
        
    })
    
  }
  
  @IBAction func photoButtonPressed(sender: AnyObject) {
    
    //setup alert controller
    if let presentationController = self.alertView.popoverPresentationController {
      //location in super view
      presentationController.sourceView = photoButton
      //location in button
      presentationController.sourceRect = photoButton.bounds
    }
    
    self.presentViewController(alertView, animated: true, completion: nil)
    
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.currentImage = editedImage
    } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      self.currentImage = originalImage
    }

    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: { () -> Void in
      
    })
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
    let filter = self.filters[indexPath.row]
    cell.imageView.image = filter(self.thumbnail,self.gpuContext)
    return cell
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowGallery" {
      let destination = segue.destinationViewController as! GalleryViewController
      destination.delegate = self
    }
  }
  
  func userDidSelectImage(image: UIImage) {
    self.currentImage = image
  }
  
  

}
