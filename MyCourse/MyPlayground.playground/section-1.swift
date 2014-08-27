// Playground - noun: a place where people can play

import Cocoa

let path = "https://itunes.apple.com/search?term=Bob+Dylan&media=music&entity=album"
let url:NSURL = NSURL(string:path)
let session = NSURLSession.sharedSession()
var result: NSData?
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
//    self.delegate.didReceiveAPIResult(jsonResult)
    result = data
    
})
task.resume()

print(result?)
