//
//  TaskTableViewController.swift
//  764928_LABA2
//
//  Created by Evneet kaur on 2020-01-20.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController, UISearchBarDelegate {
    
     var task: [NSManagedObject]?
    var contextOfEntity: NSManagedObjectContext?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        contextOfEntity = context
    
       loadData()

  
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return task?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfTask")
        cell?.textLabel?.text = task![indexPath.row].value(forKey: "title") as? String
        cell?.detailTextLabel?.text = "\(task![indexPath.row].value(forKey: "addedDays")!)"
        
        cell?.backgroundColor = .white
        let addedDays = task![indexPath.row].value(forKey: "addedDays") as! Int
        let neededdays = task![indexPath.row].value(forKey: "neededDays") as! Int
        if neededdays == addedDays {
            cell?.backgroundColor = .brown
            cell?.detailTextLabel?.text = "Task completed"
       
        }
        // Configure the cell...

    
        return cell!
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = self.task![indexPath.row].value(forKey: "title") as! String
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.predicate = NSPredicate(format: "title contains %@", title)
        request.returnsObjectsAsFaults = false
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            
           
            
            do{
                let data = try self.contextOfEntity?.fetch(request)
                for ob in data as! [NSManagedObject]{
                    self.contextOfEntity?.delete(ob)
                    self.task?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)

                }
            }catch{
                print(error)
            }
            
            do {
                try self.contextOfEntity?.save()
                self.loadData()
            }catch{
                print(error)
            }
          

        }
         let addDays = UIContextualAction(style: .destructive, title: "Add Days ") { (action, view, success) in
                   
                  do{
                       let data = try self.contextOfEntity?.fetch(request)
                       for ob in data as! [NSManagedObject]{
                        var addedDays = ob.value(forKey: "addedDays") as! Int
                        addedDays += 1
                        ob.setValue(addedDays, forKey: "addedDays")
    
                       }
                   }catch{
                       print(error)
                   }
                   
                   do {
                       try self.contextOfEntity?.save()
                       self.loadData()
                   }catch{
                       print(error)
                   }
                 
       //            print(self.task)
               }
        addDays.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [deleteAction , addDays])
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.predicate = NSPredicate(format: "title contains[c] %@", searchText)
      
        
        do{
            let result = try contextOfEntity?.fetch(request)
            task = result as! [NSManagedObject]
            
        }catch{
            print(error)
        }
        tableView.reloadData()
        if searchText == ""{
            loadData()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ViewController{
            if let cell = sender as? UITableViewCell{
                let titleTask = task![tableView.indexPath(for: cell)!.row].value(forKey: "title") as! String
                destination.titleVC = titleTask
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    
    func loadData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
       
        
        do{
            let result = try contextOfEntity?.fetch(request)
            task = result as! [NSManagedObject]
           
        }catch{
            print(error)
        }
        tableView.reloadData()
        
    }
    func clearCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        do{
            let result = try contextOfEntity?.fetch(request)
            if result is [NSManagedObject] {
                for item in result as! [NSManagedObject] {
                    contextOfEntity?.delete(item)
                }
            }
            
        }catch{
            print(error)
        }
         do {
                              try self.contextOfEntity?.save()
                              self.loadData()
                          }catch{
                              print(error)
                          }
    }
    
    @IBAction func sortBy_date(_ sender: UIBarButtonItem) {
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                
                
                do{
                    let result = try contextOfEntity?.fetch(request)
                    task = result as! [NSManagedObject]
                  
                }catch{
                    print(error)
                }
                tableView.reloadData()
        
    }
    
    @IBAction func sortBy_title(_ sender: UIBarButtonItem) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
               request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                     
                       
                       do{
                           let result = try contextOfEntity?.fetch(request)
                           task = result as! [NSManagedObject]
                           
                       }catch{
                           print(error)
                       }
                       tableView.reloadData()
    }
}
