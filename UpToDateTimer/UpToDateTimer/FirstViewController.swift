//
//  FirstViewController.swift
//  UpToDateTimer
//
//  Created by 藤山裕輝 on 2019/06/10.
//  Copyright © 2019 藤山裕輝. All rights reserved.
//

import UIKit
import AudioToolbox

class FirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //タイマー変数を作成
    var timer: Timer?
    
    //カウントの変数を作成
    var countMinute = 0
    var countSecond = 0
    
    //設定値を扱うキーを設定
    let settingSecondKey = "second_value"
    let settingMinuteKey = "minute_value"
    
    //UIPckerViewに表示するデータをArrayで作成
    let settingSecondArray : [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                                21,22,23,24,25,26,27,28,29,30,
                                31,32,33,34,35,36,37,38,39,40,
                                41,42,43,44,45,46,47,48,49,50,
                                51,52,53,54,55,56,57,58,59]
    
    let settingMinuteArray : [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                                21,22,23,24,25,26,27,28,29,30,
                                31,32,33,34,35,36,37,38,39,40,
                                41,42,43,44,45,46,47,48,49,50,
                                51,52,53,54,55,56,57,58,59,60]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //UserDefaultsのインスタンスを生成
        let settingsSecond = UserDefaults.standard
        let settingsMinute = UserDefaults.standard
        //UserDefaultsに初期値を登録
        settingsSecond.register(defaults: [settingSecondKey:0])
        settingsMinute.register(defaults: [settingMinuteKey:0])
    }

    //UIPickerViewの列数を設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //UIPickerViewの行数を取得
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return settingMinuteArray.count
        case 1:
            return settingSecondArray.count
        default:
            return 0
        }
    }
    
    //UIPickerViewの表示する内容を設定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(settingMinuteArray[row])
        case 1:
            return String(settingSecondArray[row])
        default:
            return "error"
        }
    }
    
    //pickerView選択時に実行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            let settingsMinute = UserDefaults.standard
            settingsMinute.setValue(settingMinuteArray[row], forKey: settingMinuteKey)
            settingsMinute.synchronize()
            minuteLabel.text = String(format: "%02d", settingMinuteArray[row])
        case 1:
            let settingsSecond = UserDefaults.standard
            settingsSecond.setValue(settingSecondArray[row], forKey: settingSecondKey)
            settingsSecond.synchronize()
            secondLabel.text = String(format: "%02d", settingSecondArray[row])
        default:
            break
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが実行中だったら何もしない
            if nowTimer.isValid == true {
                //何も処理しない
                return
            }
        }
        //タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerInterrupt(_:)), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopButton(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが実行中だったら停止
            if nowTimer.isValid == true {
                //タイマー停止
                nowTimer.invalidate()
                //count = 0
                //countMinute = 0
            }
        }
    }
    
    //画面の更新をする(戻り値：remainCount:残り時間)
    func displayUpdate() -> Int {
        //UserDefaultsのインスタンスを生成
        let settingsSecond = UserDefaults.standard
        //取得した秒数をtimeValueに渡す
        let secondValue = settingsSecond.integer(forKey: settingSecondKey)
        //残り時間(remainCount)を生成
        let remainCount = secondValue - countSecond
        //remainCount（残り時間）をラベルに表示
        secondLabel.text = String(format: "%02d", remainCount)
        //残り時間を戻り値に設定
        return remainCount
    }
    //分数の処理
    func displayUpdateForMinute() -> Int {
        //UserDefaultsのインスタンスを生成
        let settingsMinute = UserDefaults.standard
        //取得した秒数をtimeValueに渡す
        let minuteValue = settingsMinute.integer(forKey: settingMinuteKey)
        //残り時間(remainCount)を生成
        let remainMinuteCount = minuteValue - countMinute
        //remainCount（残り時間）をラベルに表示
        minuteLabel.text = String(format: "%02d", remainMinuteCount)
        //残り時間を戻り値に設定
        return remainMinuteCount
    }
    
    
    //経過時間の処理
    @objc func timerInterrupt(_ timer: Timer) {
        
        //経過時間に＋1していく
        countSecond += 1
        //remainCount（残り時間）が0の時
        if displayUpdate() <= -1 {
            //初期化処理
            countSecond = 0
            //分数カウント処理
            countMinute += 1
            //分数の処理
            if  displayUpdateForMinute() <= -1 {
                //分数カウント初期化
                countMinute = 0
                secondLabel.text = "00"
                minuteLabel.text = "00"
                //音を鳴らす処理
                let soundIdRing: SystemSoundID = 1009
                AudioServicesPlaySystemSound(soundIdRing)
                //タイマー終了
                timer.invalidate()
                
                //ダイアログ作成
                let alertController = UIAlertController(title: "終了です", message: "時間になりました！", preferredStyle: .alert)
                
                //表示させるOKボタンを作成
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                //アクションを追加
                alertController.addAction(defaultAction)
                
                //ダイアログの表示
                present(alertController, animated: true, completion: nil)
                
                
            } else {
                
                let settingsSecond = UserDefaults.standard
                settingsSecond.setValue(59, forKey: settingSecondKey)
                settingsSecond.synchronize()
                secondLabel.text =  "59"
            }
        }
    }
    
    
    
}

