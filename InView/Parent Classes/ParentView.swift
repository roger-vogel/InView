//
//  ParentView.swift
//  Flirté
//
//  Created by Roger Vogel on 5/8/22.
//

import UIKit

class ParentView: UIView {

    // MARK: - PROPERTIES
    
    var tabBarIsHidden: Bool?
    var parentController: ParentViewController?
    var theMenuButton: UIButton?
    var theMenuView: MenuView?
    var backgroundImageView: UIImageView?
    var theScrollView: UIScrollView?
    var theContentHeightConstraint: NSLayoutConstraint?
    var theViewInfocus: UIView?
    var cameFrom: ParentView?
    var keyboardIsShowing: Bool = false
    var currentContentOffset: CGFloat = 0
    var childReturnButton: UIButton?
    var thelastTab: Int?
    var thelastView: ParentView?
    var initialContentHeight: CGFloat?
    var initIsComplete: Bool = false
 
    // MARK: - INITIALIZE
    func initView(inController: ParentViewController, backgroundImage: String? = nil, withAlpha: CGFloat? = 1.0) {
        
        // Add self as observer of keyboard show and hide notications
        NotificationCenter.default.addObserver(self, selector: #selector( self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector( self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Record the parent and set the frame
        parentController = inController
        self.frame = parentController!.view.frame
        
        initMenu()
        
        initIsComplete = true
    }
    
    // MARK: - METHODS
    func refresh() { /*Placeholder for subviews*/ }
   
    func initMenu() {
        
        if theMenuView != nil { theMenuView!.removeFromSuperview() }
         
        theMenuView = MenuView()
        theMenuView!.initMenu(self)
       
        addSubview(theMenuView!)
    }
    
    func setupView() { /* Placeholder */}

    // Fade the view in
    func showView(withFade: Bool? = true, withTabBar: Bool? = true, withSetup: Bool? = true, atCompletion: @escaping ()-> Void? = { return } ) {
        
        GlobalData.shared.activeView = self
        dismissKeyboard()
        
        if withSetup! { setupView() }
        
        self.alpha = 0.0
        self.isHidden = false
        
        parentController!.view.bringSubviewToFront(self)
        
        if withFade! { self.changeDisplayState(toState: .visible, withAlpha: 1.0, forDuration: 0.25, atCompletion: { atCompletion() })}
        else { alpha = 1.0 }
        
        if parentController!.tabBarController != nil {
            
            if withTabBar! {
                
                parentController!.tabBarController!.tabBar.isHidden = false
                tabBarIsHidden = false
                self.frame = parentController!.view.frame
                
            } else {
                
                parentController!.tabBarController!.tabBar.isHidden = true
                tabBarIsHidden = true
                
                if self.frame == parentController!.view.frame {
                    
                    self.frame.size.height += (parentController!.tabBarController!.tabBar.frame.height - 25)
                }
            }
        }
    
        parentController!.setNeedsStatusBarAppearanceUpdate()
    }
    
    // Fade the view out
    func hideView(withFade: Bool? = true, atCompletion: @escaping ()-> Void? = { return }) {
        
        if withFade! { self.changeDisplayState(toState: .hidden, withAlpha: 0.0, forDuration: 0.25, atCompletion: { atCompletion() })}
        else { alpha = 0.0 }
        
        parentController!.setNeedsStatusBarAppearanceUpdate()
    }

    // Dismiss the keyboard
    func dismissKeyboard() { endEditing(true) }
    
    func returnToTab() {
        
        guard thelastTab != nil else { return }
        
        if thelastTab! == parentController!.currentTab {
            
            self.hideView()
            if thelastView != nil { GlobalData.shared.activeView = thelastView! }
            
        } else { parentController!.gotoTab(thelastTab!) }
            
        thelastTab = nil
    }
  
    // MARK: - ACTION HANDLERS

    @objc func keyboardWillShow (notification: NSNotification) {
        
        guard !keyboardIsShowing else { return }
        guard theScrollView != nil else { return }
      
        // We want only the active view to respond to this notification
        guard GlobalData.shared.activeView != nil else { return }
        guard self == GlobalData.shared.activeView! else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // Get the keyboard height
        let keyboardHeight = keyboardSize.cgRectValue.size.height
        
        if theScrollView != nil {
            
            currentContentOffset = theScrollView!.contentOffset.y
            theContentHeightConstraint!.constant += keyboardHeight
            
            // Calulate where on the screen the focused view is: first get it's relationship to the content view
            var focusYOffset = theViewInfocus!.frame.origin.y
            
            // Adjust for content view offset pushing it "up"
            focusYOffset -= theScrollView!.contentOffset.y
            
            // Convert the focused view y position in the content view to the y position in the safe area reference frame
            focusYOffset += theScrollView!.frame.origin.y
            
            // See if it's behind the keyboard plus padding of 60 (if we're under the kb there must be more than 60 to the top of the scroller)
            let maximumAllowedYPosition = self.frame.height - keyboardHeight - 60
            
            if focusYOffset > maximumAllowedYPosition {
                
                // How far we have to move up to get out from under the keyboard
                let deltaY = (focusYOffset + 65) - maximumAllowedYPosition
                
                theScrollView!.setContentOffset(CGPoint(x: 0, y: theScrollView!.contentOffset.y + deltaY), animated: true)
            }
        }
        
        keyboardIsShowing = true
    }
     
    @objc func keyboardWillHide (notification: NSNotification) {
        
        guard theScrollView != nil else { return }
       
        // We want only the active view to respond to this notification
        guard GlobalData.shared.activeView != nil else { return }
        guard self == GlobalData.shared.activeView! else { return }
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // Get the keyboard height
        let keyboardHeight = keyboardSize.cgRectValue.size.height
        
        // Reset the view to original state
        if theContentHeightConstraint != nil { theContentHeightConstraint!.constant -= keyboardHeight }
        theScrollView!.setContentOffset(CGPoint(x: 0, y: currentContentOffset), animated: true)
        
        keyboardIsShowing = false
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
    //   touchPosition = sender.location(in: self)
    //   swipeInDidOccur(inDirection: sender.direction)
         
         if sender.direction == .right {
             
             UIView.animate(withDuration: 0.25, animations: { self.frame.origin.x = UIScreen.main.bounds.width }) { _ in
                 
                 self.alpha = 0.0
                 self.frame.origin.x = 0
             }
         }
    }
}

// MARK: - MENU VIEW DELEGATE PROTOCOL
extension ParentView: MenuViewDelegate {
    
    func menuDidShow() { theMenuButton!.isHidden = true }

    func menuDidHide() { theMenuButton!.isHidden = false }
}
