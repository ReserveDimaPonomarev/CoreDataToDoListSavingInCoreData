//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Дмитрий Пономарев on 15.02.2023.
//

import UIKit
import SnapKit
import CoreData


class ViewController: UIViewController {
    
    //    MARK: - UIProperties
 
    var toDoItems: [Tasks] = []
    
    let tableView = UITableView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {

        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            toDoItems = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "To-do list"
        setupNavBar()

        addViews()
        
        makeConstraints()
        setupViews()
    }
    
    //    MARK: - addViews
    
    func addViews() {
        view.addSubview(tableView)
    }
    
    //    MARK: - makeConstraints
    
    func makeConstraints() {
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    //    MARK: - setupViews
    
    func setupViews() {
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTarget))
    }
    
    @objc func addTarget() {
        let alertControl = UIAlertController(title: "Add task", message: "add new task", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            let textField = alertControl.textFields?[0]
            textField?.translatesAutoresizingMaskIntoConstraints = true
            self.saveTask(saveToDo: textField?.text ?? "")
            self.tableView.reloadData()

        }

        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alertControl.addTextField()
        alertControl.addAction(ok)
        alertControl.addAction(cancel)
        present(alertControl, animated: true)
    }
    
    func saveTask(saveToDo: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Tasks
        taskObject.taskToDo = saveToDo
        
        do {
            try context.save()
            toDoItems.append(taskObject)
        } catch {
            print(error.localizedDescription)
        }
    }
}

//    MARK: - extension

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell () }
        var content = cell.defaultContentConfiguration()
        let model = toDoItems[indexPath.row]
        content.text = model.taskToDo
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = toDoItems[indexPath.row]
            context.delete(commit)
            toDoItems.remove(at: indexPath.row)
            do {
                try context.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

