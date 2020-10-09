//
//  APIRequestLoader.swift
//  MyFramework
//
//  Created by Ali Shahid on 09/10/2020.
//

import Foundation

public protocol APIRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType
    func makeRequest(from data:RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

public class APIRequestLoader<T: APIRequest>
{
    let apiRequest : T
    let urlSession : URLSession
    
    public init(apiRequest: T , urlSession: URLSession = .shared)
    {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    public func testingFunction() -> String
    {
        return "This is a test method"
    }
    
    public func loadAPIRequest(requestData: T.ResponseDataType, completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void)
    {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData as! T.RequestDataType)
            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                
                guard let data = data else { return completionHandler(nil,error)}
                
                do {
                    let parseReponse = try self.apiRequest.parseResponse(data: data)
                    completionHandler(parseReponse,error)
                }
                catch{
                    completionHandler(nil,error)
                }
                    
            }.resume()
        }
        catch
        {
            completionHandler(nil,error)
        }
    }
}
