//
//  BreathViewController.swift
//  Haptic
//
//  Created by Alvin Matthew Pratama on 15/10/20.
//

import UIKit

class BreathViewController: UIViewController {
    
    @IBOutlet weak var instructionLabel: UILabel!
    let touchPoint = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0))
    let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
    
    var pulseTimer = Timer()
    var hapticTimer = Timer()
    var inhaleTimer = Timer()
    var holdTimer = Timer()
    var exhaleTimer = Timer()
    
    var breathCount = 0
    var isBreathStart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch! = touches.first! as UITouch
        
        let location = touch.location(in: self.view)
        
        touchPoint.center = location
        
        isBreathStart = true
        
        breathSession()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch! = touches.first! as UITouch
        
        let location = touch.location(in: self.view)
        
        touchPoint.center = location
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stop()
    }
    
    func setup() {
        circle.layer.cornerRadius = circle.frame.width / 2
        circle.center = touchPoint.center
        circle.backgroundColor = UIColor.systemTeal
        
        touchPoint.addSubview(circle)
        
        touchPoint.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        
        view.addSubview(touchPoint)
    }
    
    func breathSession() {
        
        if isBreathStart {
            if breathCount < 4 {
                breathFourSevenEight()
            } else {
                self.instructionLabel.text = "Well Done"
                breathCount = 0
                return
            }
        } else {
            breathCount = 0
            return
        }
        
        
    }
    
    func breathFourSevenEight() {
        
        haptic(style: 3, timeInterval: 1)
        
        pulseGrowAnimation(object: circle)
        
        self.instructionLabel.text = "Inhale"
        
        inhaleTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
            
            self.instructionLabel.text = "Hold"
            
            self.hapticTimer.invalidate()
            
            self.pulseTimer.invalidate()
            
            self.holdTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { (timer) in
                
                self.instructionLabel.text = "Exhale"
                
                self.shrinkHaptic()
                self.shrinkAnimation(object: self.circle, duration: 8)
                
                self.exhaleTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { (timer) in
                    
                    self.hapticTimer.invalidate()
                    self.pulseTimer.invalidate()
                    
                    self.breathCount += 1
                    
                    self.instructionLabel.text = ""
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.breathSession()
                    }
                    
                }
            }
        }
    }
    
    func stop() {
        pulseTimer.invalidate()
        hapticTimer.invalidate()
        inhaleTimer.invalidate()
        holdTimer.invalidate()
        exhaleTimer.invalidate()
        isBreathStart = false
        instructionLabel.text = "Stopped"
    }
    
    func pulseGrowAnimation(object: UIView, timeInterval: TimeInterval = 1) {
        
        var scaleXValue: CGFloat = 1.0
        var yValue: CGFloat = 1.0
        
        pulseTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            
            object.transform = CGAffineTransform(scaleX: scaleXValue + 0.9, y: yValue + 0.9)
            
            scaleXValue += 0.5
            yValue += 0.5
            
            UIView.animate(
                withDuration: 1, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                options: .curveEaseOut, animations: {
                    object.transform = CGAffineTransform(scaleX: scaleXValue, y: yValue)
                }, completion: nil)
            
        })
        
    }
    
    func shrinkAnimation(object: UIView, duration: TimeInterval) {
        UIView.animate(
            withDuration: duration, delay: 0,
            options: .curveEaseOut, animations: {
                object.transform = .identity
            }, completion: nil)
        
    }
    
    func shrinkHaptic() {
        self.haptic(style: 3, timeInterval: 0.03)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.hapticTimer.invalidate()
            self.haptic(style: 2, timeInterval: 0.03)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.hapticTimer.invalidate()
                self.haptic(style: 1, timeInterval: 0.03)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.hapticTimer.invalidate()
                }
            }
        }
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
