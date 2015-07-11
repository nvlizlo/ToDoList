//
//  ViewController.swift
//  toDoList
//
//  Created by user on 3/24/15.
//  Copyright (c) 2015 user. All rights reserved.
//

import UIKit
import CoreData
import Foundation

let cellIdentifier = "Cell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var list = [NSManagedObject]()
    var filteredList = [NSManagedObject]()
    var isFiltered = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Thing")
        var error:NSError?
        let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        //        for m  in fetchedResults! {
        //           println(m.valueForKey("title"))
        //        }
        
        if let results = fetchedResults {
            list = results
        } else {
            println("Something wrong \(error?.description)")
        }
    }
    //MARK: -tableView datasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered == true {
            return filteredList.count
        }
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var thing:NSManagedObject
        if isFiltered {
            thing = filteredList[indexPath.row]
        } else {
            thing = list[indexPath.row]
        }
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        cell.textLabel?.text = thing.valueForKey("title") as? String
        
        var img:UIImage?
        if thing.valueForKey("isDone") as? Bool == false {
            img = UIImage(named: "x.png")
        } else {
            img = UIImage(named: "chekmark.png")
        }
        cell.imageView?.image = img
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            var error:NSError?
            let fetchRequest = NSFetchRequest(entityName: "Thing")
            fetchRequest.predicate = NSPredicate(format: "title = %@", list[indexPath.row].valueForKey("title") as! String)
            
            let thing = context.executeFetchRequest(fetchRequest, error: &error)
            if error == nil {
                let t = thing?.last as! NSManagedObject
                context.deleteObject(t)
                
                if context.save(&error) == false {
                    println("Error = \(error?.description)")
                }
                list.removeAtIndex(indexPath.row)
                tableView.reloadData()
            } else {
                println("\(error?.description)")
            }
            
        } else if editingStyle == .Insert {
            println("Ok")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mySearchBar.resignFirstResponder()
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.performSegueWithIdentifier("detail", sender: cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationController = segue.destinationViewController as! DetailViewController
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                let thing = list[indexPath.row]
                destinationController.someTitle = thing.valueForKey("title") as? String
                destinationController.someText = thing.valueForKey("text") as? String
                destinationController.someBool = thing.valueForKey("isDone") as? Bool
            }
        }
    }
    
    @IBAction func addThing(sender: AnyObject) {
        var alert = UIAlertController(title: "New thing",
            message: "Add a new thing",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                let textFieldTitle = alert.textFields![0] as! UITextField
                let textFieldText = alert.textFields![1] as! UITextField
                self.save(textFieldTitle.text, text: textFieldText.text)
                self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Enter the title..."
            textField.textAlignment = .Center
            
        }
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Enter the text..."
            textField.textAlignment = .Center
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func save(title:String, text:String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Thing", inManagedObjectContext: managedContext)
        let thing = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        //3
        thing.setValue(title, forKey:"title")
        thing.setValue(text, forKey:"text")
        thing.setValue(false, forKey: "isDone")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        //5
        list.append(thing)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) == 0 {
            searchBar.resignFirstResponder()
            isFiltered = false
            tableView.reloadData()
        } else {
            filteredList.removeAll(keepCapacity: false)
            for object in list {
                let currentTitle = object.valueForKey("title") as! NSString
                var range: NSRange = currentTitle.rangeOfString(searchText)
                
                if range.location != NSNotFound {
                    if range.location == 0 {
                        filteredList.append(object)
                        isFiltered = true
                        tableView.reloadData()
                    }
                } else {
                    //isFiltered = false
                    tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        mySearchBar.resignFirstResponder()
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        
    }
    
    func checkForError() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

