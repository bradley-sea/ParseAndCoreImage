//
//  Filters.swift
//  ParseCoreImage
//
//  Created by Bradley Johnson on 3/4/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import Foundation


class Filters {
  class func sepia(originalImage : UIImage, context : CIContext) -> UIImage {
    let startImage = CIImage(image: originalImage)
    let filter = CIFilter(name: "CISepiaTone")
    filter.setDefaults()
    filter.setValue(startImage, forKey: kCIInputImageKey)
    let result = filter.valueForKey(kCIOutputImageKey) as! CIImage
    let extent = result.extent()
    let imageRef = context.createCGImage(result, fromRect: extent)
    return UIImage(CGImage: imageRef)!
  }
  
  class func blur(originalImage : UIImage, context : CIContext) -> UIImage {
    let startImage = CIImage(image: originalImage)
    let filter = CIFilter(name: "CIGaussianBlur")
    filter.setDefaults()
    filter.setValue(startImage, forKey: kCIInputImageKey)
    filter.setValue(5.0, forKey: kCIInputRadiusKey)
    let result = filter.valueForKey(kCIOutputImageKey) as! CIImage
    let extent = result.extent()
    let imageRef = context.createCGImage(result, fromRect: extent)
    return UIImage(CGImage: imageRef)!
  }
  
  class func noir(originalImage: UIImage, context : CIContext) -> UIImage {
    let startImage = CIImage(image: originalImage)
    let filter = CIFilter(name: "CIPhotoEffectNoir")
    filter.setDefaults()
    filter.setValue(startImage, forKey: kCIInputImageKey)
    let result = filter.valueForKey(kCIOutputImageKey) as! CIImage
    let extent = result.extent()
    let imageRef = context.createCGImage(result, fromRect: extent)
    return UIImage(CGImage: imageRef)!
  }
  
  class func chrome(originalImage: UIImage, context : CIContext) -> UIImage {
    let startImage = CIImage(image: originalImage)
    let filter = CIFilter(name: "CIPhotoEffectChrome")
    filter.setDefaults()
    filter.setValue(startImage, forKey: kCIInputImageKey)
    let result = filter.valueForKey(kCIOutputImageKey) as! CIImage
    let extent = result.extent()
    let imageRef = context.createCGImage(result, fromRect: extent)
    return UIImage(CGImage: imageRef)!
  }
  
  class func instant(originalImage: UIImage, context : CIContext) -> UIImage {
    let startImage = CIImage(image: originalImage)
    let filter = CIFilter(name: "CIPhotoEffectInstant")
    filter.setDefaults()
    filter.setValue(startImage, forKey: kCIInputImageKey)
    let result = filter.valueForKey(kCIOutputImageKey) as! CIImage
    let extent = result.extent()
    let imageRef = context.createCGImage(result, fromRect: extent)
    return UIImage(CGImage: imageRef)!
  }
  
}