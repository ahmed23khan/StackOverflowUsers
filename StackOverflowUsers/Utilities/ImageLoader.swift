//
//  ImageLoader.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import UIKit

final class ImageLoader {

    static let shared = ImageLoader()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100
    }

    // Returns the task so callers can cancel independently
    @discardableResult
    func load(url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        let key = url.absoluteString as NSString

        if let cached = cache.object(forKey: key) {
            completion(cached)
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard error == nil, let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            self?.cache.setObject(image, forKey: key)
            DispatchQueue.main.async { completion(image) }
        }

        task.resume()
        return task
    }
}
