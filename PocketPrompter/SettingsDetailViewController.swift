//
//  SettingsDetailViewController.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 12/28/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var sliderTitleLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var sliderStackView: UIStackView!
    @IBOutlet weak var colorsTableView: UITableView!
    
    var index = 0
    
    var colorsTitleArray = ["Cave Black", "Mercury Grey", "Royal Blue", "Fiery Red", "Sunny Yellow"]
    var colorsValueArray = [UIColor.black, UIColor.lightGray, UIColor.blue, UIColor.red, UIColor.yellow]
    
    private var textSizeValue: Float = 1.0
    private var scrollSpeedValue: Float = 1.0
    private var colorType: String = "Cave Black"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorsTableView!.register(UINib(nibName: "PromptDataTableViewCell", bundle: nil), forCellReuseIdentifier: "promptDataTableViewCell")
        
        switch index {
        case 0:
            self.colorsTableView.isHidden = true
            self.sliderTitleLabel.text = "Text Size:"
            if UserDefaults.standard.float(forKey: "textSize") > 0.0 {
                textSizeValue = UserDefaults.standard.float(forKey: "textSize")
            }
            self.speedSlider.value = textSizeValue
            self.sliderValueLabel.text = "\(roundf(textSizeValue*20))"
        case 1:
            selectSpecifiedTableViewCell(withString: UserDefaults.standard.string(forKey: "textColorType"))
            self.speedSlider.isHidden = true
            self.sliderStackView.isHidden = true
            break
        case 2:
            selectSpecifiedTableViewCell(withString: UserDefaults.standard.string(forKey: "backgroundColorType"))
            self.speedSlider.isHidden = true
            self.sliderStackView.isHidden = true
            break
        case 3:
            self.colorsTableView.isHidden = true
            self.sliderTitleLabel.text = "Scroll Speed Value:"
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
        case 1:
            UserDefaults.standard.set(colorType, forKey: "textColorType")
            UserDefaults.standard.synchronize()
            break
        case 2:
            UserDefaults.standard.set(colorType, forKey: "backgroundColorType")
            UserDefaults.standard.synchronize()
            break
        case 3:
            UserDefaults.standard.set(scrollSpeedValue, forKey: "scrollSpeed")
            UserDefaults.standard.synchronize()
        default:
            break
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    func selectSpecifiedTableViewCell(withString: String?) {
        var row = index-1
        
        if let stringValue = withString {
            row = colorsTitleArray.index(of: stringValue) ?? index-1
        }
        let selectRow = IndexPath(row: row, section: 0)
        colorsTableView.selectRow(at: selectRow, animated: true, scrollPosition: .none)
        colorsTableView.delegate?.tableView!(colorsTableView, didSelectRowAt: selectRow)
    }
    
    // MARK : - TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promptDataTableViewCell") as! PromptDataTableViewCell
        
        print ("Bala color in table view cell= \(colorsTitleArray[indexPath.row])")
        cell.selectionStyle = .none
        cell.textTitleLabel.text = colorsTitleArray[indexPath.row]
        cell.snapShotImageView.backgroundColor = colorsValueArray[indexPath.row]
        cell.separatorLineView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            print ("Bala row selected = \(indexPath.row)")
            colorType = colorsTitleArray[indexPath.row]
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            print ("Bala row unselected = \(indexPath.row)")
            cell.accessoryType = .none
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
