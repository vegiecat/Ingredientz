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
    let dataSource = IngredientzCoreDataHelper()
    
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
        let person = dataSource.newRecipe()
        person.name = name
        dataSource.save()
        fetchRecipe()
    }
    
    func fetchRecipe(){
        let fetchResults = dataSource.fetchAllRecipesByUser()
            println(fetchResults.map{"\($0.name):\($0.id)"})
    }
}
