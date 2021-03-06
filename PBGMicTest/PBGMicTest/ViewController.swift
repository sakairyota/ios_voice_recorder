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

    private let recorder = PBGAudioRecorder()
    private let store = AudioStore()
    private let player = PBGAudioPlayer()


    @IBOutlet weak var statusLabelView: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStatusText()
        recorder.audioWriter = store
        player.audioReader = store
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTouchDownRecord(sender: UIButton) {
        //録音中はなにもしない
        if isRecording {
            return
        }

        isRecording = true

        recorder.start()

        updateStatusText()
    }

    @IBAction func onTouchUpRecord(sender: UIButton) {
        //録音していない時はなにもしない
        if !isRecording {
            return
        }

        isRecording = false
        hasRecorded = true

        recorder.stop()

        updateStatusText()
    }

    @IBAction func onTouchDownPlay(sender: UIButton) {
        //再生中は何もしない
        if isPlaying {
            return
        }
        //録音を1回もしていない時は再生しない
        if !hasRecorded {
            return
        }
        
        isPlaying = true

        store.readFromFirst()
        player.start()

        updateStatusText()
    }

    @IBAction func onTouchUpPlay(sender: UIButton) {
        //再生していない時は何もしない
        if !isPlaying {
            return
        }
        isPlaying = false

        player.stop()

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

