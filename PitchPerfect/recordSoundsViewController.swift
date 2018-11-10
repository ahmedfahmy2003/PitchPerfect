//
//  recordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ahmed Fahmy on 04/11/2018.
//  Copyright © 2018 Mohtaref. All rights reserved.
//

import UIKit
import AVFoundation
class recordSoundsViewController : UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var RecordinLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    //MARK: Configuring UI Playing and not playing states
    func configureUI(isRecording:Bool){
        if isRecording{
            RecordinLabel.text = "Recording in progress..."
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        }else{
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled=false
            RecordinLabel.text = "Tap to record"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(isRecording: false)
    }


    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode:AVAudioSession.Mode.default,options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
   
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording was not successful")
            // to be replaced by alert to show message in the app
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recorderAudioURL = recordedAudioURL
        }
    }
    
}

