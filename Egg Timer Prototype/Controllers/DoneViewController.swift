//
//  DoneViewController.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 16/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol DoneDelegate {
    func reset()
}

class DoneViewController: UIViewController, GADInterstitialDelegate {
    
    var eggDoneDelegate: DoneDelegate!
    
    //ad
    var interstitial: GADInterstitial!
    
    //views
    lazy var topViewProgramatic: UIView = {
        let view = UIView()
        view.backgroundColor = Colours.orange
        return view
    }()
    
    lazy var doneImageProgramatic: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "DONE")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.addTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var pulseView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interstitial = createAndLoadInterstitial()
        
        setup()
        addViews()
        addConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        doneButton.layer.cornerRadius = 0.5 * doneButton.bounds.size.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat], animations: {
            self.topViewProgramatic.backgroundColor = Colours.orange
            self.topViewProgramatic.backgroundColor = Colours.blue
        }, completion: nil)
        
        doneImageProgramatic.rotate()
        
        pulseView.pulse()
        
    }
    
    private func addViews() {
        [topViewProgramatic, doneImageProgramatic, pulseView, doneButton].forEach{ view.addSubview($0) }
    }
    
    private func setup() {
       
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        //Initalise ad
        //test ID ca-app-pub-3940256099942544/4411468910
        //real ID ca-app-pub-8405525059632460/4938433233
        
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        //delegate for closing screen
        interstitial.delegate = self
        
        //request and load
        interstitial.load(GADRequest())
        return interstitial
    }

    //delegate method. Other lifecycles are available
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        //dismiss(animated: true, completion: nil)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        dismiss(animated: true, completion: nil)
    }

    
    @objc func doneTapped(_ sender: UIButton) {
        print("DONE DELETGATE TAPPED")
        eggDoneDelegate.reset()
        
        //check to see if ad ready - if so display
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            dismiss(animated: true, completion: nil)
        }
    }
    
    func addConstraints() {
        topViewProgramatic.translatesAutoresizingMaskIntoConstraints = false
        topViewProgramatic.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topViewProgramatic.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topViewProgramatic.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topViewProgramatic.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        doneImageProgramatic.translatesAutoresizingMaskIntoConstraints = false
        doneImageProgramatic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneImageProgramatic.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        doneImageProgramatic.widthAnchor.constraint(equalToConstant: 200).isActive = true
        doneImageProgramatic.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor, multiplier: 1.0).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        pulseView.translatesAutoresizingMaskIntoConstraints = false
        pulseView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pulseView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        pulseView.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor).isActive = true
        pulseView.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor).isActive = true
        
    }
    
}
