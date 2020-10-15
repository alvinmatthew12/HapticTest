//
//  SensingViewController.swift
//  Haptic
//
//  Created by Alvin Matthew Pratama on 15/10/20.
//

import UIKit

class SensingViewController: UIViewController {
    
    let touchPoint = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
    
    var hapticTimer = Timer()
    
    var isMove = false
    
    var area = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch! = touches.first! as UITouch
        
        let location = touch.location(in: self.view)
        
        touchPoint.center = location
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch! = touches.first! as UITouch
        
        let location = touch.location(in: self.view)
        
        touchPoint.center = location
        
        isMove = true
        
        detectLocation(location: location)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        touchPoint.layer.cornerRadius = touchPoint.frame.width / 2
        touchPoint.backgroundColor = UIColor.systemTeal
        
        touchPoint.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        
        view.addSubview(touchPoint)
    }
    
    func detectLocation(location: CGPoint) {
        if location.x < view.frame.size.width / 2 && location.y < view.frame.size.height / 2 {
//            print("top left")
            if area != 1 {
                area = 1
                hapticTimer.invalidate()
                sensing()
            }
        } else if location.x > view.frame.size.width / 2 && location.y < view.frame.size.height / 2 {
//            print("top right")
            if area != 2 {
                area = 2
                hapticTimer.invalidate()
                sensing()
            }
        } else if location.x < view.frame.size.width / 2 && location.y > view.frame.size.height / 2 {
//            print("botom left")
            if area != 3 {
                area = 3
                hapticTimer.invalidate()
                sensing()
            }
        } else if location.x > view.frame.size.width / 2 && location.y > view.frame.size.height / 2 {
//            print("botom right")
            if area != 4 {
                area = 4
                hapticTimer.invalidate()
                sensing()
            }
        }
    }
    
    func sensing() {
        print(area)
        if area == 1 {
            haptic(style: 3, timeInterval: 0.1)
            changeBackgroundColor(color: UIColor.red)
        } else if area == 2 {
            haptic(style: 3, timeInterval: 0.5)
            changeBackgroundColor(color: UIColor.orange)
        } else if area == 3 {
            haptic(style: 1, timeInterval: 0.8)
            changeBackgroundColor(color: UIColor.yellow)
        } else if area == 4 {
            haptic(style: 1, timeInterval: 1)
            changeBackgroundColor(color: UIColor.green)
        }
    }
    
    func changeBackgroundColor(color: UIColor) {
        UIView.animate(
            withDuration: 0.5, delay: 0,
            options: .transitionCrossDissolve, animations: {
                self.view.backgroundColor = color
            }, completion: nil)
    }
    
    func haptic(style: Int, timeInterval: TimeInterval) {
        hapticTimer.invalidate()
        
        var impactFeedbackGenerator: UIImpactFeedbackGenerator
        
        switch style {
        case 1:
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        case 2:
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        case 3:
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        default:
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        }
        
        hapticTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (timer) in
            impactFeedbackGenerator.prepare()
            impactFeedbackGenerator.impactOccurred()
        }
    }
}
