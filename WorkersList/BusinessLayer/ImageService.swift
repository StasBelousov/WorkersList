//
//  ImageService.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 31.10.2021.
//

import UIKit

final class ImageService {
    
    static let shared = ImageService()
    var imageCache = NSCache<AnyObject, AnyObject>()

    func getImage (at urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(cacheImage)
        } else {
            download(at: urlString, completion: completion)
        }
    }

    func download(at urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                        completion(nil)
                        return
                }
                self.imageCache.setObject(image, forKey: urlString as NSString)
                completion(image)
            }
        }.resume()
    }
}

