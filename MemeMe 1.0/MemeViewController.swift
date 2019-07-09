//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Bahi El Feky on 3/8/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate {
    
    let memeTextAttributes : [NSAttributedString.Key : Any] = [
        .strokeWidth: -4.0,
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    var isUsingBottomDefaultText:Bool = true
    var isUsingTopDefaultText:Bool = true
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBAction func CancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func shareButton(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, success, items, error in
            self.save()
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickImagePickerWith(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImagePickerWith(sourceType: .camera)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        configureTextfield(textfield: topTextField, defaultText: "TOP")
        configureTextfield(textfield: bottomTextField, defaultText: "BOTTOM")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideToolbar(false)
        shareButton.isEnabled = false
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
}
extension MemeViewController {
    
    func save(){
        let meme = MemedImage(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        self.dismiss(animated: true, completion: nil)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        print(meme)
    }
    func hideToolbar(_ hide: Bool){
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    func pickImagePickerWith(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    func configureTextfield(textfield: UITextField , defaultText: String){
        textfield.delegate = self
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        textfield.text = defaultText
    }
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        hideToolbar(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        
        view.frame.origin.y = 0
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}

extension MemeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if bottomTextField == bottomTextField && isUsingBottomDefaultText {
            bottomTextField.text = ""
            isUsingBottomDefaultText = false
        }

        if topTextField == topTextField && isUsingTopDefaultText {
            topTextField.text = ""
            isUsingTopDefaultText = false
        }    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension MemeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imagePickerView.image = selectedImage
        }
        dismiss(animated: true) {
            self.shareButton.isEnabled = true
        }
    }
}
