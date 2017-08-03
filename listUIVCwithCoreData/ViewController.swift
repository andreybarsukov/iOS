//
//  ViewController.swift
//  listUIVCwithCoreData
//
//  Created by Andrey Barsukov on 7/31/17.
//  Copyright © 2017 Andrey Barsukov. All rights reserved.
//

import UIKit
import CoreData

class tableViewController: UITableViewController {
    
    var listItems = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //creating button top right to add an item into table
        //addItem function called when button clicked
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(tableViewController.addItem))
    }
    
    //func called when top right butotn clicked
    func addItem(){
        //controls button actions
        let alertController = UIAlertController(title: "Add Item", message: "Add New Items to List", preferredStyle: .alert)
        
        //confirm action
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField{
                
                self.saveItem(itemToSave: field.text!)
                self.tableView.reloadData()
            }
            
            
            }
        ))
        
        let cancelActions = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        //add the text field
        alertController.addTextField(configurationHandler: {
            (textField) in
            
            textField.placeholder = "Type something here 1234"
            
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelActions)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveItem(itemToSave : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //"item" = name of item in coreData attributes
        item.setValue(itemToSave, forKey: "item")
        
        do {
            try managedContext.save()
            
            listItems.append(item)
            
        }
        catch{
            print("Error in item save")
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        /////let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let managedContext = appDelegate.persistentContainer.viewContext
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        
        //delete data from CoreData
        managedContext.delete(listItems[indexPath.row])
        listItems.remove(at: indexPath.row)
        //
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
        //
        
        self.tableView.reloadData()

    }
    
    /*
    
    //function to delete an entry
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        /////let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        
        //delete data from CoreData
        managedContext.delete(listItems[indexPath.row])
       
        print("GOT HERE: 222")
        listItems.remove(at: indexPath.row)
        //
        //   (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //
        
        self.tableView.reloadData()
        
        print("GOT HERE: 444")
    }\\
     
     */
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //return the length of table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    
    //grab all items saved in CoreData
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //CHANGED <>
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntity")
        fetchRequest.returnsDistinctResults = false
        
        do{
            
            let results = try managedContext.fetch(fetchRequest)
            listItems = results as! [NSManagedObject]
        }
        catch {
            
            print("Error loading previously added items from CoreData")
        }
        

    }
    
    //creating a new row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        
        //allocating position of newly added items
        let item = listItems[indexPath.row]
        
        cell.textLabel?.text = item.value(forKey: "item") as? String
        
        return cell
    }
}

