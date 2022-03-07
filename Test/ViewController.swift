//
//  ViewController.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworkManager()

    let tags = ["Objective-C", "Xcode", "iOS", "Cocoa Touch", "iPhone"]
    var dataSource = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkManager.obtainQuestions() { [weak self] (result) in
            print()
            switch result {
            case .success(users: let users):
                
                self?.dataSource = users
                
            case .failure(errors: let errors):
                print(errors)
            }

//            print("Error: \(error?.localizedDescription ?? "")")
//                print(item.name)
            
        }
        
        
    }
    
    
    
}

