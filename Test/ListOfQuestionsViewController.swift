//
//  ListOfQuestionsViewController.swift
//  Test
//
//  Created by Семен Беляков on 07.03.2022.
//

import UIKit

class ListOfQuestionsViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listOfQuestionsButton: UIBarButtonItem!

    private let networkManager = NetworkManager()
    
    // Теги
    let tags = ["Objective-C", "Xcode", "iOS", "Cocoa Touch", "iPhone"]
    
    // Массив данных
    var questions = [Question]()
    
    // Номер и количество строк
    var currentPage = 1
    let pageSize = 5

    var currentTag: String = "Objective-C" {
        didSet {
            currentPage = 1
            questions = []
            obtainQuestions()
        }
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
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentTag
        tableView.dataSource = self
        tableView.delegate = self
        registeredCustomTableViewCell()
        initActivityIndicator()
        obtainQuestions()
    }
    
    func obtainQuestions() {
        indicator.startAnimating()
        let path = "2.3/questions?order=desc&sort=activity&tagged=\(currentTag)&site=stackoverflow&page=\(currentPage)&pagesize=\(pageSize)"
        
        networkManager.obtainQuestions(path: addPlus(str: path)) { [self] (result) in
            guard let items = result.items else { return }
            
            let inserFromIndex = questions.count
            questions += items
            currentPage = questions.count / pageSize
            // Обновление таблицы
            DispatchQueue.main.async {
                if questions.count > pageSize {
                    var indexes = [IndexPath]()
                    for i in inserFromIndex...questions.count - 1 {
                        indexes.append(.init(row: i, section: 0))
                    }
                    tableView.insertRows(at: indexes, with: .right)
                    indicator.stopAnimating()
                }
                tableView.reloadData()
                indicator.stopAnimating()
            }
        }
    }

    private func addPlus(str: String) -> String {
        var newWord = ""
        for i in str {
            if i == " " {
                newWord += "_"
            } else {
                newWord += String(i)
            }
        }
        return newWord
    }

    // MARK: - Кнопка смены тега
    @IBAction func changeTag(_ sender: UIBarButtonItem) {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }

    @objc func onDoneButtonTapped() {
        picker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    private func registeredCustomTableViewCell() {
        let textField = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView.register(textField, forCellReuseIdentifier: "CustomTableViewCell")
    }
}


    // MARK: - UITableView
extension ListOfQuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            
            let textLabel = questions[indexPath.row]
            
            cell.nameLabel.text = textLabel.owner?.displayName
            cell.questionLabel.text = textLabel.title
            cell.answersLabel.text = "Количество ответов - \(textLabel.answerCount ?? 0)"
            cell.dataLabel.text = "Дата - \(textLabel.lastEditDate ?? 0)"
            return cell
        }
            
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == questions.count - 1 {
            obtainQuestions()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "QuestionDescriptionViewController") as! QuestionDescriptionViewController
        let path = questions[indexPath.row]
        
        vc.title = path.owner?.displayName
        vc.textQuestion.text = questions[indexPath.row].title
        vc.question = questions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UIPickerView
extension ListOfQuestionsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentTag = tags[row]
            self.title = currentTag
    }
}

