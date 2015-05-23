import UIKit

class KitchenModeVC: UIViewController {

    //TO USE THIS CLASS, BEFORE VIEW LOADS SET ingredientNames with an array of strings and a quantities array of strings
    //make sure these arrays are paired
    
    //TODO: remove the data inside for release
    var ingredientNames = ["Pop corn","ketchup"]
    var quantities = ["A lot of it","just a little bit"]

    // MARK: - Private Beyond this point

    var ingredientIndex = 0
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    // MARK: - User interaction
    @IBAction func previousButtonTapped(sender: UIButton) {
        if (ingredientIndex == 0) {
            //don't do anything, since we're in the beginning
        } else {
            ingredientIndex--
        }
        updateUI()
    }
    
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if (ingredientIndex == ingredientNames.count - 1) {
            //don't do anything, since we're at the end
        } else {
            ingredientIndex++
        }
        updateUI()
    }
    
    
    // MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (ingredientNames.count != quantities.count) {
            //if these two arrays don't have the same count, print an error
            println("KitchenMode VC ERROR DURING VIEW DID LOAD - ingrNames and quantities Array don't have same count!!!")
        } else {
            updateUI()  //the first item in the paired arrays will be loaded to UI since index is 0
        }
    }
    
    // MARK: - UI Update
    func updateUI() {
        ingredientLabel.text = ingredientNames[ingredientIndex]
        quantityLabel.text = quantities[ingredientIndex]
        
        //if we are at the first item, we disable the previous button
        if (ingredientIndex == 0) {
            previousButton.hidden = true
        } else {
            previousButton.hidden = false
        }
        
        //if we are at the last item, we disable the next button
        if (ingredientIndex == ingredientNames.count-1) {
            nextButton.hidden = true
        } else {
            nextButton.hidden = false
        }
    }
  }
