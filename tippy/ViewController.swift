//
//  ViewController.swift
//  tippy
//
//  Created by my mac on 12/8/16.
//  Copyright © 2016 Eduardo Carrillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //_________Views______________________
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var tipTotal: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tipGroup: UIView!
    @IBOutlet weak var equalSign: UILabel!
    @IBOutlet weak var additionSign: UILabel!

  
    
       //___________Colors____________________________
    //Light color theme
    let darkPrimaryColor = UIColor.white
    let darkSecondaryColor = UIColor.black
    //Dark color theme
    let lightPrimaryColor = UIColor.black
    let lightSecondaryColor = UIColor.white
    //Cool blue color theme
    var coolSecondaryColor = UIColor.init(displayP3Red: 0.0, green: 33/255.0, blue: 71/255.0, alpha: 1.0)
    let coolPrimaryColor = UIColor.init(displayP3Red: (28/255.0), green: (211/255.0),
                                        blue: (255/255.0), alpha: 1.0)
    
    
    
    //Used for saving data across app restarts
    let defaults = UserDefaults.standard
    
    var keyBoardHeight : CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        //Retrieve the saved color scheme and update accordingly
        let currColorScheme =  defaults.integer(forKey: "color_scheme")
        
        let primaryColors = [lightPrimaryColor, darkPrimaryColor, coolPrimaryColor]
        let secondaryColors = [lightSecondaryColor, darkSecondaryColor, coolSecondaryColor]
        
        let currPrimaryColor = primaryColors[currColorScheme]
        let currSecondaryColor = secondaryColors[currColorScheme]
        
        updateUIColor(primaryColor: currPrimaryColor, secondaryColor: currSecondaryColor)
        
        //Change the size of the text field
        billField.font =  UIFont.init(name: (billField.font?.fontName)!, size: 50)
        
        //Retrieve the default tip index
        let index = defaults.integer(forKey: "tip_index")
        tipControl.selectedSegmentIndex = index
        
        //Reset to defaults if more than ten minutes passed
        if (didTimeElapse()){
            resetToDefaults()
        }
        
        
        //save the new time info into UserData
        saveNewDate()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        //Make sure keyboard pops up right away
        billField.becomeFirstResponder()
        //After keyboard pops up on screen animate bill and tip calculations up so user can see
        UIView.animate(withDuration: 0.2, animations: {
            self.tipGroup.transform = CGAffineTransform(translationX: 0, y: -(CGFloat)(self.keyBoardHeight))
        })
        defaults.synchronize()
        let val = defaults.double(forKey: "bill")
        defaults.synchronize()
        
        updateUIBill(value: val )
        //Update the tip if percentage was changed from default
        calculateTip(self)
        
        //Reset to defaults if more than ten minutes passed
        if (didTimeElapse()){
            resetToDefaults()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        //Call keyboard willShow then the keyboard is being created so we have access to the keyboard height
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: .UIKeyboardWillShow, object: nil)
        
    }
    
    //Get information about the keyboard in this function
   @objc fileprivate func keyboardWillShow(notification: NSNotification){
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        keyBoardHeight =
            (keyboardSize?.height)!
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("did recieve memory")
        // Dispose of any resources  that can be recreated.
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func editingStarted(_ sender: AnyObject) {
        //When user starts using the keyboard move the views up so user can see them over the keyboard
        UIView.animate(withDuration: 0.2, animations: {
            self.tipGroup.transform = CGAffineTransform(translationX: 0, y: -(CGFloat)(self.keyBoardHeight))
        })
    }
    @IBAction func editingStopped(_ sender: AnyObject) {
        //When user is finished editing put the views back down to bottom of the screen
        UIView.animate(withDuration: 0.2, animations: {
            self.tipGroup.transform = CGAffineTransform(translationX: 0, y: 0.0)
        })
    }

    
    
    
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        //Convert String -> Double and give default value of 0 if invalid number string
        let bill = Double(billField.text!) ?? 0
        //Have tip percentages ready to be used
        let tipPercentages = [0.18,0.2,0.25]
        //Calculate the tip
        let tip = bill*tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        //Convert raw calculated values into currency string
        let tipStr = toLocalCurrency(value: tip)
        let totalStr = toLocalCurrency(value: total)
        //Update the UI
        tipTotal.text = tipStr
        totalLabel.text = totalStr
        
        saveBill(bill: bill)
    }
    
    /*Resets the bill to the default value 0. So save bill value as 0 accross screen restart
      and make sure bill UITextfield shows nothing*/
    func resetToDefaults(){
        print("Reset to defaults")
        saveBill(bill: 0.0)
        updateUIBill(value: 0.0)
    }
    
    /*Update the bill text field based on value passed in. If the number is 0
     then show the empty string. Also if the value is an integer make sure it appears
     as an integer*/
    func updateUIBill(value: Double){
        let string : String
        if (value == 0.0){
            string  = ""
        }else{
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            
            formatter.maximumFractionDigits = 2
            string = formatter.string(from: NSNumber(value:value))!
        }
        
        billField.text = string
    }
    
    func updateUITipControl(index: Int){
        tipControl.selectedSegmentIndex = index
    }
    
    func updateUIColor(primaryColor : UIColor, secondaryColor : UIColor){
        //Update the bill field
        billField.backgroundColor = primaryColor
        billField.textColor = secondaryColor
        billField.tintColor = secondaryColor
        //Update the navigation bar
        let navBar = self.navigationController?.navigationBar
        //Update the tool bar
        navBar?.barTintColor = secondaryColor.withAlphaComponent(1.0)
        navBar?.backgroundColor = secondaryColor
        
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName : primaryColor]
        settingsButton.tintColor = primaryColor
        //Update the background color the app
        backgroundView.backgroundColor = primaryColor
        //Update the tip field
        tipTotal.textColor = primaryColor
        //Update the total
        totalLabel.textColor = primaryColor
        //Update the segmented control colors
        tipControl.tintColor = primaryColor
        tipControl.backgroundColor = secondaryColor
        //Update the addition and equals sign
        equalSign.textColor = primaryColor
        additionSign.textColor = primaryColor
        //Update the color of the UIVIew group
        tipGroup.tintColor = secondaryColor
        tipGroup.backgroundColor = secondaryColor
        
        
    }
    
    func didTimeElapse() -> Bool {
        // Get the current date
        
        let currentDate = Date()
        let calendar = NSCalendar.current
        
        
        let currMin = calendar.component(Calendar.Component.minute, from: currentDate)
        let currHour = calendar.component(Calendar.Component.hour, from: currentDate)
        let currDay = calendar.component(Calendar.Component.day, from: currentDate)
        let currMonth = calendar.component(Calendar.Component.month, from: currentDate)
        
        
        //If there is a stored data then take the difference
        let storedMin = defaults.integer(forKey: "stored_min")
        let storedHour = defaults.integer(forKey: "stored_hour")
        let storedDay = defaults.integer(forKey: "stored_day")
        let storedMonth = defaults.integer(forKey: "stored_month")
        
        //Calculate the elapsed time
        let monthChange = currMonth - storedMonth
        let dayChange = currDay - storedDay
        let hourChange = currHour - storedHour
        let minChange = currMin - storedMin
        
        
        if (monthChange > 0 || dayChange > 0 ||
            hourChange > 0 || minChange > 10){
            return true;
        }
        return false;
        
        
    }
    
    func toLocalCurrency(value : Double) -> String {
        let number = NSDecimalNumber(value: value)
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        let formattedText = numberFormatter.string(from: number)
        
        return formattedText!;
    }
    
    
    func saveNewDate(){
        //Get the current date and its components
        let currentDate = Date()
        let calendar = NSCalendar.current
        let newMin = calendar.component(Calendar.Component.minute, from: currentDate)
        let newHour = calendar.component(Calendar.Component.hour, from: currentDate)
        let newDay = calendar.component(Calendar.Component.day, from: currentDate)
        let newMonth = calendar.component(Calendar.Component.month, from: currentDate)
        //save the indivdual date components to UserDefaults
        defaults.set(newMonth, forKey: "stored_month")
        defaults.set(newDay, forKey: "stored_day")
        defaults.set(newHour, forKey: "stored_hour")
        defaults.set(newMin, forKey: "stored_min")
        defaults.synchronize()
        
    }
    
    
    func saveBill(bill : Double){

        defaults.synchronize()
        defaults.set(bill, forKey: "bill")
        defaults.synchronize()
    }
    
    
    
    func saveNewTipIndex(newIndex : Int){
        defaults.set(newIndex, forKey: "tip_index")
        defaults.synchronize()
        
    }
    
    
    
}

private extension Selector {
    static let keyboardWillShow  = #selector(ViewController.keyboardWillShow(notification:))
}

