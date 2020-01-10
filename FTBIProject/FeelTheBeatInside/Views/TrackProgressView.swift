//
//  TrackProgressView.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 25/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

enum ProgressState {
    case stoped, paused, animating, resume
}

class TrackProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    private var animator: UIViewPropertyAnimator?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private var progressViewWidthAnchor: NSLayoutConstraint?
    
    private lazy var progressView: UIView = {
        let p = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 3))
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        p.isHidden = true
        return p
    }()

    private lazy var progressViewContent: UIView = {
        let p = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 3))
        p.backgroundColor = #colorLiteral(red: 0.3227999919, green: 0.3495026053, blue: 0.3882948697, alpha: 1)
        p.translatesAutoresizingMaskIntoConstraints = false
        p.isHidden = true
        return p
    }()
    
    private func buildUI() {
        self.addSubview(progressViewContent)
        self.addSubview(progressView)
        self.clipsToBounds = true
    }
    
    private func prepareAnimation(track: TrackViewModel){
        self.setNeedsLayout()
        
        guard let time = track.msTime else { return }

        progressViewContent.isHidden = false
        progressView.isHidden = false
        progressView.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        self.animator = UIViewPropertyAnimator(duration: TimeInterval(time / 1000), curve: .easeInOut) {
            self.progressView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 3)
            self.layoutIfNeeded()
        }
    }
    
    private func updateUI() {
        
    }
    
    func changeState(state: ProgressState){
        switch state {
        case .animating:
            animator?.startAnimation()
        case .paused:
            animator?.pauseAnimation()
        case .resume:
            animator?.pauseAnimation()
        case .stoped:
            animator?.stopAnimation(true)
        }
    }
    
    func start(track: TrackViewModel) {
        changeState(state: .stoped)
        prepareAnimation(track: track)
        animator?.startAnimation()
    }
}
