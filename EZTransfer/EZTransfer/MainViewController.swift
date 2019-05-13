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
        if let filepath = Bundle.main.path(forResource: "Example", ofType: "png") {
            let contents = UIImage(contentsOfFile: filepath)
            print(contents!)
        } else {
            print("File not found")
        }
    }
}

