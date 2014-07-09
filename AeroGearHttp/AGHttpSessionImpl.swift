/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

class AGHttpSessionImpl : AGHttpSession {
    var baseURL: NSURL
    var session: NSURLSession
    var requestSerializer: AGHttpRequestSerializer!
    
    init(url: String) {
        // TODO check valid url
        assert(url != nil, "baseURL is required")
        self.baseURL = NSURL.URLWithString(url)
        session = NSURLSession.sharedSession()
        requestSerializer = AGJsonRequestSerializerImpl(url: self.baseURL, headers: [String: String]())
    }
    
    init(url: String, sessionConfig: NSURLSessionConfiguration) {
        assert(url != nil, "baseURL is required")
        self.baseURL = NSURL.URLWithString(url)
        session = NSURLSession(configuration: sessionConfig)
        requestSerializer = AGJsonRequestSerializerImpl(url: baseURL, headers: [String: String]())
    }

    func call(url: NSURL, method: AGHttpMethod, parameters: Dictionary<String, AnyObject>?, success:((AnyObject?) -> Void)!, failure:((NSError) -> Void)!) -> () {
        
        let serializedRequest = requestSerializer.request(method, parameters: parameters)
        
        let task = session.dataTaskWithRequest(serializedRequest,
            completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if error {
                    failure(error)
                    return
                }
                if data {
                    var responseObject: AnyObject = data
                    // TODO response serializer
                    success(responseObject)
                } else {
                    failure(error)
                }
            })
        task.resume()
    }
    
    /**
    * Method that produces an HTTP GET
    */
    func GET(parameters: [String: AnyObject]?, success:((AnyObject?) -> Void)!, failure:((NSError) -> Void)!) -> Void {
        self.call(self.baseURL, method: .GET, parameters: parameters, success, failure)
    }
}