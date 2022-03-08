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

//    let screenWith = UIScreen.main.bounds.width - 10
//    let screenHeight = UIScreen.main.bounds.height / 2

    private let networkManager = NetworkManager()
    
    // Теги
    let tags = ["Objective-C", "Xcode", "iOS", "Cocoa Touch", "iPhone"]
    
    // Массив данных
    var questions = [Question]()
    
    // Номер и количество строк
    var currentPage = 1
    let pageSize = 20

    
    let pickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.backgroundColor = .white
//        picker.layer.cornerRadius = 35
        picker.frame = CGRect(x: 0, y: 0, width: 250, height: 200)
//        picker.layer.borderWidth = 0.5
        return picker
    }()
    var chosedTag: String = "iOS"
    
    // Вторая часть пути
    var path: String {
        return "2.3/questions?order=desc&sort=activity&tagged=\(chosedTag)&site=stackoverflow&page=\(currentPage)&pagesize=\(pageSize)"
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = chosedTag
        
        networkManager.obtainQuestions(path: path) { (result) in
            guard let items = result.items else { return }
            self.questions = items
            
            self.currentPage += self.pageSize
            
            // Обновление таблицы
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: - Кнопка смены тега
    @IBAction func changeTag(_ sender: UIBarButtonItem) {
        pickerView.isHidden = !pickerView.isHidden

        self.view.addSubview(pickerView)
        
        pickerView.center = self.view.center
        pickerView.dataSource = self
        pickerView.delegate = self

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        toolBar.sizeToFit()

        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(click))

        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        pickerView.addSubview(toolBar)
    }

    @objc func click() {
//        self.view.endEditing(true)
        print("1")
    }
}


    // MARK: - UITableView
extension ListOfQuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    
        cell.textLabel?.text = questions[indexPath.row].owner?.displayName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
        for (i, text) in tags.enumerated() {
            if i == row {
                self.title = text
                chosedTag = text
            }
        }
    }
}
