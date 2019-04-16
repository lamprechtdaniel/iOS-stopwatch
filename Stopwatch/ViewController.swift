//
//  ViewController.swift
//  Stopwatch
//
//  Created by Daniel Lamprecht on 16.04.19.
//  Copyright © 2019 Daniel Lamprecht. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var stopwatchButtons: [RoundedButton]!
    
    var seconds = 0
    var running = false
    var timer = Timer()
    
    var roundTimes = [String]()
    
    let formatter = DateComponentsFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        updateTimeLabel()
        tableView.dataSource = self
        
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

