//
//  ViewController.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 20/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        buildUI()
    }
    
    var logginButton = UIButton()
    var logginButtonFrame = CGRect.zero
    let animating = UIActivityIndicatorView(style: .white)
    let buttonTitle = UILabel()
    let spotifyImageView = UIImageView()
    
    private func buildUI(){
        self.view.addSubview(logginButton)
        self.navigationController?.navigationBar.isHidden = true
        
        logginButton.translatesAutoresizingMaskIntoConstraints = false
        logginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        logginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        logginButton.clipsToBounds = true
        logginButton.layer.cornerRadius =  25
        logginButton.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        logginButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        
        logginButton.addSubview(spotifyImageView)
        spotifyImageView.translatesAutoresizingMaskIntoConstraints = false
        spotifyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        spotifyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        spotifyImageView.centerYAnchor.constraint(equalTo: logginButton.centerYAnchor).isActive = true
        spotifyImageView.leftAnchor.constraint(equalTo: logginButton.leftAnchor, constant: 40).isActive = true
        spotifyImageView.image = UIImage(named: "Spotify_Icon_RGB_White")
        
        logginButton.addSubview(buttonTitle)
        buttonTitle.isUserInteractionEnabled = false
        buttonTitle.translatesAutoresizingMaskIntoConstraints = false
        buttonTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        buttonTitle.leftAnchor.constraint(equalTo: spotifyImageView.rightAnchor, constant: 20).isActive = true
        buttonTitle.centerYAnchor.constraint(equalTo: logginButton.centerYAnchor).isActive = true
        buttonTitle.text = "Entrar com Spotify"
        buttonTitle.textColor = .white
        
        self.view.addSubview(animating)
        animating.translatesAutoresizingMaskIntoConstraints = false
        animating.centerXAnchor.constraint(equalTo: logginButton.centerXAnchor).isActive = true
        animating.centerYAnchor.constraint(equalTo: logginButton.centerYAnchor).isActive = true
        animating.heightAnchor.constraint(equalToConstant: 100).isActive = true
        animating.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishButtonAnimation), name: .finishedSessionNotificationName, object: nil)
    }
    
    @objc func actionButton(sender: Any) {
        startButtonAnimation()

    }
    
    private func startButtonAnimation() {
        animating.startAnimating()
        buttonTitle.isHidden = true
        spotifyImageView.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.logginButton.frame = CGRect(x: self.logginButtonFrame.origin.x + (self.logginButtonFrame.width / 2) - (50 / 2) , y: self.logginButtonFrame.origin.y, width: 50, height: 50)
        }) { (finished) in
            NotificationCenter.default.post(Notification(name: .startSessionNotificationName))
        }
    }
    
    @objc private func finishButtonAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.logginButton.backgroundColor = #colorLiteral(red: 0.3853656719, green: 0.4172438343, blue: 0.4635548858, alpha: 1)
                self.animating.stopAnimating()
                self.logginButton.frame = self.view.frame
                
            }, completion: { (finished) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.logginButton.alpha = 0.0
                    
                }, completion: { (finished) in
                    let homePlayerViewController = HomePlayerViewController()
                    self.navigationController?.pushViewController(homePlayerViewController, animated: false)
                })
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logginButtonFrame = logginButton.frame
    }
}

