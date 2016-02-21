//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Brenda Chung on 2/17/16.
//  Copyright © 2016 Brenda Chung. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var laterIconImageView: UIImageView!
    @IBOutlet weak var archiveIconImageView: UIImageView!
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var deleteIconImageView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var Controller: UISegmentedControl!
    @IBOutlet weak var laterView: UIView!
    @IBOutlet weak var archiveView: UIView!
    
    var messageOriginalCenter: CGPoint!
    var laterIconOriginalCenter: CGPoint!
    var archiveIconOriginalCenter: CGPoint!
    var messageOffset: CGFloat!
    var messageClose: CGPoint!
    var contentOriginalCenter: CGPoint!


    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 320, height: 1202)
        laterIconImageView.alpha = 0
        archiveIconImageView.alpha = 0
        listIconImageView.alpha = 0
        deleteIconImageView.alpha = 0
        
        messageOriginalCenter = messageImageView.center
        laterIconOriginalCenter = laterIconImageView.center
        archiveIconOriginalCenter = archiveIconImageView.center
        contentOriginalCenter = contentView.center
        
        // Add a screen edge gesture recognizer with a left edge to view.
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Optional: Shake to undo.
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        self.messageView.alpha = 1
        self.messageImageView.center = CGPoint(x: self.messageOriginalCenter.x, y:self.messageOriginalCenter.y)
        self.feedImageView.transform = CGAffineTransformMakeTranslation(0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Optional: Tapping the segmented control in the title should swipe views in from the left or right.
    @IBAction func changeViews(sender: AnyObject) {
        
        if Controller.selectedSegmentIndex == 0 {
            mailView.alpha = 0
            laterView.alpha = 1
            archiveView.alpha = 0
        }
        if Controller.selectedSegmentIndex == 1 {
            mailView.alpha = 1
            laterView.alpha = 0
            archiveView.alpha = 0
        }
        if Controller.selectedSegmentIndex == 2 {
            mailView.alpha = 0
            laterView.alpha = 0
            archiveView.alpha = 1
        }
    }
    
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        // Optional: Panning from the edge should reveal the menu
        if sender.state == UIGestureRecognizerState.Changed {
            contentView.center = CGPoint(x: contentOriginalCenter.x + translation.x, y: contentOriginalCenter.y)
        }
            
        else if sender.state == UIGestureRecognizerState.Ended {

            // Optional: If the menu is being revealed when the user lifts their finger, it should continue revealing.
            if velocity.x > 0 {
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.contentView.center = CGPoint(x: self.contentOriginalCenter.x + 320, y:self.contentOriginalCenter.y)
                    }, completion: {(Bool) -> Void in
                })
            }
                
            // Optional: If the menu is being hidden when the user lifts their finger, it should continue hiding.
            else if velocity.x < 0 {
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.contentView.center = self.contentOriginalCenter
                    }, completion: {(Bool) -> Void in
                })
            }
        }
            
    }

    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {
        // User can tap to dismissing the reschedule or list options. After the reschedule or list options are dismissed, you should see the message finish the hide animation.
        rescheduleImageView.alpha = 0

        UIView.animateWithDuration(0.3, delay: 0.1, options: [], animations: { () -> Void in
            self.feedImageView.transform = CGAffineTransformMakeTranslation(0, -86)
        }, completion: nil)


    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {

        // Initially, the revealed background color should be gray.
        messageView.backgroundColor = UIColor.lightGrayColor()
            
        } // end UIGestureRecognizerState.Began
        
        else if sender.state == UIGestureRecognizerState.Changed {
            //NSLog("velocity: \(velocity.x)")

            //As the reschedule icon is revealed, it should start semi-transparent and become fully opaque.
            if translation.x < 0 && translation.x > -60 {
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.laterIconImageView.alpha = 1
                    }, completion: nil)
            }
            
            // After 60 pts, the later icon should start moving with the translation and the background should change to yellow.
            else if translation.x < -60 && translation.x > -259 {
                archiveIconImageView.alpha = 0
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.laterIconImageView.transform = CGAffineTransformMakeTranslation(translation.x + 80, 0)
                    self.laterIconImageView.alpha = 1
                    self.listIconImageView.alpha = 0
                    self.messageView.backgroundColor = UIColor.yellowColor()
                    }, completion: nil)
            }
                
            // After 260 pts, the icon should change to the list icon and the background color should change to brown.
            else if translation.x < -260 && translation.x > -320 {
                archiveIconImageView.alpha = 0
                listIconImageView.center = CGPoint(x: self.laterIconOriginalCenter.x + translation.x + 80, y: self.laterIconOriginalCenter.y)
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in                    self.laterIconImageView.alpha = 0
                    self.listIconImageView.alpha = 1
                    self.messageView.backgroundColor = UIColor.brownColor()
                    }, completion: nil)
            }
            
            // As the archive icon is revealed, it should start semi-transparent and become fully opaque.
            else if translation.x > 0 && translation.x < 60 {
                laterIconImageView.alpha = 0

                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.laterIconImageView.alpha = 1
                    }, completion: nil)
            }

            // After 60 pts, the archive icon should start moving with the translation and the background should change to green.
            else if translation.x > 60 && translation.x < 259 {
                laterIconImageView.alpha = 0
                deleteIconImageView.alpha = 0
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.archiveIconImageView.transform = CGAffineTransformMakeTranslation(translation.x - 80, 0)
                    self.messageView.backgroundColor = UIColor.greenColor()
                    self.archiveIconImageView.alpha = 1
                    }, completion: nil)

            }
            
            // After 260 pts, the icon should change to the delete icon and the background color should change to red.
            else if translation.x > 260 && translation.x < 320 {
                laterIconImageView.alpha = 0
                listIconImageView.alpha = 0
                deleteIconImageView.center = CGPoint(x: self.archiveIconOriginalCenter.x + translation.x - 80, y: self.laterIconOriginalCenter.y)
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in                    self.archiveIconImageView.alpha = 0
                    self.deleteIconImageView.alpha = 1
                    self.messageView.backgroundColor = UIColor.redColor()
                    }, completion: nil)

            }
            messageImageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
        } // end UIGestureRecognizerState.Changed
            
        else if sender.state == UIGestureRecognizerState.Ended {
            //NSLog("velocity END: \(velocity.x)")
            //NSLog("translation: \(translation.x)")
            
            // If released at this point, the message should return to its initial position.
            if translation.x < 0 && translation.x > -60 {
                deleteIconImageView.alpha = 0
                archiveIconImageView.alpha = 0
                laterIconImageView.alpha = 0
                listIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.messageImageView.center = self.messageOriginalCenter
                    }, completion: nil)
            }
                
            // Upon release, the message should continue to reveal the yellow background.
            else if translation.x < -60 && translation.x > -259 {
                deleteIconImageView.alpha = 0
                archiveIconImageView.alpha = 0
                listIconImageView.alpha = 0
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.laterIconImageView.alpha = 0
                    self.messageView.alpha = 0
                    self.messageView.backgroundColor = UIColor.yellowColor()
                    self.messageImageView.center = CGPoint(x: self.messageOriginalCenter.x - 320, y:self.messageOriginalCenter.y)
                    }, completion: {(Bool) -> Void in
                        self.laterIconImageView.alpha = 0
                        self.messageView.alpha = 0
                })
                // When the animation it complete, it should show the reschedule options.
                UIView.animateWithDuration(0.2, delay: 0.2, options: [], animations: { () -> Void in
                    self.rescheduleImageView.alpha = 1
                    }, completion: {(Bool) -> Void in
                })
            }
            
            // Upon release, the message should continue to reveal the brown background. 
            else if translation.x < -260 && translation.x > -320 {
                deleteIconImageView.alpha = 0
                archiveIconImageView.alpha = 0
                laterIconImageView.alpha = 0
                listIconImageView.center = CGPoint(x: self.laterIconOriginalCenter.x + translation.x + 80, y: self.laterIconOriginalCenter.y)
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.listIconImageView.alpha = 1
                    self.messageView.backgroundColor = UIColor.brownColor()
                    self.messageImageView.center = CGPoint(x: self.messageOriginalCenter.x - 320, y:self.messageOriginalCenter.y)
                    }, completion: {(Bool) -> Void in
                        self.laterIconImageView.alpha = 0
                        self.listIconImageView.alpha = 0
                        self.messageView.alpha = 0
                })
                // When the animation it complete, it should show the reschedule options.
                UIView.animateWithDuration(0.2, delay: 0.2, options: [], animations: { () -> Void in
                    self.rescheduleImageView.alpha = 1
                    }, completion: {(Bool) -> Void in
                })
            }
            
            // If released at this point, the message should return to its initial position.
            else if translation.x > 0 && translation.x < 60 {
                deleteIconImageView.alpha = 0
                archiveIconImageView.alpha = 0
                laterIconImageView.alpha = 0
                listIconImageView.alpha = 0

                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.messageImageView.center = self.messageOriginalCenter
                    }, completion: nil)

            }
            
            // Upon release, the message should continue to reveal the green background.
            else if translation.x > 61 && translation.x < 260 {
                laterIconImageView.alpha = 0
                listIconImageView.alpha = 0
                deleteIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.archiveIconImageView.alpha = 1
                    self.messageView.backgroundColor = UIColor.greenColor()
                }, completion: nil)
        
                // When the animation it complete, it should hide the message.
                UIView.animateWithDuration(0.2, delay: 0.2, options: [], animations: { () -> Void in
                    self.messageImageView.center = CGPoint(x: self.messageOriginalCenter.x + 320, y:self.messageOriginalCenter.y)
                    }, completion: {(Bool) -> Void in
                        self.messageView.alpha = 0
                        self.feedImageView.transform = CGAffineTransformMakeTranslation(0, -86)
                        self.archiveIconImageView.alpha = 0
                        self.deleteIconImageView.alpha = 0
                })
                
            }
            
            // Upon release, the message should continue to reveal the red background.
            else if translation.x > 260 && translation.x < 320 {
                laterIconImageView.alpha = 0
                listIconImageView.alpha = 0
                archiveIconImageView.alpha = 0
                deleteIconImageView.center = CGPoint(x: self.archiveIconOriginalCenter.x + translation.x - 80, y: self.laterIconOriginalCenter.y)
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.deleteIconImageView.alpha = 1
                    self.messageView.backgroundColor = UIColor.redColor()
                    }, completion: {(Bool) -> Void in
                })
            
                // When the animation it complete, it should hide the message.
                UIView.animateWithDuration(0.2, delay: 0.2, options: [], animations: { () -> Void in
                    self.messageImageView.center = CGPoint(x: self.messageOriginalCenter.x + 320, y:self.messageOriginalCenter.y)
                    }, completion: {(Bool) -> Void in
                        self.messageView.alpha = 0
                        self.feedImageView.transform = CGAffineTransformMakeTranslation(0, -86)
                        self.archiveIconImageView.alpha = 0
                        self.deleteIconImageView.alpha = 0
                })

            }
        } // end UIGestureRecognizerState.Ended
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
