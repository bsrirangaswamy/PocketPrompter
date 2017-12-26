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
    weak var displayLink: CADisplayLink?
    var scrollTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playTextView.text = textViewString
        
        // initial setup for prompter
        playTextView.font = UIFont(name: playTextView.font!.fontName, size: 40)
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
        
        print ("Bala content size = \(self.playTextView.contentSize)")
        print ("Bala content size.width = \(self.playTextView.contentSize)")
        print ("Bala content Offset = \(self.playTextView.contentOffset)")
        print ("Bala content Offset.y = \(self.playTextView.contentOffset.y)")
    }
    
    func pointsPerSecond() -> CGFloat {
        var speed : CGFloat?
        speed = CGFloat((10.0) * 5.0)
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
