//
//  SettingsVC.swift
//  Bombsweeper
//
//  Created by there#2 on 2/1/24.
//

import UIKit

class SettingsVC: UIViewController {

    var theme = "Ocean"
    var bombs = 10
    @IBOutlet weak var themeSelection: UISegmentedControl!
    @IBOutlet weak var bombsSelection: UISegmentedControl!
    @IBAction func themeSelected(_ sender: UISegmentedControl) {
        if themeSelection.selectedSegmentIndex == 0 {
            theme = "Volcano"
        } else if themeSelection.selectedSegmentIndex == 1 {
            theme = "Ocean"
        } else if themeSelection.selectedSegmentIndex == 2 {
            theme = "Landscape"
        }
    }
    @IBAction func bombsSelected(_ sender: UISegmentedControl) {
        if bombsSelection.selectedSegmentIndex == 0 {
            bombs = 5
        } else if bombsSelection.selectedSegmentIndex == 1 {
            bombs = 10
        } else if bombsSelection.selectedSegmentIndex == 2 {
            bombs = 20
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
