//
//  QuestionDescriptionViewController.swift
//  Test
//
//  Created by Семен Беляков on 07.03.2022.
//

import UIKit

class QuestionDescriptionViewController: UIViewController {
    
    let networkManager = NetworkManager()
   
     var textQuestion: UITextView = {
        var text = UITextView()
        let attributedText = NSMutableAttributedString()
        text.font = UIFont.systemFont(ofSize: 20)
        text.backgroundColor = .lightGray
        text.textAlignment = .left
//        text.isScrollEnabled = false
        // выделение текста
        text.isEditable = false
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var tableView: UITableView = {
        var table = UITableView()
            table.translatesAutoresizingMaskIntoConstraints = false
            table.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionTableViewCell")
            table.layer.backgroundColor = UIColor.green.cgColor
            table.tableFooterView = UIView(frame: .zero)
        return table
    }()
    
    var question = ""
    
    var answers = [Answer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        obtainAnswers()
        setupUI()
    }
    
     func obtainAnswers() {
 
        // Вторая часть пути
        var path: String {
            return "2.3/questions/\(question)/answers?order=desc&sort=activity&site=stackoverflow"
        }

        networkManager.obtainAnswers(path: path) { (result) in
            guard let items = result.items else { return print("nil") }
            self.answers = items
            
            // Обновление таблицы
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(textQuestion)
        view.addSubview(tableView)
        
        textQuestion.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        textQuestion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        textQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        textQuestion.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        tableView.topAnchor.constraint(equalTo: textQuestion.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35).isActive = true
    }
}

extension QuestionDescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell") as! DescriptionTableViewCell
        
        cell.textLabel?.text = "\(answers[indexPath.row].answerID ?? 0)"

        return cell
    }
    
    
}
