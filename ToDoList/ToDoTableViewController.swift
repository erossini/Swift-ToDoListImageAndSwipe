//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Enrico Rossini on 17/08/2021.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    var todoCDs: [ToDoCD] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        getToDos()
    }
    
    // MARK: Read the Core Data
    
    func getToDos() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let toDosFromCoreData = try? context.fetch(ToDoCD.fetchRequest()) {
                if let toDos = toDosFromCoreData as? [ToDoCD] {
                    todoCDs = toDos
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoCDs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let selectedToDo = todoCDs[indexPath.row]
        
        if selectedToDo.priority == 1 {
            if let name = selectedToDo.name {
                cell.textLabel?.text = "❗️" + name
            }
        }
        else if selectedToDo.priority == 2 {
            if let name = selectedToDo.name {
                cell.textLabel?.text = "‼️" + name
            }
        }
        else {
            cell.textLabel?.text = selectedToDo.name
        }
        if let data = selectedToDo.image {
            cell.imageView?.image = UIImage(data: data)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let selectedToDo = todoCDs[indexPath.row]
                context.delete(selectedToDo)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                getToDos()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedToDo = todoCDs[indexPath.row]
        performSegue(withIdentifier: "moveToDetails", sender: selectedToDo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addToDoViewController = segue.destination as? AddToDoViewController {
            addToDoViewController.todoTableViewController = self
        }
        
        if let detailsViewController = segue.destination as? ToDoDetailsViewController {
            if let selectedToDo = sender as? ToDoCD {
                detailsViewController.toDoCD = selectedToDo
            }
        }
    }
}
