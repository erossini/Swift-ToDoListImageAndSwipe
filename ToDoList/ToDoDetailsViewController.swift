//
//  ToDoDetailsViewController.swift
//  ToDoList
//
//  Created by Enrico Rossini on 17/08/2021.
//

import UIKit

class ToDoDetailsViewController: UIViewController {

    var toDoCD : ToDoCD? = nil
    
    @IBOutlet weak var todoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let todo = toDoCD {
            if todo.priority == 1 {
                if let name = todo.name {
                    todoLabel.text = "❗️" + name
                }
            }
            else if todo.priority == 2 {
                if let name = todo.name {
                    todoLabel.text = "‼️" + name
                }
            }
            else {
                if let name = todo.name {
                    todoLabel.text = name
                }
            }
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let todo = toDoCD {
                context.delete(todo)
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
}
