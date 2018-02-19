//
//  ImageRecognizerViewController.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 8/28/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit
import CoreData

class ImageRecognizerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK : - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var placeHolderBodyTextLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var bodyTextviewToSaveButtonTConstraint: NSLayoutConstraint!
    
    var userData: [NSManagedObject] = []
    var savedTitle: String?
    var savedBodyText: String?
    var objectIndex: Int?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign delegate to the view controller
        bodyTextView.delegate = self
        
        // add observers for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // if data available then, present data
        if let savedTitle = savedTitle, let savedBodyText = savedBodyText {
            titleTextField.text = savedTitle
            bodyTextView.text = savedBodyText
            // hide placeHolder body text
            placeHolderBodyTextLabel.isHidden = true
        } else {
            // Load image picker
            self.imagePickerAction()
            // unhide placeHolder body text
            placeHolderBodyTextLabel.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // hide activity Indicator View
        activityIndicatorView.hidesWhenStopped = true
    }
    
    
    func imagePickerAction() {
        //        view.endEditing(true)
        //        moveViewDown()
        // 2
        let imagePickerAlertController = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker,
                                                             animated: true,
                                                             completion: nil)
            }
            imagePickerAlertController.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .photoLibrary
                                            self.present(imagePicker,
                                                         animated: true,
                                                         completion: nil)
        }
        imagePickerAlertController.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (alert) -> Void in
        }
        imagePickerAlertController.addAction(cancelButton)
        // 6
        imagePickerAlertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        imagePickerAlertController.popoverPresentationController?.sourceView = self.view
        imagePickerAlertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        present(imagePickerAlertController, animated: true,
                completion: nil)
    }
    
    
    // MARK : - Image Picker Controller Delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        
        // hide placeHolder body text
        placeHolderBodyTextLabel.isHidden = true
        
        // start animating activity Indicator
        activityIndicatorView.startAnimating()
        
        dismiss(animated: false, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    
    func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor:CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    
    func performImageRecognition(_ image: UIImage) {
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
        // 7
        bodyTextView.text = tesseract.recognizedText
        bodyTextView.isEditable = true
        // 8
        activityIndicatorView.stopAnimating()
    }
    
    // dismiss keyboard for text view and text field
    func dismisskeyboard(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    // Keyboard notification methods
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print ("keyboard height = \(keyboardSize.height)")
            let keyboardHeight = keyboardSize.height
            self.updateBodyTextViewHeight(keyboardHeight: keyboardHeight)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.bodyTextviewToSaveButtonTConstraint.constant != 10{
            self.bodyTextviewToSaveButtonTConstraint.constant = 10.0
        }
    }
    
    func updateBodyTextViewHeight(keyboardHeight: CGFloat) {
        if UIDevice.current.orientation.isPortrait {
            self.bodyTextviewToSaveButtonTConstraint.constant = keyboardHeight/1.35
        } else {
            self.bodyTextviewToSaveButtonTConstraint.constant = keyboardHeight/1.55
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let textFieldText = titleTextField.text, !textFieldText.isNilOrEmpty() else {
            showAlert(withTitle: "Please Enter a Title")
            return
        }
        
        guard let textViewText = bodyTextView.text, !textViewText.isNilOrEmpty() else {
            showAlert(withTitle: "Please Enter Text")
            return
        }
        
        if let _ = objectIndex {
            // data already exists in core data
            updateExistingStoredData()
        } else {
            // new data to be entered into core data
            createNewData()
        }
        self.navigationController!.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController!.dismiss(animated: true, completion: nil)
    }
    
    func createNewData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserFile",
                                       in: managedContext)!
        
        let saveFile = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        // 3
        saveFile.setValue(titleTextField.text, forKeyPath: SavedUserData.title.rawValue)
        saveFile.setValue(bodyTextView.text, forKeyPath: SavedUserData.bodyText.rawValue)
        saveFile.setValue(takeSnapshot(), forKey: SavedUserData.bodyImage.rawValue)
        
        // 4
        do {
            try managedContext.save()
            userData.append(saveFile)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateExistingStoredData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserFile")
        
        do {
            userData = try managedContext.fetch(fetchRequest)
            if let index = objectIndex, userData.count > index {
                print ("updateExistingStoredData success")
                
                let storedFile = userData[index]
                
                storedFile.setValue(titleTextField.text, forKeyPath: SavedUserData.title.rawValue)
                storedFile.setValue(bodyTextView.text, forKeyPath: SavedUserData.bodyText.rawValue)
                storedFile.setValue(takeSnapshot(), forKey: SavedUserData.bodyImage.rawValue)
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let textViewText = bodyTextView.text, !textViewText.isNilOrEmpty() else {
            showAlert(withTitle: "Please Enter Text")
            return
        }
        if segue.identifier == "playText" {
            guard let vc = segue.destination as? TextScrollerViewController else { return }
            vc.textViewString = bodyTextView.text
        }
    }
    
    func takeSnapshot() -> Data {
        UIGraphicsBeginImageContext(self.bodyTextView.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageData = UIImagePNGRepresentation(image!)
        return imageData!
    }
    
    func showAlert (withTitle: String) {
        let alert = UIAlertController(title: withTitle, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

extension ImageRecognizerViewController: UITextViewDelegate {
    // MARK :- UITextViewDelegate methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print ("textViewShouldBeginEditing")
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print ("textViewDidChangeSelection")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print ("textViewDidChange")
        if textView.text.count > 0 {
            // hide placeHolder body text
            placeHolderBodyTextLabel.isHidden = true
        } else {
            // hide placeHolder body text
            placeHolderBodyTextLabel.isHidden = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print ("textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print ("textViewDidEndEditing")
    }
}

extension String {
    func isNilOrEmpty() -> Bool {
        var tempBool = true
        if self.count > 0 {
            tempBool = false
        }
        return tempBool
    }
}
