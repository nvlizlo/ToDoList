//
//  DetailViewController.swift
//  toDoList
//
//  Created by user on 3/24/15.
//  Copyright (c) 2015 user. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textView: MyTextView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var switchView: UISwitch!
    
    var array = [NSManagedObject]()
    
    var someTitle:String?
    var someText:String?
    var someBool:Bool?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = someText
        titleField.text = someTitle
        switchView.on = someBool!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true;
    }
    
    @IBAction func chooseImage() {
        
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            var error:NSError?
            
            let entity = NSEntityDescription.entityForName("Thing", inManagedObjectContext: context)
            let fetchRequest = NSFetchRequest(entityName: "Thing")
            fetchRequest.predicate = NSPredicate(format: "title = %@", someTitle!)
            let fetchedObjects = context.executeFetchRequest(fetchRequest, error: &error)
            
            if error == nil {
                let thing = fetchedObjects?.last as! NSManagedObject
                thing.setValue(titleField.text, forKey: "title")
                thing.setValue(textView.text, forKey: "text")
                thing.setValue(switchView.on, forKey: "isDone")
                if !context.save(&error) {
                    println("Save error - \(error?.description)")
                }
            } else {
                println("\(error?.description)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
