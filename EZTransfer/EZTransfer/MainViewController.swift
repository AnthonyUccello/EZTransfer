//
//  MasterViewController.swift
//  EZTransfer
//
//  Created by Anthony Uccello on 2019-05-13.
//  Copyright © 2019 Avanade. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        
        let key = "296b5aa0befe4f4a9e8c5787ca893cd6"
        let uriBase = "https://westcentralus.api.cognitive.microsoft.com/vision/v1.0"
        
        if let filepath = Bundle.main.path(forResource: "Example", ofType: "png") {
            let image = UIImage(contentsOfFile: filepath)
            print(image)
            
            guard let data = image?.jpegData(compressionQuality: 1.0) else
            {
                print("Could not convert image to data")
                return
            }
            let count = data.count / MemoryLayout<UInt8>.size
            // create an array of Uint8
            var byteArray = [UInt8](repeating: 0, count: count)
            // copy bytes into array
            data.copyBytes(to: &byteArray, count:count)
            
            //let params = ["username":"john", "password":"123456"] as Dictionary<String, String>
            let params = "language=unk&detectOrientation=true"
            
            var request = URLRequest(url: URL(string: uriBase + "?" + params)!)
            request.httpMethod = "POST"
            //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
           // request.httpBody = try? JSONSerialization.data(withJSONObject: <#T##Any#>, options: <#T##JSONSerialization.WritingOptions#>)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                print(response!)
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                } catch {
                    print("error")
                }
            })
            task.resume()
        } else {
            print("File not found")
        }
    }
}

