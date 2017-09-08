//
//  ViewController.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 8/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK : - IBOutlets
    @IBOutlet weak var addANewFileButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func addANewFileButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "imageRecognizer", sender: self)
    }
    
    func performImageRecognition(image: UIImage) {
        // 1
        let tesseract = G8Tesseract()
        // 2
        tesseract.language = "eng+fra"
        // 3
        tesseract.engineMode = .tesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .auto
        // 5
        tesseract.maximumRecognitionTime = 60.0
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

