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
        
//        if let filepath = Bundle.main.path(forResource: "Example", ofType: "png") {
//            let image = UIImage(contentsOfFile: filepath)
//            print(image)
//
//            guard let data = image?.jpegData(compressionQuality: 1.0) else
//            {
//                print("Could not convert image to data")
//                return
//            }
//            let count = data.count / MemoryLayout<UInt8>.size
//            // create an array of Uint8
//            var byteArray = [UInt8](repeating: 0, count: count)
//            // copy bytes into array
//            data.copyBytes(to: &byteArray, count:count)
//        } else {
//            print("File not found")
//        }
        
        let filepath = Bundle.main.path(forResource: "Example", ofType: "png")
        let boundary = "Boundary-\(NSUUID().uuidString)"
        let parameters = [
            "language"  : "unk",
            "detectOrientation"    : "true"]
        
        var request = URLRequest(url: URL(string: uriBase)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try createBody(with: parameters, filePathKey: "file", paths: [filepath!], boundary: boundary)
        } catch {
            print("error")
        }
        
        print("REQUEST: \(request)")
        
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
    }
    
    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The `multipart/form-data` boundary
    ///
    /// - returns:                The `Data` of the body of the request
    
    private func createBody(with parameters: [String: String]?, filePathKey: String, paths: [String], boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        for path in paths {
            let url = URL(fileURLWithPath: path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: application/octet-stream\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        body.append("--\(boundary)--\r\n")
        return body
    }
    
//    /// Determine mime type on the basis of extension of a file.
//    ///
//    /// This requires `import MobileCoreServices`.
//    ///
//    /// - parameter path:         The path of the file for which we are going to determine the mime type.
//    ///
//    /// - returns:                Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.
//
//    private func mimeType(for path: String) -> String {
//        let url = URL(fileURLWithPath: path)
//        let pathExtension = url.pathExtension
//
//        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
//            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
//                return mimetype as String
//            }
//        }
//        return "application/octet-stream"
//    }
}

extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
