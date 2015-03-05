//
//  Post.swift
//  ParseCoreImage
//
//  Created by Bradley Johnson on 3/5/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import Foundation

class Post {
  var pfObject : PFObject
  var image : UIImage?
  
  init(pfObject : PFObject) {
    self.pfObject = pfObject
  }
}