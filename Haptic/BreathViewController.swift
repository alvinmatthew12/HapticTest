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
    
    var breathCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch! = touches.first! as UITouch
        
        let location = touch.location(in: self.view)
        
        touchPoint.center = location
        
        breathSession()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch! = touches.first! as UITouch
        
        let location = touch.location(in: self.view)
        
        touchPoint.center = location
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pulseTimer.invalidate()
        hapticTimer.invalidate()
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
        
        if breathCount < 4 {
            breathFourSevenEight()
        }
        
    }
    
    func breathFourSevenEight() {
        
        haptic(style: 3, timeInterval: 1)
        
        pulseAnimation(object: circle)
        
        self.instructionLabel.text = "Inhale"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            self.instructionLabel.text = "Hold"
            
            self.hapticTimer.invalidate()
            
            self.pulseTimer.invalidate()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                
                self.instructionLabel.text = "Exhale"
                
                self.haptic(style: 1, timeInterval: 0.1)
                
                self.pulseAnimation(object: self.circle, timeInterval: 0.5)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    
                    self.hapticTimer.invalidate()
                    self.pulseTimer.invalidate()
                    
                    self.breathCount += 1
                    self.breathSession()
                    
                    
                }
            }
        }
    }
    
    func pulseAnimation(object: UIView, timeInterval: TimeInterval = 1) {
        
        pulseTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            object.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(
                withDuration: 1, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                options: .curveEaseOut, animations: {
                    object.transform = .identity
            }, completion: nil)
        })
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
