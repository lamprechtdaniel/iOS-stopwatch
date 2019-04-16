//
//  ViewController.swift
//  Stopwatch
//
//  Created by Daniel Lamprecht on 16.04.19.
//  Copyright © 2019 Daniel Lamprecht. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var stopwatchButtons: [RoundedButton]!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var startButton: RoundedButton!
    @IBOutlet weak var stopButton: RoundedButton!
    @IBOutlet weak var modeLabel: UILabel!
    
    var seconds = 0
    var timer = Timer()
    var running = false
    
    var roundTimes = [String]()
    
    var darkmode = true
    var darkBackgroundColor: UIColor?
    var darkButtonColor: UIColor?
    
    let formatter = DateComponentsFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        updateTimeLabel()
        tableView.dataSource = self
        darkBackgroundColor = self.mainView.backgroundColor!
        darkButtonColor = self.startButton.backgroundColor!
        
        stopwatchButtons = stopwatchButtons.sorted { $0.tag < $1.tag }
    }
    
    func updateTimeLabel() {
        if let formattedString = formatter.string(from: TimeInterval(seconds)) {
            timeLabel.text = formattedString
        }
    }
    
    @objc func countUp() {
        seconds += 1
        updateTimeLabel()
    }
    
    func startTimer() {
        if running { return }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUp), userInfo: nil, repeats: true)
        running = true
    }
    
    func stopTimer() {
        timer.invalidate()
        running = false
    }
    
    func resetTimer() {
        stopTimer()
        seconds = 0
        updateTimeLabel()
        roundTimes.removeAll()
        tableView.reloadData()
        set(title: "Start", buttonIndex: 0)
        set(title: "Stop", buttonIndex: 1)
    }
    
    func set(title: String, buttonIndex: Int) {
        stopwatchButtons[buttonIndex].setTitle(title, for: .normal)
    }
    
    @IBAction func buttonHandler(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            switch title {
            case "Start":
                startTimer()
                set(title: "Round", buttonIndex: 0)
                set(title: "Stop", buttonIndex: 1)
            case "Stop":
                stopTimer()
                set(title: "Start", buttonIndex: 0)
                set(title: "Reset", buttonIndex: 1)
            case "Reset":
                resetTimer()
            case "Round":
                if let time = timeLabel.text {
                    roundTimes.append(time)
                    tableView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    @IBAction func switchHandler(_ sender: UISwitch) {
        if darkmode {
            self.mainView.backgroundColor = .white
            self.startButton.backgroundColor = .lightGray
            self.stopButton.backgroundColor = .lightGray
            self.timeLabel.textColor = .black
            self.modeLabel.textColor = .black
            self.tableView.backgroundColor = .white
            darkmode = false
        }
        else if !darkmode {
            if let backgroundColor = darkBackgroundColor {
                if let buttonColor = darkButtonColor {
                    self.mainView.backgroundColor = backgroundColor
                    self.startButton.backgroundColor = buttonColor
                    self.stopButton.backgroundColor = buttonColor
                    self.timeLabel.textColor = .white
                    self.modeLabel.textColor = .white
                    self.tableView.backgroundColor = backgroundColor
                    darkmode = true
                }
            }
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoundTableViewCell", for: indexPath)
        cell.textLabel?.text = roundTimes[indexPath.row]
        return cell
    }


}

