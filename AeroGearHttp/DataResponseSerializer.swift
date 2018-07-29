//
//  DataResponseSerializer.swift
//  AeroGearHttp
//
//  Created by Noah Nelson on 6/24/18.
//

import Foundation
open class DataResponseSerializer : ResponseSerializer {
    
    /**
     Validate the response received. throw an error is the response is not va;id.
     
     :returns:  either true or false if the response is valid for this particular serializer.
     */
    open var validation: (URLResponse?, Data) throws -> Void = { (response: URLResponse?, data: Data) -> Void in
        var error: NSError! = NSError(domain: HttpErrorDomain, code: 0, userInfo: nil)
        let httpResponse = response as! HTTPURLResponse
        
        if !(httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
            var userInfo = [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode),
                            NetworkingOperationFailingURLResponseErrorKey: response ??  "HttpErrorDomain"] as [String : Any]
            error = NSError(domain: HttpResponseSerializationErrorDomain, code: httpResponse.statusCode, userInfo: userInfo)
            throw error
        }
    }
    
    /**
     Deserialize the response received.
     
     :returns: the serialized response
     */
    open var response: (Data, Int) -> Any? = { (data: Data, Int) -> Any? in
        return data
    }
    
    public init() {
    }
}
