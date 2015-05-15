//
//  TestViewController.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/15/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit
import CoreData

class TestViewController: UIViewController,UITextFieldDelegate {

    var people = [Recipe]()

    
    @IBOutlet weak var addField: UITextField!{
        didSet{
            addField?.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == addField{
            textField.resignFirstResponder()
            addRecipe(textField.text)
            textField.text = ""
            
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    func addRecipe(name:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: managedContext!)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext!)
        person.setValue(name, forKey:"name")
        var error:NSError?
        if !managedContext!.save(&error){
            println("Could not save \(error), \(error?.userInfo)")
        }
        println("added")
        fetchRecipe()
    }
    
    func fetchRecipe(){
        println("hello")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        var error:NSError?
        
        let fetchResults = managedContext?.executeFetchRequest(fetchRequest, error: &error) as?[NSManagedObject]
        for i in fetchResults!{
            println(i.valueForKey("name"))

        }

    }
    
    

}
