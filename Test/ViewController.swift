//
//  ViewController.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworkManager()
    let path = "2.3/questions?order=desc&sort=activity&site=stackoverflow"

    let tags = ["Objective-C", "Xcode", "iOS", "Cocoa Touch", "iPhone"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkManager.obtainQuestions(path: path) { (result) in
            guard let items = result.items else { return }
            
            for i in items {
                print(i.questionID ?? "nil")
            }
        }
            
        }
}
