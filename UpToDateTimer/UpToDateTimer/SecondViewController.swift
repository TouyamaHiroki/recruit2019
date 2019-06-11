//
//  SecondViewController.swift
//  UpToDateTimer
//
//  Created by 藤山裕輝 on 2019/06/10.
//  Copyright © 2019 藤山裕輝. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    
    
    var time: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //描画更新
        time = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.timeCheck),
            userInfo: nil,
            repeats: true)
        
    }

    //現在時間などを取得してアップデートするメソッド
    @objc func timeCheck(){
        let date = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let component = calendar.components([
            .year,
            .month,
            .day,
            .weekday,
            .hour,
            .minute,
            .second
            ], from: date as Date)
        
        let weekday: Array = ["日", "月", "火", "水", "木", "金", "土"]
        
        let year = "\(component.year!)"
        let month = String(format: "%02d", component.month!)
        let day = String(format: "%02d", component.day!)
        let dayOfTheWeek = "\(weekday[component.weekday! - 1])"
        let hour = String(format: "%02d", component.hour!)
        let min = String(format: "%02d", component.minute!)
        let sec = String(format: "%02d", component.second!)
        
        yearLabel.text = "\(year)年"
        dateLabel.text = "\(month)月\(day)日(\(dayOfTheWeek))"
        timeLabel.text = "\(hour)"
        minutesLabel.text = "\(min)"
        secondsLabel.text = "\(sec)"
    }

}

