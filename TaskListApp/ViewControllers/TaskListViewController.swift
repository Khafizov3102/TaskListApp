//
//  ViewController.swift
//  TaskListApp
//
//  Created by brubru on 23.11.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {	
    private let storageManager = StorageManager.shared
    
	private let cellID = "task"
	private var taskList: [Task] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .white
		setupNavigationBar()
        fetchData()
        navigationItem.leftBarButtonItem = editButtonItem
	}
	
	@objc
	private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
	}
}

// MARK: - Private Methods
private extension TaskListViewController {
	func setupNavigationBar() {
		title = "Task List"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		
		navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
		
		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewTask)
		)
		
		navigationController?.navigationBar.tintColor = .white
	}

    func showAlert(with title: String, and message: String, index: Int? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
        let saveAction = UIAlertAction(title: (index == nil) ? "Save Task" : "Updata Task", style: .default) { [unowned self] _ in
			guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            (index == nil) ? save(task) : updata(title: task, index: index ?? 0)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
		
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		alert.addTextField { [unowned self] textField in
            if (index == nil) {
                textField.placeholder = "NewTask"
            } else {
                textField.text = taskList[index ?? 0].title
            }
		}
		present(alert, animated: true)
	}
	
	func save(_ taskName: String) {
        storageManager.save(title: taskName) { [unowned self] task in
            task.title = taskName
            taskList.append(task)
        }
		
		let indexPath = IndexPath(row: taskList.count - 1, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}
    
    func updata(title: String, index: Int) {
        storageManager.updata(title: title, task: taskList[index]) { [unowned self] task in
            task.title = title
            taskList[index] = task
        }
        tableView.reloadData()
    }
    
    func fetchData() {
        storageManager.fetchData { [unowned self] tasks in
            taskList = tasks
        }
    }
}

extension TaskListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		taskList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let task = taskList[indexPath.row]
		
		var content = cell.defaultContentConfiguration()
		content.text = task.title
		cell.contentConfiguration = content
		
		return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            taskList.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
            storageManager.delete(task: taskList[indexPath.row - 1])
        }
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(with: taskList[indexPath.row].title ?? "", and: "Write new value", index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

