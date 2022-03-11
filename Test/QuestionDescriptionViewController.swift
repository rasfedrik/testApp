//
//  QuestionDescriptionViewController.swift
//  Test
//
//  Created by Семен Беляков on 07.03.2022.
//

import UIKit

class QuestionDescriptionViewController: UIViewController {
    
    let networkManager = NetworkManager()
    var question: Question!
    
    @IBOutlet weak var tableView: UITableView!

    var answers = [Answer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        initActivityIndicator()
        registeredCustomTableViewCell()
        obtainAnswers()
    }
    
    private var indicator = UIActivityIndicatorView()
    
    func initActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = .large
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.backgroundColor = .clear
        view.addSubview(indicator)
    }
    
    private func registeredCustomTableViewCell() {
        let textFieldQuestion = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        self.tableView.register(textFieldQuestion, forCellReuseIdentifier: "QuestionTableViewCell")

        let textFieldAnswer = UINib(nibName: "AnswerTableViewCell", bundle: nil)
        self.tableView.register(textFieldAnswer, forCellReuseIdentifier: "AnswerTableViewCell")
    }
    
     func obtainAnswers() {
        indicator.startAnimating()
        guard let questionId = question.questionID else { return }
        // Вторая часть пути
        var path: String {
            return "2.3/questions/\(questionId)/answers?order=desc&sort=activity&filter=!nKzQURFm*e&site=stackoverflow"
        }

        networkManager.obtainAnswers(path: path) { (result) in
            guard let items = result.items else { return print("nil") }
            self.answers = items
            
            // Обновление таблицы
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }
}

extension QuestionDescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return answers.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {

        case 0:
            if let cellQuestion = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as? QuestionTableViewCell {
                
                cellQuestion.nameLabel.text = "user: \(question.owner?.displayName ?? "none")"
                cellQuestion.questionLabel.text = "question: \(question.title ?? "none")"
                cellQuestion.dateLabel.text = String("date: \(NSDate(timeIntervalSinceNow: Double(question.lastEditDate ?? 0)))".dropLast(14))
                cellQuestion.countLabel.text = "number of responses: \(question.answersCount ?? 0)"

                return cellQuestion
            }

        default:
            if let cellAnswer = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell") as? AnswerTableViewCell {
                
                cellAnswer.nameLabel.text = "user: \(answers[indexPath.row].owner?.displayName ?? "none")"
                cellAnswer.answerLabel.attributedText = answers[indexPath.row].body?.htmlToUtf
                cellAnswer.countLabel.text = "number of votes: \(answers[indexPath.row].score ?? 0)"
                cellAnswer.dateLabel.text = String("date: \(NSDate(timeIntervalSinceNow: Double(answers[indexPath.row].lastEditDate ?? 0)))".dropLast(14))
                
                if answers[indexPath.row].isAccepted ?? false {
                    cellAnswer.checkImage.image = UIImage(systemName: "checkmark.circle")
                }
                return cellAnswer
            }
        }
        return UITableViewCell()
    }
}

extension String {
    var htmlToUtf: NSAttributedString {
        let attributed = try? NSAttributedString(
            data: self.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        return attributed!
    }
}

