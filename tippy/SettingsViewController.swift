//
//  SettingsViewController.swift
//  tippy
//
//  Created by my mac on 12/8/16.
//  Copyright © 2016 Eduardo Carrillo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defTipPicker: UISegmentedControl!
    @IBOutlet weak var colorPicker: UISegmentedControl!
    @IBOutlet weak var defaultTipLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    
    //Light color theme
    let darkPrimaryColor = UIColor.black
    let darkSecondaryColor = UIColor.white
    //Dark color theme
    let lightPrimaryColor = UIColor.white
    let lightSecondaryColor = UIColor.black
    //Cool blue theme
    var coolPrimaryColor = UIColor.init(displayP3Red: 0.0, green: 33/255.0, blue: 71/255.0, alpha: 1.0)
    public let coolSecondaryColor = UIColor.init(displayP3Red: (28/255.0), green: (211/255.0),
                                                   blue: (255/255.0), alpha: 1.0)
    
     @IBOutlet var backgroundView: UIView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //Remember the the default tip percentage if already set
        let defaults = UserDefaults.standard;
        let tipIndex = defaults.integer(forKey: "tip_index")
        defTipPicker.selectedSegmentIndex = tipIndex
        let colorIndex = defaults.integer(forKey: "color_scheme")
        colorPicker.selectedSegmentIndex = colorIndex
       
        updateUIColor(currColorScheme: colorIndex)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onDefaultTipChanged(_ sender: Any) {
        
        let index = defTipPicker.selectedSegmentIndex
        let defaults = UserDefaults.standard
        //Put index of tip into (value, key)
        defaults.set(index, forKey: "tip_index")
        //Refresh cache
        defaults.synchronize()
        
    }
 
    
    @IBAction func onColorChanged(_ sender: AnyObject) {
        let colorIndex = colorPicker.selectedSegmentIndex
        let defaults = UserDefaults.standard
        updateUIColor(currColorScheme: colorIndex)
        //Save the choice
        defaults.set(colorIndex, forKey: "color_scheme")
        //Refresh the cache
        defaults.synchronize()
        print("Color changed")
    }
    
    func updateUIColor(currColorScheme : Int){
    
    let primaryColors = [lightPrimaryColor, darkPrimaryColor, coolPrimaryColor]
    let secondaryColors = [lightSecondaryColor, darkSecondaryColor, coolSecondaryColor]
    
    let primaryColor = primaryColors[currColorScheme]
    let secondaryColor = secondaryColors[currColorScheme]
        //Update the tipPicker
        defTipPicker.tintColor = secondaryColor
        defTipPicker.backgroundColor = primaryColor
        //Update the color picker
        colorPicker.tintColor = secondaryColor
        colorPicker.backgroundColor = primaryColor
        //Update the default tip label
        defaultTipLabel.backgroundColor = primaryColor
        defaultTipLabel.textColor = secondaryColor
        //Update the color labelb
        colorLabel.backgroundColor = primaryColor
        colorLabel.textColor = secondaryColor
        
        backgroundView.backgroundColor = primaryColor
        //Updat the color of the back elements of nav bar
        self.navigationController?.navigationBar.barTintColor = secondaryColor
        //Update the color of the title text
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : primaryColor]
        //Update the color the navbar
        self.navigationController?.navigationBar.tintColor = primaryColor

    
    }
    
    
   
   


}
