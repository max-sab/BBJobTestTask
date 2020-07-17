//
//  ImageProcessor.swift
//  BBJobTestTask
//
//  Created by Maksym Sabadyshyn on 7/16/20.
//  Copyright © 2020 Maksym Sabadyshyn. All rights reserved.
//

import Foundation
import UIKit

class ImageProcessor {

    static let cache = NSCache<NSString,UIImage>()
    static private let defaultImg: UIImage = #imageLiteral(resourceName: "defaultAvatar")

    static func getImage(withUrl possibleURL: String, completion: @escaping (_ imageToUse: UIImage?)->()) {

        var finalAvatar: UIImage!

        if let imageInCache = cache.object(forKey: possibleURL as NSString) {
            finalAvatar = imageInCache
            completion(finalAvatar)
        } else {
            if let url = URL(string: possibleURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in

                    var image: UIImage?

                    if let data = data {
                        image = UIImage(data: data)
                    }

                    if image != nil {
                        cache.setObject(image!, forKey: possibleURL as NSString)
                        finalAvatar = image!
                    } else {
                        cache.setObject(defaultImg, forKey: possibleURL as NSString)
                        finalAvatar = defaultImg
                    }

                    DispatchQueue.main.async {
                        completion(finalAvatar)
                    }

                }.resume()
            }
        }
    }

    static func deleteFromCache(by key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    static func deleteAll() {
        cache.removeAllObjects()
    }
}
