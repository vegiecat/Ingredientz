//
//  RecipeListTVC.swift
//  Ingredientz
//
//  Created by Justin Lee on 5/13/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit

class RecipeListTVC: UITableViewController {
    
    private struct Storyboard{
        static let showRecipeDetail = "Show Recipe Detail"
        static let Identifier2 = "yyy"
    }
    private struct Cells{
        static let Identifier1 = "xxx"
        static let Identifier2 = "yyy"
    }

    var dataSource = IngredientzCoreDataHelper()
    
    //Data Structure
    var recipes:[Recipe] = [Recipe](){
        didSet{
            tableView.reloadData()
        }
    }
    //used to check for segue connectivity
    var imFrom:String?
    
    
    //REMOVE THIS LINE ; for prototype purposes
    var rowCount = 3
    
    
    var isInEditMode = false

    //MARK: - USER INTERACTION
    @IBAction func didTapAddBtn(sender : UIBarButtonItem) {
        
        var newRecipeWindow = UIAlertController(title: "New Recipe", message: "Name your best dish", preferredStyle: UIAlertControllerStyle.Alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
            let textField = newRecipeWindow.textFields![0] as! UITextField
            self.saveNewRecipe(textField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction!) -> Void in}
        newRecipeWindow.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in}
        newRecipeWindow.addAction(saveAction)
        newRecipeWindow.addAction(cancelAction)
        presentViewController(newRecipeWindow, animated: true, completion: nil)
        
                //Justin's place holding code.
        /*
        rowCount++
        
        //index path to add
        let newRow = NSIndexPath(forRow: 0, inSection: 0)
        
        self.tableView.insertRowsAtIndexPaths([newRow], withRowAnimation: .Automatic)
        */
    }

    
    @IBAction func didTapEditBtn(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        self.tableView.setEditing(isInEditMode, animated: true)
    }
    
    // MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        println("I'm From:\(imFrom)")
        refresh()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    func refresh(){
        recipes = dataSource.fetchAllRecipesByUser()
        println(recipes.map{"\($0.name):\($0.id)"})
    }

    func saveNewRecipe(recipeName:String){
        let newRecipe = dataSource.newRecipe()
        newRecipe.name = recipeName
        dataSource.save()
        refresh()

    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: update this
        return recipes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("recipe cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = recipes[indexPath.row].name ?? ""
        return cell
    }

    // MARK: - Table view data source, EDITING
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        println("accessory button tapped")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
