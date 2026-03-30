//
//  AddTaskViewController.swift
//  COMP3097 Lab9
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!

    var viewContext: NSManagedObjectContext!

    @IBAction func addTaskTapped(_ sender: UIButton) {
        let taskName = taskTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !taskName.isEmpty else {
            showAlert(title: "Task Required", message: "Please enter a task name before continuing.")
            return
        }

        let task = Task(context: viewContext)
        task.title = taskName
        task.createdAt = Date()

        do {
            try viewContext.save()
            taskTextField.text = ""
            performSegue(withIdentifier: "showTaskListSegue", sender: self)
        } catch {
            showAlert(title: "Save Failed", message: "Could not save the task. Please try again.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskListSegue",
           let taskListViewController = segue.destination as? TaskListViewController {
            taskListViewController.viewContext = viewContext
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
