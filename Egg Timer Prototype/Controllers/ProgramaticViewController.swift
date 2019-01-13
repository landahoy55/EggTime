//
//  ProgramaticViewController.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 17/08/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

class ProgramaticViewController: UIViewController {

    //Mark:- Timer Section
    lazy var timerView: UILabel = {
        let label = UILabel()
        label.text = "5:00"
        label.font = UIFont.systemFont(ofSize: 90)
        label.textColor = #colorLiteral(red: 0.07450980392, green: 0.7529411765, blue: 0.7450980392, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reset-1"), for: .normal)
        button.addTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    //Start button
    //Had to put corner rounding code in view did layout sub views
    lazy var startButton: UIButton = {
       let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = .black
       return button
    }()
    
    //pulse
    lazy var pulseView: UIView = {
       let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    //Dial
    
    //scrollView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addViews()
        constraints()
    }
    
    override func viewDidLayoutSubviews() {
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
    }

    override func viewDidAppear(_ animated: Bool) {
        pulseView.pulse()
    }
    
    func setUp() {
        view.backgroundColor = .white
    }
    
    func addViews() {
        
        [timerView, resetButton, pulseView, startButton].forEach { view.addSubview($0) }
    }
    
    func constraints() {
        
        timerView.translatesAutoresizingMaskIntoConstraints = false
        timerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
        timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: timerView.trailingAnchor).isActive = true
        resetButton.lastBaselineAnchor.constraint(equalTo: timerView.bottomAnchor, constant: -20).isActive = true
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: 1.0).isActive = true
        startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        pulseView.translatesAutoresizingMaskIntoConstraints = false
        pulseView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pulseView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        pulseView.centerXAnchor.constraint(equalTo: startButton.centerXAnchor).isActive = true
        pulseView.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
        
    }
    
    @objc func resetTapped(_ sender: UIButton) {
        print("We tapped a buton!")
    }
    
}

extension UIView {
    

    //padding and size can be ignored.
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        //a must!
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
                topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
                leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
                 bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
       
        if let trailing = trailing {
                trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            widthAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
}
