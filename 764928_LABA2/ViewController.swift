//
//  ViewController.swift
//  764928_LABA2
//
//  Created by Evneet kaur on 2020-01-20.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var daysField: UITextField!
    @IBOutlet weak var descFeild: UITextView!
    
    var chooseTask: NSManagedObject?
    var titleVC = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.predicate = NSPredicate(format: "title contains %@", titleVC)
        request.returnsObjectsAsFaults = false
        do{
            let data = try context.fetch(request)
            for ob in data as! [NSManagedObject] {
                chooseTask = ob
                titleField.text = ob.value(forKey: "title") as? String
                daysField.text = "\(ob.value(forKey: "neededDays") as? Int ?? 0)"
                descFeild.text = ob.value(forKey: "descriptionOfTask") as? String
            }
            
        }catch{
            print(error)
        }
        
    }


    @IBAction func save(_ sender: UIButton) {
        let title = titleField.text
        let NeededDays = Int(daysField.text ?? "0" ) ?? 0
        let description = descFeild.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if chooseTask == nil {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
        entity.setValue(title, forKey: "title")
        entity.setValue(NeededDays, forKey: "neededDays")
        entity.setValue(0, forKey: "addedDays")
        entity.setValue(description, forKey: "descriptionOfTask")
        entity.setValue(NSDate(), forKey: "date")
        do{
            try context.save()
            print("data d=save")
        }
        catch {
            print(error)
            print("something wrong")
        }
        }
        if chooseTask != nil {
            chooseTask?.setValue(title, forKey: "title")
            chooseTask?.setValue(NeededDays, forKey: "neededDays")
            chooseTask?.setValue(description, forKey: "descriptionOfTask")
            do{
                try context.save()
                print("reEnter data save")
            }catch{
                print(error)
            }
        }
        titleField.text = ""
        daysField.text = ""
        descFeild.text = ""
    }
}

