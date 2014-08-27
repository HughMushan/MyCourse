//
//  APIController.swift
//  HelloWorld
//
//  Created by Hugh on 14-8-4.
//  Copyright (c) 2014年 Hugh. All rights reserved.
//

import Foundation

protocol APIProtocol {
    func didReceiveAPIResult(results: NSDictionary)
}

class APIController {
    
    var delegate: APIProtocol
    
    init(delegate: APIProtocol) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url:NSURL = NSURL(string:path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler:{data, respones, error -> Void in
            println("Task Completed")
            if((error) != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if((err?) != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            self.delegate.didReceiveAPIResult(jsonResult)
            
            })
        task.resume()

    }
    
    func searchItunesFor(searchTerm: String) {
        //空格替换成+
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
        println(urlPath)
        get(urlPath)
    }
    
    func lookupAlbum(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }

}
