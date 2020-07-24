//
//  BaseService.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

/// supported HttpMethods
enum SupportedMethod: String
{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum HttpResponseCode
{
    case ok(Int)
    case redirect(Int)
    case badRequest(Int)
    case serverError(Int)
    case unknown(Int)
    
    static func fromHttpCode(code: Int) -> HttpResponseCode {
        switch code {
        case 200...299: return .ok(code)
        case 300...399: return .redirect(code)
        case 400...499: return .badRequest(code)
        case 500...599: return .serverError(code)
        default: return .unknown(code)
        }
    }
    
    var errorMessage: String {
        switch self {
        case .ok(_ ):
            return "Success"
        case .redirect(_ ):
            return "Redirect Error"
        case .badRequest(_ ):
            return "Bad Request"
        case .serverError(_ ):
            return "Server Error"
        case .unknown(_ ):
            return "Unknown Error"
        }
    }
}

// response container.
struct ResponseModel
{
    let responseData: Data?
    let headers: [String: Any]?
    let statusCode: Int
    let responseCode: HttpResponseCode
    let errorMessage: String?
}

class BaseService
{
    /// shared instance for all direct requests.
    static let sharedInstance: BaseService = BaseService()
    
    /// The time the system is going to wait before timing out the request.
    private static let requestTimeout: TimeInterval = 10.0
    
    init() {
    }
    
    func makeRequest(uri: String, method: SupportedMethod, jsonPayload: Encodable? = nil, headerParams: [String: String]? = nil, completion: @escaping (ResponseModel) -> ())
    {
        guard let request = self.buildRequest(uriString: uri, method: method, headerParams: headerParams, jsonPayload: jsonPayload?.asDictionary())
            else
        {
            let response = ResponseModel(responseData: nil, headers: nil, statusCode: 400, responseCode: HttpResponseCode.fromHttpCode(code: 400), errorMessage: "Request Error!")
            completion(response)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // Validating the response from the server.
            guard error == nil
                else
            {
                let response = ResponseModel(responseData: data, headers: nil, statusCode: error!._code, responseCode: HttpResponseCode.fromHttpCode(code: error!._code), errorMessage: error!.localizedDescription)
                completion(response)
                return
            }
            guard let safeData = data
                else
            {
                let response = ResponseModel(responseData: nil, headers: nil, statusCode: 500, responseCode: HttpResponseCode.fromHttpCode(code: 500), errorMessage: "Response error!")
                completion(response)
                return
            }
            guard let response = response as? HTTPURLResponse
                else
            {
                let responseOutput = ResponseModel(responseData: safeData, headers: nil, statusCode: 501, responseCode: HttpResponseCode.fromHttpCode(code: 501), errorMessage: "Response is missing!")
                completion(responseOutput)
                return
            }
            self.sendResponse(response, data: safeData, completion: completion)
        }
        task.resume()
    }
    
    func toCodable<T>(_ type: T.Type?, from: Data) -> T? where T: Decodable {
        guard let type = type
            else {
                return nil
        }
        do {
            let result = try JSONDecoder().decode(type, from: from)
            return result
        } catch {
            return nil
        }
    }
    
    private func buildRequest(uriString: String, method: SupportedMethod, headerParams: [String: String]? = nil, jsonPayload: [String: Any]?) -> URLRequest?
    {
        let targetURL = uriString
        guard let url =  URL(string: targetURL)
            else
        {
            return nil
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: BaseService.requestTimeout)
        request.httpMethod = method.rawValue
        if let jsonPayload = jsonPayload
        {
            if let bodyData = try? JSONSerialization.data(withJSONObject: jsonPayload as Any, options: [])
            {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = bodyData
            }
        }
        if let headerParams = headerParams
        {
            headerParams.forEach { (entry) in
                request.setValue(entry.value, forHTTPHeaderField: entry.key)
            }
        }
        return request
    }
    
    private func sendResponse(_ response: HTTPURLResponse, data: Data, completion: @escaping (ResponseModel) -> ())
    {
        let responseHeaders = response.allHeaderFields as? [String: Any]
        let response = ResponseModel(responseData: data, headers: responseHeaders, statusCode: response.statusCode, responseCode: HttpResponseCode.fromHttpCode(code: response.statusCode), errorMessage: nil)
        completion(response)
        return
    }
    
}
