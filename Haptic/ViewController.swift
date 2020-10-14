//
//  ViewController.swift
//  Haptic
//
//  Created by Alvin Matthew Pratama on 14/10/20.
//

import UIKit
import AudioToolbox.AudioServices

class ViewController: UIViewController {
        
    var timer = Timer()
    var isNormalHaptic: Bool = false
    var isFastHaptic: Bool = false

    @IBOutlet weak var redRectangle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        haptic(style: 3)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch! = touches.first! as UITouch
        
        let location = touch.location(in: self.view)
        
        detectTouch(location: location)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer.invalidate()
        isNormalHaptic = false
    }
    
    func detectTouch(location: CGPoint) {
        let redRectFrame = self.view.convert(redRectangle.frame, from: redRectangle.superview)
        
        if redRectFrame.contains(location) {
            if !isFastHaptic {
                isFastHaptic = true
                isNormalHaptic = false
                haptic(style: 3, timeInterval: 0.1)
            }
        } else {
            isFastHaptic = false
            if !isNormalHaptic {
                isNormalHaptic = true
                haptic(style: 1, timeInterval: 1)
            }
        }
    }
    
    
    func haptic(style: Int, timeInterval: TimeInterval) {
        timer.invalidate()
        
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
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (timer) in
            impactFeedbackGenerator.prepare()
            impactFeedbackGenerator.impactOccurred()
        }
    }


}

