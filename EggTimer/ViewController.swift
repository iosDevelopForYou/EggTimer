//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var eggTimes = ["Soft" : 3, "Medium" : 4, "Hard" : 7]
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer?
    
    private var topViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How do you like your eggs?"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var softEggButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "soft_egg"), for: .normal)
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        button.setTitle("Soft", for: .normal)
        return button
    }()
    
    private lazy var mediumEggButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "medium_egg"), for: .normal)
        button.setTitle("Medium", for: .normal)
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var hardEggButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "hard_egg"), for: .normal)
        button.setTitle("Hard", for: .normal)
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        return button
    }()
    
    private var progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.trackTintColor = UIColor.gray
        bar.tintColor = UIColor.blue
        bar.progress = 1
        return bar
    }()
    
    @objc func hardnessSelected(sender: UIButton) {
        
        topViewLabel.text = "How do you like your eggs?"
        timer.invalidate()
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        
        secondsPassed = 0
        progressBar.progress = 0
        topViewLabel.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
            
        } else {
            timer.invalidate()
            topViewLabel.text = "DONE"
            playSound(accord: "alarm_sound", extention: "mp3")
        }
    }
    
    func playSound(accord: String, extention: String) {
        guard let url = Bundle.main.url(forResource: accord, withExtension: extention) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addviewLayout() {
        view.addSubview(topViewLabel)
        view.addSubview(softEggButton)
        view.addSubview(mediumEggButton)
        view.addSubview(hardEggButton)
        view.addSubview(progressBar)
        
        let eggsWidth = CGFloat(111.5)
        let eggsHeith = CGFloat(150)
        
        NSLayoutConstraint.activate([
            topViewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            topViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            topViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            softEggButton.heightAnchor.constraint(equalToConstant: eggsHeith),
            softEggButton.widthAnchor.constraint(equalToConstant: eggsWidth),
            softEggButton.topAnchor.constraint(equalTo: mediumEggButton.topAnchor),
            softEggButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            mediumEggButton.heightAnchor.constraint(equalToConstant: eggsHeith),
            mediumEggButton.widthAnchor.constraint(equalToConstant: eggsWidth),
            mediumEggButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mediumEggButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            hardEggButton.heightAnchor.constraint(equalToConstant: eggsHeith),
            hardEggButton.widthAnchor.constraint(equalToConstant: eggsWidth),
            hardEggButton.topAnchor.constraint(equalTo: mediumEggButton.topAnchor),
            hardEggButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            progressBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressBar.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.9490196078, blue: 0.9882352941, alpha: 1)
        addviewLayout()
    }
    
}
