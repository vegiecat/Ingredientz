//
//  RecipeListTVC.swift
//  Ingredientz
//
//  Created by Justin Lee on 5/13/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit

class RecipeListTVC: UITableViewController {
    
    private struct SegueID{
        static let showRecipeDetail = "Show Recipe Detail"
        static let Identifier2 = "yyy"
    }
    private struct Cells{
        static let Identifier1 = "xxx"
        static let Identifier2 = "yyy"
    }

    var dataSource:IngredientzCoreDataHelper?
    
    //Data Structure
    var recipes:[Recipe] = [Recipe](){
        didSet{
            println("RecipeListTVC Recipe Array did set, tableview is no longer reloaded")
            // 20150520: we used to reload tableview here, but to get insert row animation to work, we removed it
        }
    }
    //used to check for segue connectivity
    var imFrom:String?
    
    
    //REMOVE THIS LINE ; for prototype purposes
    var rowCount = 3
    
    
    var isInEditMode = false

    
    //MARK: - USER INTERACTION
    @IBAction func didTapAddBtn(sender : UIBarButtonItem) {
        recipeEditAlert(nil)
//        var newRecipeWindow = UIAlertController(title: "New Recipe", message: "Name your best dish", preferredStyle: UIAlertControllerStyle.Alert)
//        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
//            let textField = newRecipeWindow.textFields![0] as! UITextField
//            self.saveNewRecipe(textField.text)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction!) -> Void in}
//        newRecipeWindow.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in}
//        newRecipeWindow.addAction(saveAction)
//        newRecipeWindow.addAction(cancelAction)
//        presentViewController(newRecipeWindow, animated: true, completion: nil)
        
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
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var label = UILabel()
//        label.tag = section
//        label.userInteractionEnabled = true
//        label.text = "+ Tap to add recipe."
//        
//        //label.frame = CGRectMake(0, 0, tableView.tableFooterView?.frame.size.width!, tableView.tableFooterView?.frame.size.height!)
//        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "recipeAddAlert"))
//        
//        return label
//    }
    
    
    func recipeAddAlert(){
        if let ds = dataSource{
            var window = UIAlertController(title: "Recipe Name", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
                let txtFieldName = window.textFields![0] as! UITextField
                
                var recipeNew = ds.newRecipe()
                recipeNew.name = txtFieldName.text

                //save
                ds.save()
                self.refresh()
                //Push to Recipe Detail TVC
                self.dataSource?.didSelectRecipe(recipeNew, sender: self)
                self.performSegueWithIdentifier(SegueID.showRecipeDetail, sender: self)

            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in}
            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
            }
            window.addAction(saveAction)
            window.addAction(cancelAction)
            presentViewController(window, animated: true, completion: nil)
        }
    }
    
    //not being used, replaced with recipeAddAlert()
    func recipeEditAlert(recipe:Recipe?){
        if let ds = dataSource{
            var window = UIAlertController(title: "Recipe Name", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
                let txtFieldName = window.textFields![0] as! UITextField
                var recipeEdited:Recipe?
                //the first part of if will not be triggered, due to change of UI flow.
                if let recipeTemp = recipe{
                    //use the same name "recipeEdited"
                    recipeEdited = recipeTemp
                    recipeEdited?.name = txtFieldName.text
                    ds.save()
                    self.refresh()
                }else{
                    //create the index path for the new recipe
                    let lastRowIndexPath = NSIndexPath(forRow:self.recipes.count, inSection: 0);
                    
                    //create the new recipe and update our model
                    recipeEdited = ds.newRecipe()
                    recipeEdited?.name = txtFieldName.text

                    if let recipeNew = recipeEdited{
                        //update the model here
                        self.recipes.append(recipeNew)
                        
                        //now tell the view to get updated
                        self.tableView!.insertRowsAtIndexPaths([lastRowIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

                        //save
                        ds.save()
                        
                        //Push to Recipe Detail TVC
                        self.dataSource?.didSelectRecipe(recipeNew, sender: self)
                        self.performSegueWithIdentifier(SegueID.showRecipeDetail, sender: self)
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in}
            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
                textField.text = recipe?.name ?? ""
                textField.placeholder = "Recipe"
            }
            window.addAction(saveAction)
            window.addAction(cancelAction)
            presentViewController(window, animated: true, completion: nil)
        }
    }

    // MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        println("----------------RecipeListTVC is From:\(imFrom)----------------")
        //refetch all Recipe
        if let ds = dataSource{
            refresh()
        }else{
            dataSource = IngredientzCoreDataHelper()
            
            if isUserFirstTime() {
                addDefaultRecipes()
            }
            
            refresh()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    //refetch all the Recipe by user again
    func refresh(){
        println("----------------RecipeListTVC refresh()----------------")
        if let ds = dataSource{
            recipes = ds.fetchAllRecipesByUser()
            //println(recipes.map{"\($0.name):\($0.id)"})
            tableView.reloadData()
        }
    }

    //not being used right now.
    func saveNewRecipe(recipeName:String){
        if let ds = dataSource{
            let newRecipe = ds.newRecipe()
            newRecipe.name = recipeName
            ds.save()
            refresh()
        }
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
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    // MARK: - Table view data source, EDITING
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            dataSource?.deleteRecipe(recipes[indexPath.row])
            recipes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }
    */
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    
    
    // MARK: - Section Text
    override func viewDidLayoutSubviews() {
        tableView.footerViewForSection(0)?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "recipeAddAlert"))
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Tap to add recipe."
    }
    
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //setting the dataSource of the
        dataSource?.didSelectRecipe(recipes[indexPath.row], sender: self)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        recipeEditAlert(recipes[indexPath.row])
        println("accessory button tapped")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == SegueID.showRecipeDetail{
                if let tvc = segue.destinationViewController as? RecipeDetailTVC{
                    tvc.dataSource = self.dataSource
                }
            }
        }
    }
    
    
    // MARK: create default recipes
    
    func isUserFirstTime() -> Bool {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let userFirstTimeFlag = defaults.stringForKey("User First Time")
        {
            //if the key exists, it means user has loaded the app before
            println("user has laoded app before")
            return false
        } else {
            //if it doesn't exist, it's user first time
            //and mark the user as loaded the app
            //add the default recipes
            println("user's first time!")
            defaults.setObject(true, forKey: "User First Time")
            return true
        }
    }

    func addDefaultRecipes() {
        loadRecipeToDatabaseFromFile("Cookie")
        loadRecipeToDatabaseFromFile("1234Cake")
    }
    
    
    func loadRecipeToDatabaseFromFile(fileName : String) {
        if let ds = dataSource{
            
            if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
                if let aRecipe = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject> {
                    
                    //create new recipe
                    //create the new recipe and update our model
                    let newRecipe = ds.newRecipe()
                    
                    //set name
                    if let recipeName = aRecipe["Recipe Name"] as? String {
                        //println(recipeName)
                        newRecipe.name = recipeName
                    }
                    
                    //set ingredients
                    
                    if let recipeIngr = aRecipe["Ingredients"] as? Array<Dictionary<String,String>> {
                        
                        
                        //set item and name
                        for ingrItem in recipeIngr {
                            
                            //create new ingredient
                            var newIngr = ds.newIngr()

                            
                            if let ingrName = ingrItem["Name"] {
                                //println(ingrName)
                                newIngr.name = ingrName
                            }
                            
                            if let ingrQty = ingrItem["Qty"] {
                                //println(ingrQty)
                                newIngr.qty = ingrQty
                            }
                            
                            //assign the ingr. to the new recipe
                            newIngr.recipe = newRecipe
                        }
                        
                        //println(newRecipe)

                    }
                    
                    //save
                    ds.save()
                }
            }
        }
    }
}
