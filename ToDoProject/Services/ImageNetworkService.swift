//
//  ImageNetworkService.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/09/01.
//

import UIKit

enum ImageError: Error {
    case invalidURL
    case invalidServerResponse
    case unsupportedImage
}

struct ImageNetworkService {
    
    func downLoadImage() async throws -> UIImage {
        guard let url = URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg") else { throw ImageError.invalidURL }
        
        let (data, reponse) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = reponse as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw ImageError.invalidServerResponse }
        
        guard let image = UIImage(data: data) else { throw ImageError.unsupportedImage}
        
        return image
    }
}
