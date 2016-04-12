//
//  ViewController.swift
//  ScrollViewOnKeyboardShow
//
//  Created by Miko on 01.04.2016.
//  Copyright © 2016 iMikolaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    weak var activeField: UITextField?
    
    var animateContenetView = true
    var originalContentOffset: CGPoint?
    var isKeyboardVisible = false
    
    let offset : CGFloat = 18
    
    
    //MARK: - IBAction
    
    @IBAction func AnimateSwitchValueChanged(sender: UISwitch) {
        animateContenetView = sender.on
    }
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for case let textField as UITextField in contentView.subviews {
            textField.delegate = self
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        originalContentOffset = scrollView.contentOffset

        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            var visibleRect = self.scrollView.bounds
            visibleRect.size.height -= keyboardSize.size.height
            
            //that's to avoid enlarging contentSize multiple times in case of many UITextFields,
            //when user changes an edited text field
            if isKeyboardVisible == false {
                scrollView.contentSize.height += keyboardSize.height
            }
            
            //scroll only if the keyboard would cover a bottom edge of an
            //active field (including the given offset)
            let activeFieldBottomY = activeField.frame.origin.y + activeField.frame.size.height + offset
            let activeFieldBottomPoint = CGPoint(x: activeField.frame.origin.x, y: activeFieldBottomY)
            if (!CGRectContainsPoint(visibleRect, activeFieldBottomPoint)) {
                var scrollToPointY = activeFieldBottomY - (self.scrollView.bounds.height - keyboardSize.size.height)
                scrollToPointY = min(scrollToPointY, scrollView.contentSize.height - scrollView.frame.size.height)
                
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollToPointY), animated: animateContenetView)
            }
        }
        
        isKeyboardVisible = true
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.contentSize.height = contentView.frame.size.height
        if var contentOffset = originalContentOffset {
            contentOffset.y = min(contentOffset.y, scrollView.contentSize.height - scrollView.frame.size.height)
            scrollView.setContentOffset(contentOffset, animated: animateContenetView)
        }
        
        isKeyboardVisible = false
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(nil) { (_) -> Void in
            self.scrollView.contentSize.height = self.contentView.frame.height
        }
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

