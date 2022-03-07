//
//  ViewController.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworkManager()

    var tags = ["Objective-C", "Xcode", "iOS", "Cocoa Touch", "iPhone"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkManager.obtainQuestions(path: "swift;Xcode") { (response) in
            guard let items = response?.items else { return }
            
            for item in items {
                print(item.questionName!)
            }
        }
    }
    
}

