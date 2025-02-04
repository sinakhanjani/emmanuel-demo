//
//  Network.swift
//  Nerkh
//
//  Created by Sina khanjani on 1/9/1399 AP.
//  Copyright © 1399 Sina Khanjani. All rights reserved.
//

import UIKit

let baseAbsoluteURLString: String = "https://sweetemmanuel.co.uk/"

class Network<V: Codable,T: Codable>: Disposable {
    enum BodyType {
        case formdata,jsonBody
    }
    
    enum Method:String {
        case post = "POST"
        case get = "GET"
    }
    
    typealias NetworkResult = (NetworkResponse<V>) -> Void
    typealias Parameters = [String:String]
    typealias HTTPHeaders = [String:String]
    
    private(set) var baseURL : URL? = URL(string: baseAbsoluteURLString)
    private var header : HTTPHeaders = [:]
    private var urlSeasion = URLSession.shared
    private var photo: (key: String, value: Data)?
    public var url: URL?
    public var method : Method = .get
    public var ignoreAuth = false
    public var params : [String: String]?
    public var model : T?
    public var bodyType: BodyType = .jsonBody
    
    init(path: String, ignoreAuth: Bool) {
        self.url = baseURL?.appendingPathComponent(path)
        self.ignoreAuth = ignoreAuth
    }
    
    override func dispose() {
        // cancel request here URLSeassion *
        urlSeasion.invalidateAndCancel()
    }

    func withPost() -> Network {
        method = Method.post
        return self
    }
    func withGet() -> Network {
        method = Method.get
        return self
    }
    
    public func setBodyType(type: BodyType) -> Network {
        self.bodyType = type
        return self
    }
    
    public func addParameter(key: String, value: String?) -> Network {
        if (params == nil) {
            params = Parameters()
        } else {
            params![key] = value
        }
        return self
    }
    
    public func addParameters(params : [String:String]) -> Network {
        self.params = params
        return self
    }
    
    public func appendParameters(params : Parameters?) -> Network {
        guard let params = params else {
            return self
        }
        for i in params {
            self.params?[i.key] = i.value
        }
        return self
    }
    
    public func addAllParameters(_ params : Parameters) -> Network  {
        self.params = params
        return self
    }
    
    public func addModel(_ model: T) -> Network {
        self.model = model
        return self
    }
    
    public func addPhoto(photoKey: String, data: Data) -> Network {
        self.photo = (key: photoKey, value: data)
        return self
    }
    
    public func attack(completion:  @escaping NetworkResult) -> Disposable {
        return request(method: method, completion: completion)
    }
}

extension Network {
    func post(completion: @escaping NetworkResult) -> Disposable {
        return request(method: .post, completion: completion)
    }
    func get(completion: @escaping NetworkResult) -> Disposable {
        return request(method: .get, completion: completion)
    }
}


extension Network {
    /// send request.
    private func request(method: Method, completion: @escaping NetworkResult) -> Disposable {
        guard let baseURL = baseURL else { completion(.error(NetworkErrors.BadURL)) ; return self }
        self.method = method
        header["Accept"] = "application/json"
        header.updateValue("application/json", forKey: "Content-Type")
        let token = Authentication.auth.token
        if !token.isEmpty && !ignoreAuth {
            header["Authorization"] = "Bearer " + String(token)
        }
        // ==== Send Request ====
        switch bodyType {
        case .jsonBody:
            return jsonBodyRequest { (response) in
                completion(response)
            }
        case .formdata:
            guard method == .post else { completion(.error(NetworkErrors.BadRequest)) ; return self }
            return formdataRequest { (response) in
                completion(response)
            }
        }
    }
    
    private func jsonBodyRequest(completion: @escaping NetworkResult) -> Disposable {
        guard var url = url else { completion(.error(NetworkErrors.BadURL)) ; return self }
        if let params = params {
            url = url.withQuries(params)!
            self.params = nil
        }
        print("URL: \(url.absoluteURL)")
        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        if method == .post {
            if let model = model {
                let jsonEncoder = JSONEncoder()
                if let jsonData = try? jsonEncoder.encode(model) {
                    request.httpBody = jsonData
                }
            }
        }
        let task = urlSeasion.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error as Any)
                completion(.error(NetworkErrors.NotFound))
                return
            }
            guard let data = data else { completion(.error(NetworkErrors.BadURL)) ; return }
            print(String.init(data: data, encoding: .utf8))
            let jsonDecoder = JSONDecoder()
            guard let decodeJson = try? jsonDecoder.decode(V.self, from: data) else { completion(.error(NetworkErrors.json)) ; return }
            completion(.success(decodeJson))
        }
        task.resume()
        return self
    }
    
    private func formdataRequest(completion: @escaping NetworkResult) -> Disposable {
        guard let url = url else { completion(.error(NetworkErrors.BadURL)) ; return self }
        guard let params = self.params else { completion(.error(NetworkErrors.BadParameters)) ; return self }
        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        let boundary = generateBoundary()
        request.allHTTPHeaderFields = header
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(withParameters: params, media: photo?.value, boundary: boundary, photoKey: photo?.key)
        request.httpBody = dataBody
        let task = urlSeasion.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error as Any)
                completion(.error(NetworkErrors.NotFound))
                return
            }
            guard let data = data else { completion(.error(NetworkErrors.BadURL)) ; return }
            let jsonDecoder = JSONDecoder()
            guard let decodeJson = try? jsonDecoder.decode(V.self, from: data) else { completion(.error(NetworkErrors.json)) ; return }
            completion(.success(decodeJson))
        }
        task.resume()
        return self
    }
    
    private func generateBoundary() -> String {
         return "Boundary-\(NSUUID().uuidString)"
     }
     
     private func createDataBody(withParameters parameters: [String: String]?, media: Data?, boundary: String, photoKey: String?) -> Data {
         let lineBreak = "\r\n"
         var body = Data()
         if let parameters = parameters {
             for (key,value) in parameters {
                 body.append("--\(boundary + lineBreak)")
                 body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                 body.append("\(value + lineBreak)")
             }
         }
         if let media = media, let photoKey = photoKey {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(photoKey)\"; filename=\"\("\(arc4random())" + ".jpeg")\"\(lineBreak)")
             body.append("Content-Type: \(".jpeg" + lineBreak + lineBreak)")
             body.append(media)
             body.append(lineBreak)
         }
         body.append("--\(boundary)--\(lineBreak)")
         
         return body
     }
}
