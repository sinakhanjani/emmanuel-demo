//
//  ImageProvider.swift
//  Master
//
//  Created by Sina khanjani on 1/8/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//


struct ImageProvider: RequestImages {
fileprivate let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)//MARK: - Fetch image from URL and Imagescache

func loadImages(from url: URL, completion: @escaping (_ image:UIImage) -> Void) {
    downloadQueue.async(execute: { () -> Void in
          do {
             let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async { completion(image) }
             } else { print("Could not decode image") }
    } catch {
        print("Could not load URL: \(url): \(error)")
        }
    })
    }
}

protocol RequestImages {}
extension RequestImages where Self == ImageProvider {
    func requestImage(from url: URL, completion: @escaping (_ _image: UIImage) -> Void) {
        //calling here another function and returning data
    }
}
