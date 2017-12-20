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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playTextView.text = textViewString
        
        // initial setup for prompter
        playTextView.font = UIFont(name: playTextView.font!.fontName, size: 40)
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
       scrollToBotom()
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollToBotom() {
        let range = NSMakeRange(playTextView.text.count - 1, 1)
        playTextView.scrollRangeToVisible(range)
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
