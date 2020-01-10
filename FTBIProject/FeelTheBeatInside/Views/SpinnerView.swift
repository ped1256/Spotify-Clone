//
//  SpinnerView.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 23/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation
public final class SpinnerView: UIView {
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 18, height: 18)
    }
    
    override public func sizeToFit() {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: intrinsicContentSize.width, height: intrinsicContentSize.height)
        layoutSpinnerLayer()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stateImageView: UIImageView = {
        let v = UIImageView()
        
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        v.transform = CGAffineTransform(scaleX: 0, y: 0)
        v.tintColor = .white
        v.layer.zPosition = 999
        
        return v
    }()
    
    private lazy var spinnerLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        
        l.frame = self.bounds
        l.lineWidth = 2.0
        l.strokeColor = UIColor.darkGray.cgColor
        l.fillColor = UIColor.clear.cgColor
        l.isOpaque = false
        l.strokeEnd = 0.7
        
        return l
    }()
    
    private func setup() {
        spinnerLayer.frame = bounds
        spinnerLayer.transform = CATransform3DMakeScale(0, 0, 1)
        layer.addSublayer(spinnerLayer)
        
        addSubview(stateImageView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        stateImageView.sizeToFit()
        layoutSpinnerLayer()
    }
    
    private func layoutSpinnerLayer() {
        spinnerLayer.frame = bounds
        spinnerLayer.path = CGPath(ellipseIn: self.bounds, transform: nil)
        
        stateImageView.frame = CGRect(x: bounds.width / 2.0 - stateImageView.bounds.width / 2.0, y: bounds.height / 2.0 - stateImageView.bounds.height / 2.0, width: stateImageView.intrinsicContentSize.width, height: stateImageView.intrinsicContentSize.height)
    }
    
    public enum State: Int {
        case idle
        case spinning
    }
    
    public var state: State = .idle {
        didSet {
            switch state {
            case .idle:
                stopAnimation()
            case .spinning:
                startAnimation()
            }
        }
    }
    
    private struct Animation {
        static let duration: TimeInterval = 0.4
        static let damping: CGFloat = 0.5
        static let velocity: CGFloat = -0.7
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: Animation.duration, delay: 0, usingSpringWithDamping: Animation.damping, initialSpringVelocity: Animation.velocity, options: [], animations: {
            self.stateImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.stateImageView.alpha = 0
        }, completion: nil)
        
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineWidth = 2.0
        
        spinnerLayer.transform = CATransform3DMakeScale(1, 1, 1)
        
        let startingRotation = spinnerLayer.value(forKeyPath: "transform.rotation") as? CGFloat ?? 0.0
        let rotation = CATransform3DRotate(spinnerLayer.transform, 360.0 * 3.14 / 180.0, 0, 0, 1)
        spinnerLayer.transform = rotation
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 0.5
        animation.repeatCount = .greatestFiniteMagnitude
        animation.fromValue = startingRotation
        animation.toValue = startingRotation + 360.0 * 3.14 / 180.0
        spinnerLayer.add(animation, forKey: "transform.rotation")
        stateImageView.alpha = 0
    }
    
    private func stopAnimation() {
        stateImageView.alpha = 0
        spinnerLayer.removeAnimation(forKey: "transform.rotation")
        
        spinnerLayer.transform = CATransform3DMakeScale(0, 0, 0)
        spinnerLayer.fillColor = UIColor.clear.cgColor
    }
}
