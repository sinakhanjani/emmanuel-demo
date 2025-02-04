//
//  WebAPI.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import AVKit
import Alamofire
import SwiftyJSON
import JWTDecode


class WebAPI {
    
    static let instance = WebAPI()
    
    typealias completion = (_ status: Constant.Alert) -> Void
    private let baseURL = URL.init(string: "https://sweetemmanuel.co.uk/api/")!//
    private let head = ["Authorization": "Bearer \(Authentication.auth.token)"
    ]
    //http://sweetemmanuel.com/api/
    func postRequest(completion: @escaping completion) {
        let url = baseURL.appendingPathComponent("customer/cart/count")
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let jsonEncoder = JSONEncoder()
        //let jsonData = try? jsonEncoder.encode(<#T##value: Encodable##Encodable#>)
        //request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error as Any)
                completion(.failed)
                return
            }
            if let data = data {
                guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) as [String : Any]??) else { completion(.failed) ; return }
                //
            } else {
                completion(.failed)
            }
        }
        task.resume()
    }
    
    func postMultipartFormDataRequest(photo: Data?, completion: @escaping completion) {
        let url = baseURL.appendingPathComponent("")
        let parameter = ["":"",
                         "":"",
                         "":""
        ]
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(withParameters: parameter, media: photo, boundary: boundary, photoKey: "photo key if needed")
        request.httpBody = dataBody
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failed)
                return
            }
            guard let data = data else { completion(.failed) ; return }
            guard let json = try? JSON.init(data: data) else { completion(.failed) ; return }
            //
        }
        task.resume()
    }
    
    func getRequest(completion: @escaping (_ data: String?) -> Void) {
        let url = baseURL.appendingPathComponent("customer/cart/count")
        var request = URLRequest.init(url: url)
        request.allHTTPHeaderFields = head
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error as Any)
                completion(nil)
                return
            }
            if let data = data {
                if let str = String(data: data, encoding: .utf8) {
                    completion(str)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    static func openURL(url:URL?) {
        if let url = url {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /////// /////// /////// //////
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
    
    private func getOSInfo() -> String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    private func getPlatformNSString() -> String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        let DEVICE_IS_SIMULATOR = true
        #else
        let DEVICE_IS_SIMULATOR = false
        #endif
        var machineSwiftString : String = ""
        if DEVICE_IS_SIMULATOR == true
        {
            // this neat trick is found at http://kelan.io/2015/easier-getenv-in-swift/
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineSwiftString = dir
                return machineSwiftString
            }
        } else {
            var size : size_t = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: Int(size))
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            machineSwiftString = String.init(cString: machine)
            return machineSwiftString
            
        }
        print("machine is \(machineSwiftString)")
        return machineSwiftString
    }
    
    private func decodeJWT(token: String) {
        guard let jwt = try? decode(jwt: token) else { return }
        if let sample = jwt.claim(name: "").string {
            //
        }
    }
    
    
}
