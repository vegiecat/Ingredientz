//
//  RecipeDetailTVC.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/19/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit

class RecipeDetailTVC: UITableViewController {

    private struct SegueID{
        static let kitchenModeSegueID = "show kitchen mode"
        static let ID2 = "yyy"
    }
    private struct Cells{
        static let RecipeDetailGeneral = "Recipe Detail Cell"
        static let IngredientItemCell = "Ingredient Item Cell"
    }
    private struct SectionTitles{
        static let name = "Name"
        static let ingredients = "Ingredients"
    }

    var dataSource:IngredientzCoreDataHelper?{
        didSet{
            println("----------------RecipeDetailTVC dataSource didSet{}----------------")
        }
    }
    
    //used to check for segue connectivity
    var imFrom:String?

    // Public API
    var recipe:Recipe?{
        didSet{
            println("----------------RecipeDetailTVC recipe didSet{}----------------")
            recipeContents.append(RecipeSection(title: SectionTitles.name, recipeItems:[RecipeItem.name(recipe!.name)] ))
            let ingrdientsArray = recipe!.ingr.array as! [Ingr]
            //let test = ingrdientsArray.map{(ingr:Ingr)->String in return ingr.name}
            let ingredients = RecipeSection(title: SectionTitles.ingredients, recipeItems: ingrdientsArray.map{RecipeItem.ingredient($0)})
            recipeContents.append(ingredients)
            tableView.reloadData()
            
        }
    }
    
    //Private Data Structure
    private var recipeContents:[RecipeSection] = []
    
    private struct RecipeSection{
        var title:String
        var recipeItems:[RecipeItem]
        var description:String{
            return "\(title):\(recipeItems)"
        }
    }
    
    private enum RecipeItem:Printable{
        //case photo(NSData,Double)
        case name(String)
        case ingredient(Ingr)
        var description:String{
            get{
                switch self{
                case .name(let name):
                    return name
                case .ingredient(let ingredient):
                    return ingredient.name
                }
            }
        }
    }
    
    var isInEditMode = false
    
    @IBAction func addIngredient(sender: UIBarButtonItem) {
        ingredientEditAlert(nil)
//        if let ds = dataSource{
//            var window = UIAlertController(title: "New Recipe", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
//                let textField = window.textFields![0] as! UITextField
//                var newIngredient = ds.newIngr()
//                newIngredient.name = textField.text
//                ds.save()
////                let tempIngr = recipe?.ingr as! NSMutableOrderedSet
////                tempIngr.addObject(newIngredient)
////                ingredientEditAlert(newIngredient)
//                self.refresh()
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in}
//            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
//                textField.text = ""
//                textField.placeholder = "Ingredient"
//            }
//            window.addAction(saveAction)
//            window.addAction(cancelAction)
//            presentViewController(window, animated: true, completion: nil)
//        }
    }
    
    @IBAction func didTapEditBtn(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        self.tableView.setEditing(isInEditMode, animated: true)
    }
    
    
    //code needs to be modulaized in a later phase.
    func ingredientEditAlert(ingredient:Ingr?){
        if let ds = dataSource{
            var window = UIAlertController(title: "Edit Ingredient", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
                let txtFieldName = window.textFields![0] as! UITextField
                let txtFieldQty = window.textFields![1] as! UITextField
                var ingredientEdited:Ingr?
                if let ingredientTemp = ingredient{
                    ingredientEdited = ingredientTemp
                }else{
                    ingredientEdited = ds.newIngr()
                }
                ingredientEdited?.name = txtFieldName.text
                ingredientEdited?.qty = txtFieldQty.text
                ds.save()
                self.refresh()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in}
            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
                textField.text = ingredient?.name ?? ""
                textField.placeholder = "Ingredient"
            }
            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
                textField.text = ingredient?.qty ?? ""
                textField.placeholder = "Quantity"
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
        if let ds = dataSource{
            refresh()
        }
    }

    func refresh(){
        recipeContents.removeAll()
        recipe = dataSource?.recipeOfInterest(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return recipeContents.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeContents[section].recipeItems.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipeContents[section].title
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = recipeContents[indexPath.section].recipeItems[indexPath.row]
        switch item{
        case .name(let name):
            let cell = tableView.dequeueReusableCellWithIdentifier(Cells.RecipeDetailGeneral, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = name
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell
        case .ingredient(let ingredient):
            let cell = tableView.dequeueReusableCellWithIdentifier(Cells.IngredientItemCell, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = ingredient.name
            //println("detailTextLabel:\(ingredient.qty) order:\(ingredient.order)")
            
            cell.detailTextLabel?.text = ingredient.qty ?? ""
            if ingredient.qty != "" {
                cell.layoutIfNeeded()
            }
            //println("detailTextLabel.text:\(cell.detailTextLabel?.text)")
            
            
            return cell
        }
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = recipeContents[indexPath.section].recipeItems[indexPath.row]
        switch item{
        case .name(let name):
            println("decide if we should let them edit name here")
        case .ingredient(let ingredient):
            ingredientEditAlert(ingredient)
        }
    }
    
    // MARK: - Table view data source, EDITING
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 0) {return false}
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
//            if let ingredientSet = recipe?.ingr{
//                if let ingredient = ingredientSet.objectAtIndex(indexPath.row) as? Ingr{
//                    dataSource?.deleteIngr(ingredient)
//                    refresh()
//                }
//            }
            if var ingredientArray = recipe?.ingr.array as? [Ingr]{
                let ingredientToBeRemoved = ingredientArray.removeAtIndex(indexPath.row)
                recipe?.ingr = NSOrderedSet(array: ingredientArray)
                
                dataSource?.deleteIngr(ingredientToBeRemoved)
                refresh()
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var ingredientSet = recipe?.ingr.array as! [Ingr]
        ingredientSet.moveObjectsAtIndexes(fromIndexPath.row, toIndex: toIndexPath.row)
        for i in 1...ingredientSet.count{
            ingredientSet[i-1].order = i
        }


        
//        let temp = ingredientSet[fromIndexPath.row] as!Ingr
//        ingredientSet.moveObjectsAtIndexes(NSIndexSet(index: fromIndexPath.row), toIndex: toIndexPath.row)
        
//        var i = 1
//        for ingr in ingredientSet.array as! [Ingr]{
//            println(ingr)
//            ingr.order = i
//            i = i+1
//        }
        //ingredientSet.exchangeObjectAtIndex(fromIndexPath.row, withObjectAtIndex: toIndexPath.row)
        //ingredientSet.removeObjectAtIndex(fromIndexPath.row)
//        let newIngredientSet = ingredientSet as NSOrderedSet
//        recipe?.ingr = newIngredientSet
        
        dataSource?.save()
        dataSource?.reloadRecipeOfInterest()
        refresh()
        
//        println(recipe?.hasChanges)
//        let temp = recipe?.ingr.array as! [Ingr]
//        for tempIngr in temp{
//            println(tempIngr.hasChanges)
//        }

    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    
    // MARK: - Navgiation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == SegueID.kitchenModeSegueID {
                if let kmvc = segue.destinationViewController as? KitchenModeVC{
                    
                    // TODO: needs this to be wired up
                    
                    //kitchen mode vc needs an array of ingr names and array of qty
                    let ingrArray = recipe?.ingr.array as! [Ingr]
                    kmvc.ingredientNames = ingrArray.map{$0.name}
                    kmvc.quantities = ingrArray.map{$0.qty}
                }
            }
        }
    }
}

extension Array{
    mutating func moveObjectsAtIndexes(index:Int, toIndex:Int){
        let temp = self.removeAtIndex(index)
        self.insert(temp, atIndex: toIndex)
    }
}