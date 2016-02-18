//
//  HTTP.swift
//  mahanenko.ru
//
//  Created by norlin on 03/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class HTTP: NSObject {
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func get(url: String, parameters: [String:AnyObject] = [String: AnyObject](), completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let urlString = url + HTTP.escapedParameters(parameters)
        let nsurl = NSURL(string: urlString)!
        let req = NSURLRequest(URL: nsurl)
        
        return request(req, completionHandler: completionHandler)
    }
    
    func request(request: NSURLRequest, completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let _self = self
        request.valueForHTTPHeaderField("")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                completionHandler(result: nil, error: HTTP.Error("taskForGETMethod", code: 0, msg: "There was an error with your request!"))
                return
            }
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode
            var err: NSError? = nil
            if statusCode < 200 || statusCode > 299 {
                var msg = ""
                if let _ = response as? NSHTTPURLResponse {
                    msg = "Your request returned an invalid response! code: \(statusCode)!"
                } else if let response = response {
                    msg = "Your request returned an invalid response! Response: \(response)!"
                } else {
                    msg = "Your request returned an invalid response!"
                }
                err = HTTP.Error("taskForGETMethod", code:statusCode!, msg: msg)
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: HTTP.Error("taskForGETMethod", code: 0, msg: "No data was returned by the request!"))
                return
            }
            
            _self.parseJSON(data){result, error in
                guard let error = error else {
                    completionHandler(result: result, error: err)
                    return
                }
                completionHandler(result: result, error: error)
            }
        }
        
        task.resume()
        return task
    }
    
    class func Error(domain: String, code: Int, msg: String) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func parseJSON(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
    
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(result: nil, error: HTTP.Error("parseJSON", code: 1, msg: "Could not parse the data as JSON: '\(data)'"))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    class func sharedInstance() -> HTTP {
        struct Singleton {
            static var sharedInstance = HTTP()
        }
        
        return Singleton.sharedInstance
    }
    
    func parseHTMLString(html: String) -> NSAttributedString? {
        let textData = html.dataUsingEncoding(NSUTF8StringEncoding)
        let opts:[String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
            NSKernAttributeName: NSNull()
        ]
        return try? NSAttributedString.init(data: textData!, options: opts, documentAttributes: nil)
    }
}