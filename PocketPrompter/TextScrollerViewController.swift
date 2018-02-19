//
//  TextScrollerViewController.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 12/12/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class TextScrollerViewController: UIViewController {

    @IBOutlet weak var playTextView: UITextView!
    @IBOutlet weak var playAction: UIButton!
    @IBOutlet weak var settingsAction: UIButton!
    
    var textViewString: String?
    var scrollTimer: Timer?
   
    private var textSizeCorrectedValue: Float = 20.0
    private var scrollSpeedCorrectedValue: Float = 10.0
    private var textColorTypeValue = UIColor.black
    private var backgroundColorTypeValue = UIColor.white
    
    var colorsTitleArray = ["Cave Black", "Mercury Grey", "Chalk White", "Royal Blue", "Light Sapphire", "Fiery Red", "Sunset Orange", "Sunflower Yellow"]
    var colorsValueArray = [UIColor.black, UIColor.gray, UIColor.whiteAccentColor(), UIColor.blue,UIColor.blueAccentColor(), UIColor.red, UIColor.orangeAccentColor(), UIColor.yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playTextView.text = textViewString
        
        if UserDefaults.standard.float(forKey: "textSize") > 0.0 {
            textSizeCorrectedValue = UserDefaults.standard.float(forKey: "textSize")*20
        }
        
        if UserDefaults.standard.float(forKey: "scrollSpeed") > 0.0 {
            scrollSpeedCorrectedValue = UserDefaults.standard.float(forKey: "scrollSpeed")*10
        }
        
        if let textColorString = UserDefaults.standard.string(forKey: "textColorType") {
           let index = colorsTitleArray.index(of: textColorString) ?? 0
            textColorTypeValue = colorsValueArray[index]
        } else {
            textColorTypeValue = UIColor.black
        }
        
        if let backgroundColorString = UserDefaults.standard.string(forKey: "backgroundColorType") {
            let index = colorsTitleArray.index(of: backgroundColorString) ?? 2
            backgroundColorTypeValue = colorsValueArray[index]
        } else {
            backgroundColorTypeValue = colorsValueArray[2]
        }
        
        // initial setup for prompter
        playTextView.font = UIFont(name: playTextView.font!.fontName, size: CGFloat(textSizeCorrectedValue))
        playTextView.textColor = textColorTypeValue
        playTextView.backgroundColor = backgroundColorTypeValue
        view.backgroundColor = backgroundColorTypeValue
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            startScrolling()
        } else {
            stopScrolling()
        }
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.scrollTimer?.invalidate()
        self.scrollTimer = nil
    }
    
//    func scrollToBottom() {
//        let range = NSMakeRange(playTextView.text.count - 1, 1)
//        playTextView.scrollRangeToVisible(range)
//    }
    
    func scrollToTop() {
        playTextView.setContentOffset(.zero, animated: true)
    }

    func startScrolling() {
        playAction.setTitle("PAUSE", for: .normal)
        playAction.setTitleColor(UIColor.white, for: .selected)
        let animationDuration : TimeInterval = TimeInterval((0.6 / self.pointsPerSecond()))
        self.scrollTimer = Timer.scheduledTimer(timeInterval: animationDuration, target: self, selector: #selector(self.updateScroll), userInfo: nil, repeats: true)
    }
    
    func stopScrolling() {
        playAction.setTitle("PLAY", for: .normal)
        playAction.setTitleColor(UIColor.white, for: .normal)
        self.scrollTimer?.invalidate()
    }
    
    func updateScroll(){
        
        // guard for the scroll to ensure the timer is not nil
        guard let _ = self.scrollTimer else { return }
        
        // guard to stop scrolling once the after the last word
        guard self.playTextView.contentOffset.y < self.playTextView.contentSize.height else {
            self.stopScrolling()
            self.scrollToTop()
            return
        }
        
        let animationDuration : TimeInterval = self.scrollTimer!.timeInterval
        let pointChange : CGFloat = self.pointsPerSecond() * CGFloat(animationDuration)
        var newOffset : CGPoint = self.playTextView.contentOffset
        newOffset.y = newOffset.y + pointChange
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.playTextView.contentOffset = newOffset
        })
    }
    
    func pointsPerSecond() -> CGFloat {
        var speed : CGFloat?
        speed = CGFloat((scrollSpeedCorrectedValue) * 20.0)
        return speed!
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

extension UIColor {
    class func blueAccentColor() -> UIColor {
        return UIColor(red: 33/255, green: 150/255, blue:243/255 , alpha:1.00)
    }
    
    class func orangeAccentColor() -> UIColor {
        return UIColor(red: 255/255, green: 145/255, blue:0/255 , alpha:0.85)
    }
    
    class func whiteAccentColor() -> UIColor {
        return UIColor(red: 249/255, green: 249/255, blue:249/255 , alpha:1.00)
    }
}
