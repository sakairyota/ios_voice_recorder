//
//  ViewController.swift
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var isRecording: Bool = false
    private var isPlaying: Bool = false
    private var hasRecorded: Bool = false

    @IBOutlet weak var statusLabelView: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStatusText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTouchDownRecord(sender: UIButton) {
        isRecording = true

        updateStatusText()
    }

    @IBAction func onTouchUpRecord(sender: UIButton) {
        isRecording = false
        hasRecorded = true

        updateStatusText()
    }

    @IBAction func onTouchDownPlay(sender: UIButton) {
        isPlaying = true

        updateStatusText()
    }

    @IBAction func onTouchUpPlay(sender: UIButton) {
        isPlaying = false

        updateStatusText()
    }

    private func updateStatusText() {
        let statusText: String
        if isRecording {
            if isPlaying {
                statusText = "録音＆再生中"
            } else {
                statusText = "録音中"
            }
        } else {
            if isPlaying {
                statusText = "再生中"
            } else if hasRecorded {
                statusText = "..."
            } else {
                statusText = "録音してください"
            }
        }
        statusLabelView.text = statusText
    }
}

