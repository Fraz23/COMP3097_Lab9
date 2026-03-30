//
//  TaskListViewController.swift
//  COMP3097 Lab9
//

import UIKit
import CoreData

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewContext: NSManagedObjectContext!
    private var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()
    }

    private func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        do {
            tasks = try viewContext.fetch(request)
            tableView.reloadData()
        } catch {
            tasks = []
            tableView.reloadData()
            showSimpleAlert(title: "Load Failed", message: "Could not load tasks from storage.")
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            showSimpleAlert(title: "Save Failed", message: "Could not update task. Please try again.")
        }
    }

    private func showEditDialog(for task: Task, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Task", message: "Update task name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = task.title
            textField.clearButtonMode = .whileEditing
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let updatedTitle = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !updatedTitle.isEmpty else { return }

            task.title = updatedTitle
            self.saveContext()
            self.tasks[indexPath.row] = task
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }))

        present(alert, animated: true)
    }

    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }

            self.viewContext.delete(task)
            self.saveContext()
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            self?.showEditDialog(for: task, at: indexPath)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
