//
//  TimelineViewController.swift
//  ParseCoreImage
//
//  Created by Bradley Johnson on 3/5/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource {
  var queryResults = [Post]()
  @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableView.dataSource = self
      let query = PFQuery(className: "ImagePost")
      query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
        for item in results {
          if let pfObject = item as? PFObject {
            let post = Post(pfObject: pfObject)
            self.queryResults.append(post)
          }
        }
        self.tableView.reloadData()
      }

    }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.queryResults.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCell
    let post = self.queryResults[indexPath.row]
    if post.image != nil {
      cell.timeLineImageView.image = post.image
    } else {
      
      let imageFile = post.pfObject["image"] as! PFFile
      imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
        let image = UIImage(data: data)
        post.image = image!
        cell.timeLineImageView.image = post.image
      })
      
    }
    
    return cell
  }
  
  


}
