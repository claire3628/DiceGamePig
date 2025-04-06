//
//  GameViewController.swift
//  DiceGamePig
//
//  Created by Claire Chang on 2025/4/6.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var diceImageView: UIImageView!
    
    @IBOutlet weak var L_ProgressBar: UIProgressView!
    @IBOutlet weak var R_ProgressBar: UIProgressView!
    @IBOutlet weak var L_ProgressLabel: UILabel!
    @IBOutlet weak var R_ProgressLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var L_RollButton: UIButton!
    @IBOutlet weak var R_RollButton: UIButton!
    @IBOutlet weak var L_HoldButton: UIButton!
    @IBOutlet weak var R_HoldButton: UIButton!
    
    @IBOutlet weak var L_TalkLabel: UILabel!
    @IBOutlet weak var R_TalkLabel: UILabel!
    
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    var diceCurr:Int = 0
    var sumCurr:Int = 0
    var gradeL:Int = 0
    var gradeR:Int = 0
    
    var sumString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.frame = view.bounds

        L_ProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        R_ProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        L_ProgressLabel.font = UIFont.boldSystemFont(ofSize: 25)
        R_ProgressLabel.font = UIFont.boldSystemFont(ofSize: 25)
        L_TalkLabel.font = UIFont.boldSystemFont(ofSize: 25)
        R_TalkLabel.font = UIFont.boldSystemFont(ofSize: 25)
        runLabel.font = UIFont.boldSystemFont(ofSize: 25)
        sumLabel.font = UIFont.boldSystemFont(ofSize: 25)
        L_RollButton.isEnabled = false
        R_RollButton.isEnabled = false
        L_HoldButton.isEnabled = false
        R_HoldButton.isEnabled = false
        
        resetButton.setTitle("開始遊戲", for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        
        gradeL = 50
        gradeR = 50
        L_ProgressLabel.text = "\(gradeL)"
        R_ProgressLabel.text = "\(gradeR)"
        
        L_TalkLabel.text = "來PK啊"
        R_TalkLabel.text = "好啊！誰怕誰！"
        
        diceCurr = 3
        sumCurr = 4
        sumCurr += diceCurr
        diceImageView.image = UIImage(systemName: "die.face.\(diceCurr)")
        runLabel.text = ""
        sumLabel.text = ""
    }
    
    @IBAction func newGame(_ sender: Any) {
        
        diceCurr = 0
        sumCurr = 0
        sumString = ""
        runLabel.text = ""
        sumLabel.text = ""
        
        gradeL = 0
        L_ProgressBar.progress = Float(gradeL)
        L_ProgressLabel.text = "\(gradeL)"
        gradeR = 0
        R_ProgressBar.progress = Float(gradeR)
        R_ProgressLabel.text = "\(gradeR)"
        
        R_RollButton.isEnabled = false
        R_HoldButton.isEnabled = false
        L_RollButton.isEnabled = true
        L_HoldButton.isEnabled = true
        L_TalkLabel.text = "我先來！"
        R_TalkLabel.text = "讓你先！"
        
        resetButton.setTitle("重新開始", for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    @IBAction func roll(_ sender: UIButton) {
        
        diceCurr = Int.random(in: 1...13) % 7
        //diceCurr = Int.random(in: 2...6)
        diceImageView.addSymbolEffect(.rotate, options: .speed(2.0), completion: {_ in
            
            self.diceImageView.image = UIImage(systemName: "die.face.\(self.diceCurr)")
            if self.diceCurr == 1 {
                
                self.diceCurr = 0
                self.sumCurr = 0
                
                self.runLabel.text = "x \(self.diceCurr)"
                
                if self.sumString.isEmpty {
                    self.sumString = "\(self.diceCurr)"
                }
                self.sumLabel.text = "(\(self.sumString)) x 0 =  0"
                
                if self.L_RollButton.isEnabled == true {
                    self.L_RollButton.isEnabled = false
                    self.L_TalkLabel.text = "骰到１點,分數消失"
                } else {
                    self.R_RollButton.isEnabled = false
                    self.R_TalkLabel.text = "骰到１點,分數消失"
                }
                
            } else {
                self.sumCurr += self.diceCurr
                self.diceImageView.image = UIImage(systemName: "die.face.\(self.diceCurr)")
                
                self.runLabel.text = "+ \(self.diceCurr)"
                if self.sumString.isEmpty {
                    self.sumString = "\(self.diceCurr)"
                } else if self.sumString.count < 7 {
                    self.sumString += "+\(self.diceCurr)"
                } else {
                    self.sumString = "...\(self.sumString.suffix(4))+\(self.diceCurr)"
                }
                self.sumLabel.text = "(\(self.sumString)) = \(self.sumCurr)"
                
                if self.L_RollButton.isEnabled == true {
                    self.L_TalkLabel.text = "耶～ 加\(self.diceCurr)分"
                } else {
                    self.R_TalkLabel.text = "耶～ 加\(self.diceCurr)分"
                }
            }
        })
    }
    
    @IBAction func hold(_ sender: UIButton) {
        
        if sender.restorationIdentifier == "L" {
            gradeL += sumCurr
            L_ProgressBar.progress = Float(gradeL)/100.0
            L_ProgressLabel.text = "\(gradeL)"
            
            if gradeL >= 100 {
                L_TalkLabel.text = "哇哈哈！我贏了！"
                R_TalkLabel.text = "算你厲害！"
            } else {
                L_TalkLabel.text = "．．．"
                R_TalkLabel.text = "換我囉！"
                
                L_RollButton.isEnabled = false
                L_HoldButton.isEnabled = false
                R_RollButton.isEnabled = true
                R_HoldButton.isEnabled = true
            }
            
        } else {
            gradeR += sumCurr
            R_ProgressBar.progress = Float(gradeR)/100.0
            R_ProgressLabel.text = "\(gradeR)"
            
            if gradeR >= 100 {
                R_TalkLabel.text = "哇哈哈！我贏了！"
                L_TalkLabel.text = "算你厲害！"
            } else {
                R_TalkLabel.text = "．．．"
                L_TalkLabel.text = "換我囉！"
                
                R_RollButton.isEnabled = false
                R_HoldButton.isEnabled = false
                L_RollButton.isEnabled = true
                L_HoldButton.isEnabled = true
            }
        }
        
        
        if gradeL >= 100 || gradeR >= 100 {
            
            L_RollButton.isEnabled = false
            L_HoldButton.isEnabled = false
            R_RollButton.isEnabled = false
            R_HoldButton.isEnabled = false
        }
        
        diceCurr = 0
        sumCurr = 0
        sumString = ""
        runLabel.text = ""
        sumLabel.text = ""
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "GameViewController")
}
