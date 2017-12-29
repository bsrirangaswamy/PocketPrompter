//
//  SettingsDetailViewController.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 12/28/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UIViewController {

    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var sliderTitleLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var textSizeValue: Float = 1.0
    var scrollSpeedValue: Float = 1.0
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch index {
        case 0:
            self.sliderTitleLabel.text = "Text Size Value:"
            if UserDefaults.standard.float(forKey: "textSize") > 0.0 {
                textSizeValue = UserDefaults.standard.float(forKey: "textSize")
            }
            self.speedSlider.value = textSizeValue
            self.sliderValueLabel.text = "\(roundf(textSizeValue*20))"
        case 1:
            break
        case 2:
            break
        case 3:
            self.sliderTitleLabel.text = "Scroll Speed Value Value:"
            if UserDefaults.standard.float(forKey: "scrollSpeed") > 0.0 {
                scrollSpeedValue = UserDefaults.standard.float(forKey: "scrollSpeed")
            }
            self.speedSlider.value = scrollSpeedValue
            self.sliderValueLabel.text = "\(roundf(scrollSpeedValue*10))"
        default:
            break
        }
    }

    @IBAction func sliderValueChaged(_ sender: Any) {
        print ("Bala slider value = \(speedSlider.value)")
        switch index {
        case 0:
            textSizeValue = speedSlider.value
            sliderValueLabel.text = "\(roundf(textSizeValue*20))"
        case 3:
            scrollSpeedValue = speedSlider.value
            sliderValueLabel.text = "\(roundf(scrollSpeedValue*10))"
        default:
            break
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        switch index {
        case 0:
            UserDefaults.standard.set(textSizeValue, forKey: "textSize")
            UserDefaults.standard.synchronize()
        case 3:
            UserDefaults.standard.set(scrollSpeedValue, forKey: "scrollSpeed")
            UserDefaults.standard.synchronize()
        default:
            break
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
