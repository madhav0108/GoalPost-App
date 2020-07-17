//
//  GoalsViewController.swift
//  GoalPost
//
//  Created by madhav sharma on 7/3/20.
//  Copyright © 2020 madhav sharma. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                //if atleast one goal was created
                if goals.count >= 1 {
                    tableView.isHidden = false
                }
                //if no goals were created
                else {
                    tableView.isHidden = true
                }
            }
        }
    }
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let addGoalViewController = storyboard?.instantiateViewController(withIdentifier: "AddGoalViewController")
            else {
                return
        }
        //to switch default annoying card-view to fullscreen-view
        //using a segue programmatically
        addGoalViewController.modalPresentationStyle = .fullScreen
        presentDetail(addGoalViewController)
    }
    
}

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell
            else {
                return UITableViewCell()
        }
        let goal = goals[indexPath.row]
        //getting data from the specific goal
        cell.configureCell(goal: goal)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //return UITableViewCell.EditingStyle.none
        return .none
    }
    //Legendary stuff, credits: stackoverflow
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        let contextProgressItem = UIContextualAction(style: .normal, title: "Scored") { (contextualAction, view, boolValue) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        
        contextItem.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.952349101)
        contextProgressItem.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        //let deleteAction = UISwipeActionsConfiguration(actions: [contextItem])
        let actions = UISwipeActionsConfiguration(actions: [contextItem,contextProgressItem])
        
        return actions
    }
}

extension GoalsViewController {
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let chosenGoal = goals[indexPath.row]
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        do {
            try managedContext.save()
            print("Successfully set progress")
        } catch {
            debugPrint("Couldn't set progress: \(error.localizedDescription)")
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(goals[indexPath.row])
        do{
            try managedContext.save()
            print("Successfully removed")
        } catch{
            debugPrint("Couldn't remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        //trying to fetch items of this particular entity
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched")
            completion(true)
        } catch {
            debugPrint("Couldn't fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}
