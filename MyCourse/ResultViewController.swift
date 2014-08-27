//
//  ResultView.swift
//  MyCourse
//
//  Created by Hugh on 14-8-26.
//  Copyright (c) 2014年 Hugh. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIProtocol{
    
    var albums = [Album]()
    
    var imgCache = [String:UIImage]()
    
    let kCellIndentifier = "SearchResultCell"
    
    lazy var api: APIController = APIController(delegate:self)
    
    @IBOutlet weak var appsTableView: UITableView?
    
    //override api protocol function
    func didReceiveAPIResult(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        println("did receive result")
        
        println("\(self.albums.count)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Bob")
        println("view did load")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if self.albums.count > 30 {
            return 30
        } else {
            return self.albums.count
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIndentifier) as UITableViewCell
        let album = self.albums[indexPath.row]
        
        let cellText: String? = album.title
        
        cell.textLabel.text = cellText
        cell.imageView.image = UIImage(named: "Blank52")
        
        let formattedPrice: NSString = album.price as NSString
        
        let urlString:NSString = album.thumbnailImageURL as NSString
        var image = self.imgCache[urlString]
        
        if((image?) == nil) {
            var imgURL: NSURL = NSURL(string: urlString)
            var request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()?, completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error? == nil {
                    image = UIImage(data: data)
                    self.imgCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.imageView.image = image
                    })
                    
                }
                else {
                    println("Error: \(error.localizedDescription)")
                    
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                cell.imageView.image = image
            })
        }
        
        
        
        cell.detailTextLabel.text = formattedPrice
        return cell;
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
}
