//
//  UIViewExtension.swift
//  Domino
//
//  Created by Đỗ Ngọc on 9/10/16.
//  Copyright © 2016 Đỗ Ngọc. All rights reserved.
//

import Foundation
import UIKit
public enum SimpleAnimationEdge {
    case none
    case top
    case bottom
    case left
    case right
}

extension UIView{
    var width:      CGFloat { return self.frame.size.width }
    var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}
    var bounsWidth: CGFloat { return self.bounds.width }
    var bounsHeight: CGFloat { return self.bounds.height }
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
  
    func gradientBackground(colors:[UIColor],direction:CAGradientLayer.CADirection,cornerRadius:CGFloat?=nil){
        layoutIfNeeded()
        let gradient = CAGradientLayer(frame: bounds, colors: colors, direction:direction)
        backgroundColor = UIColor(patternImage: gradient.creatGradientImage()!)
        if cornerRadius != nil{
            roundCorner(radius: cornerRadius!)
        }
    }
    
    func setWidth(width:CGFloat)
    {
        self.frame.size.width = width
    }
    
    func setHeight(height:CGFloat)
    {
        self.frame.size.height = height
    }
    
    func setSize(size:CGSize)
    {
        self.frame.size = size
    }
    
    func setOrigin(point:CGPoint)
    {
        self.frame.origin = point
    }
    
    func setX(x:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x:x,y:self.frame.origin.y)
    }
    
    func setY(y:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x:self.frame.origin.x,y:y)
    }
    
    func setCenterX(x:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x:x,y: self.center.y)
    }
    
    func setCenterY(y:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x:self.center.x,y: y)
    }
    
    func roundCorner(radius:CGFloat)
    {   self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func setTop(top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    func setLeft(left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    func setRight(right:CGFloat)
    {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(bottom:CGFloat)
    {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func roundImage()
    {
        //height and width should be the same
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
    func border(color:UIColor,width:CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    
    @discardableResult func fadeIn(duration: TimeInterval = 0.25,
                                   delay: TimeInterval = 0,
                                   completion: ((Bool) -> Void)? = nil) -> UIView {
        isHidden = false
        alpha = 0
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Fades this view out. This method can be chained with other animations to combine a fade with
     the other animation, for instance:
     ```
     view.fadeOut().slideOut(to: .right)
     ```
     - Parameters:
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    @discardableResult func fadeOut(duration: TimeInterval = 0.25,
                                    delay: TimeInterval = 0,
                                    completion: ((Bool) -> Void)? = nil) -> UIView {
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
                self.alpha = 0
        }, completion: completion)
        return self
    }
    
    /**
     Slides this view into position, from an edge of the parent (if "from" is set) or a fixed offset
     away from its position (if "x" and "y" are set).
     - Parameters:
     - from: edge of the parent view that should be used as the starting point of the animation
     - x: horizontal offset that should be used for the starting point of the animation
     - y: vertical offset that should be used for the starting point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func slideIn(from edge: SimpleAnimationEdge = .none,
                                    x: CGFloat = 0,
                                    y: CGFloat = 0,
                                    duration: TimeInterval = 0.4,
                                    delay: TimeInterval = 0,
                                    completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        isHidden = false
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Slides this view out of its position, toward an edge of the parent (if "to" is set) or a fixed
     offset away from its position (if "x" and "y" are set).
     - Parameters:
     - to: edge of the parent view that should be used as the ending point of the animation
     - x: horizontal offset that should be used for the ending point of the animation
     - y: vertical offset that should be used for the ending point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func slideOut(to edge: SimpleAnimationEdge = .none,
                                     x: CGFloat = 0,
                                     y: CGFloat = 0,
                                     duration: TimeInterval = 0.25,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        let endTransform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
                self.transform = endTransform
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view into position, with a bounce at the end, either from an edge of the parent (if
     "from" is set) or a fixed offset away from its position (if "x" and "y" are set).
     - Parameters:
     - from: edge of the parent view that should be used as the starting point of the animation
     - x: horizontal offset that should be used for the starting point of the animation
     - y: vertical offset that should be used for the starting point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func bounceIn(from edge: SimpleAnimationEdge = .none,
                                     x: CGFloat = 0,
                                     y: CGFloat = 0,
                                     duration: TimeInterval = 1,
                                     delay: TimeInterval = 0.5,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        isHidden = false
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 0.58, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view out of its position, starting with a bounce. The view moves toward an edge of
     the parent (if "to" is set) or a fixed offset away from its position (if "x" and "y" are set).
     - Parameters:
     - to: edge of the parent view that should be used as the ending point of the animation
     - x: horizontal offset that should be used for the ending point of the animation
     - y: vertical offset that should be used for the ending point of the animation
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func bounceOut(to edge: SimpleAnimationEdge = .none,
                                      x: CGFloat = 0,
                                      y: CGFloat = 0,
                                      duration: TimeInterval = 0.35,
                                      delay: TimeInterval = 0,
                                      completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        let delta = CGPoint(x: offset.x + x, y: offset.y + y)
        let endTransform = CGAffineTransform(translationX: delta.x, y: delta.y)
        let prepareTransform = CGAffineTransform(translationX: -delta.x * 0.2, y: -delta.y * 0.2)
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                    self.transform = endTransform
                }
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view into position, as though it were popping out of the screen.
     - Parameters:
     - fromScale: starting scale for the view, should be between 0 and 1
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func popIn(fromScale: CGFloat = 0.5,
                                  duration: TimeInterval = 0.5,
                                  delay: TimeInterval = 0.2,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
        isHidden = false
        alpha = 0
        transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
        }, completion: completion)
        return self
    }
    
    /**
     Moves this view out of position, as though it were withdrawing into the screen.
     - Parameters:
     - toScale: ending scale for the view, should be between 0 and 1
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func popOut(toScale: CGFloat = 0.5,
                                   duration: TimeInterval = 0.3,
                                   delay: TimeInterval = 0,
                                   completion: ((Bool) -> Void)? = nil) -> UIView {
        let endTransform = CGAffineTransform(scaleX: toScale, y: toScale)
        let prepareTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.transform = endTransform
                    self.alpha = 0
                }
        }, completion: completion)
        return self
    }
    
    /**
     Causes the view to hop, either toward a particular edge or out of the screen (if "toward" is
     .None).
     - Parameters:
     - toward: the edge to hop toward, or .None to hop out
     - amount: distance to hop, expressed as a fraction of the view's size
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func hop(toward edge: SimpleAnimationEdge = .none,
                                amount: CGFloat = 0.4,
                                duration: TimeInterval = 0.6,
                                delay: TimeInterval = 0,
                                completion: ((Bool) -> Void)? = nil) -> UIView {
        var dx: CGFloat = 0, dy: CGFloat = 0, ds: CGFloat = 0
        if edge == .none {
            ds = amount / 2
        } else if edge == .left || edge == .right {
            dx = (edge == .left ? -1 : 1) * self.bounds.size.width * amount;
            dy = 0
        } else {
            dx = 0
            dy = (edge == .top ? -1 : 1) * self.bounds.size.height * amount;
        }
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.28) {
                    let t = CGAffineTransform(translationX: dx, y: dy)
                    self.transform = t.scaledBy(x: 1 + ds, y: 1 + ds)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.28, relativeDuration: 0.28) {
                    self.transform = .identity
                }
                UIView.addKeyframe(withRelativeStartTime: 0.56, relativeDuration: 0.28) {
                    let t = CGAffineTransform(translationX: dx * 0.5, y: dy * 0.5)
                    self.transform = t.scaledBy(x: 1 + ds * 0.5, y: 1 + ds * 0.5)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.84, relativeDuration: 0.16) {
                    self.transform = .identity
                }
        }, completion: completion)
        return self
    }
    
    /**
     Causes the view to shake, either toward a particular edge or in all directions (if "toward" is
     .None).
     - Parameters:
     - toward: the edge to shake toward, or .None to shake in all directions
     - amount: distance to shake, expressed as a fraction of the view's size
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func shake(toward edge: SimpleAnimationEdge = .none,
                                  amount: CGFloat = 0.15,
                                  duration: TimeInterval = 0.6,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
        let steps = 8
        let timeStep = 1.0 / Double(steps)
        var dx: CGFloat, dy: CGFloat
        if edge == .left || edge == .right {
            dx = (edge == .left ? -1 : 1) * self.bounds.size.width * amount;
            dy = 0
        } else {
            dx = 0
            dy = (edge == .top ? -1 : 1) * self.bounds.size.height * amount;
        }
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                var start = 0.0
                for i in 0..<(steps - 1) {
                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                        self.transform = CGAffineTransform(translationX: dx, y: dy)
                    }
                    if (edge == .none && i % 2 == 0) {
                        swap(&dx, &dy)  // Change direction
                        dy *= -1
                    }
                    dx *= -0.85
                    dy *= -0.85
                    start += timeStep
                }
                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                    self.transform = .identity
                }
        }, completion: completion)
        return self
    }
    
    private func offsetFor(edge: SimpleAnimationEdge) -> CGPoint {
        if let parentSize = self.superview?.frame.size {
            switch edge {
            case .none: return CGPoint.zero
            case .top: return CGPoint(x: 0, y: -frame.maxY)
            case .bottom: return CGPoint(x: 0, y: parentSize.height - frame.minY)
            case .left: return CGPoint(x: -frame.maxX, y: 0)
            case .right: return CGPoint(x: parentSize.width - frame.minX, y: 0)
            }
        }
        return .zero
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX,y: posY,width: cgwidth,height:cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
}
extension UIView{
    
    
    // MARK: Public static methods
    
    
    // MARK: Private static methods
    
    
    // MARK: Public object methods
    
    /**
     Adds `UITapGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UITapGestureRecognizer` instance changes its state.
     - configureTapGestureRecognizer: Allows to configure UITapGestureRecognizer instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UITapGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onTap(_ block: @escaping SNTapGestureRecognizerHandlerBlock, configureTapGestureRecognizer: SNTapGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let tapGestureRecognizer = SNTapGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(tapGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureTapGestureRecognizer(tapGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UITapGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UITapGestureRecognizer` instance changes its state.
     - configureTapGestureRecognizer: Allows to configure UITapGestureRecognizer instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UITapGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onTapOnce(_ block: @escaping SNTapGestureRecognizerHandlerBlock, configureTapGestureRecognizer: SNTapGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForTapGestureRecognizer: SNTapGestureRecognizerHandlerBlock = { (tapGestureRecognizer) in
            block(tapGestureRecognizer)
            self.removeGestureRecognizer(tapGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let tapGestureRecognizer = SNTapGestureRecognizer(handlerBlock: handlerBlockForTapGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(tapGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureTapGestureRecognizer(tapGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UITapGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UITapGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onTap(_ block: @escaping SNTapGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let tapGestureRecognizer = SNTapGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(tapGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UITapGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UITapGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onTapOnce(_ block: @escaping SNTapGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForTapGestureRecognizer: SNTapGestureRecognizerHandlerBlock = { (tapGestureRecognizer) in
            block(tapGestureRecognizer)
            self.removeGestureRecognizer(tapGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let tapGestureRecognizer = SNTapGestureRecognizer(handlerBlock: handlerBlockForTapGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(tapGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UILongPressGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UILongPressGestureRecognizer` instance changes its state.
     - configureLongPressGestureRecognizer: Allows to configure `UILongPressGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UILongPressGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onLongPress(_ block: @escaping SNLongPressGestureRecognizerHandlerBlock, configureLongPressGestureRecognizer: SNLongPressGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let longPressGestureRecognizer = SNLongPressGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(longPressGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureLongPressGestureRecognizer(longPressGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UILongPressGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UILongPressGestureRecognizer` instance changes its state.
     - configureLongPressGestureRecognizer: Allows to configure `UILongPressGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UILongPressGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onLongPressOnce(_ block: @escaping SNLongPressGestureRecognizerHandlerBlock, configureLongPressGestureRecognizer: SNLongPressGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForLongPressGestureRecognizer: SNLongPressGestureRecognizerHandlerBlock = { (longPressGestureRecognizer) in
            block(longPressGestureRecognizer)
            self.removeGestureRecognizer(longPressGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let longPressGestureRecognizer = SNLongPressGestureRecognizer(handlerBlock: handlerBlockForLongPressGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(longPressGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureLongPressGestureRecognizer(longPressGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UILongPressGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UILongPressGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onLongPress(_ block: @escaping SNLongPressGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let longPressGestureRecognizer = SNLongPressGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(longPressGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UILongPressGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UILongPressGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onLongPressOnce(_ block: @escaping SNLongPressGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForLongPressGestureRecognizer: SNLongPressGestureRecognizerHandlerBlock = { (longPressGestureRecognizer) in
            block(longPressGestureRecognizer)
            self.removeGestureRecognizer(longPressGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let longPressGestureRecognizer = SNLongPressGestureRecognizer(handlerBlock: handlerBlockForLongPressGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(longPressGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPanGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIPanGestureRecognizer` instance changes its state.
     - configurePanGestureRecognizer: Allows to configure `UIPanGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIPanGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPan(_ block: @escaping SNPanGestureRecognizerHandlerBlock, configurePanGestureRecognizer: SNPanGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let panGestureRecognizer = SNPanGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(panGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configurePanGestureRecognizer(panGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPanGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIPanGestureRecognizer` instance changes its state.
     - configurePanGestureRecognizer: Allows to configure `UIPanGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIPanGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPanOnce(_ block: @escaping SNPanGestureRecognizerHandlerBlock, configurePanGestureRecognizer: SNPanGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForPanGestureRecognizer: SNPanGestureRecognizerHandlerBlock = { (panGestureRecognizer) in
            block(panGestureRecognizer)
            self.removeGestureRecognizer(panGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let panGestureRecognizer = SNPanGestureRecognizer(handlerBlock: handlerBlockForPanGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(panGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configurePanGestureRecognizer(panGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPanGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIPanGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPan(_ block: @escaping SNPanGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let panGestureRecognizer = SNPanGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(panGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPanGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIPanGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPanOnce(_ block: @escaping SNPanGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForPanGestureRecognizer: SNPanGestureRecognizerHandlerBlock = { (panGestureRecognizer) in
            block(panGestureRecognizer)
            self.removeGestureRecognizer(panGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let panGestureRecognizer = SNPanGestureRecognizer(handlerBlock: handlerBlockForPanGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(panGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPinchGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIPinchGestureRecognizer` instance changes its state.
     - configurePinchGestureRecognizer: Allows to configure `UIPinchGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIPinchGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPinch(_ block: @escaping SNPinchGestureRecognizerHandlerBlock, configurePinchGestureRecognizer: SNPinchGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let pinchGestureRecognizer = SNPinchGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(pinchGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configurePinchGestureRecognizer(pinchGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPinchGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIPinchGestureRecognizer` instance changes its state.
     - configurePinchGestureRecognizer: Allows to configure `UIPinchGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIPinchGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPinchOnce(_ block: @escaping SNPinchGestureRecognizerHandlerBlock, configurePinchGestureRecognizer: SNPinchGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForPinchGestureRecognizer: SNPinchGestureRecognizerHandlerBlock = { (pinchGestureRecognizer) in
            block(pinchGestureRecognizer)
            self.removeGestureRecognizer(pinchGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let pinchGestureRecognizer = SNPinchGestureRecognizer(handlerBlock: handlerBlockForPinchGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(pinchGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configurePinchGestureRecognizer(pinchGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPinchGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIPinchGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPinch(_ block: @escaping SNPinchGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let pinchGestureRecognizer = SNPinchGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(pinchGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIPinchGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIPinchGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onPinchOnce(_ block: @escaping SNPinchGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForPinchGestureRecognizer: SNPinchGestureRecognizerHandlerBlock = { (pinchGestureRecognizer) in
            block(pinchGestureRecognizer)
            self.removeGestureRecognizer(pinchGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let pinchGestureRecognizer = SNPinchGestureRecognizer(handlerBlock: handlerBlockForPinchGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(pinchGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIRotationGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIRotationGestureRecognizer` instance changes its state.
     - configureRotationGestureRecognizer: Allows to configure `UIRotationGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIRotationGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onRotation(_ block: @escaping SNRotationGestureRecognizerHandlerBlock, configureRotationGestureRecognizer: SNRotationGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let rotationGestureRecognizer = SNRotationGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(rotationGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureRotationGestureRecognizer(rotationGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIRotationGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIRotationGestureRecognizer` instance changes its state.
     - configureRotationGestureRecognizer: Allows to configure `UIRotationGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIRotationGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onRotationOnce(_ block: @escaping SNRotationGestureRecognizerHandlerBlock, configureRotationGestureRecognizer: SNRotationGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForRotationGestureRecognizer: SNRotationGestureRecognizerHandlerBlock = { (rotationGestureRecognizer) in
            block(rotationGestureRecognizer)
            self.removeGestureRecognizer(rotationGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let rotationGestureRecognizer = SNRotationGestureRecognizer(handlerBlock: handlerBlockForRotationGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(rotationGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureRotationGestureRecognizer(rotationGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIRotationGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIRotationGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onRotation(_ block: @escaping SNRotationGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let rotationGestureRecognizer = SNRotationGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(rotationGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIRotationGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIRotationGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onRotationOnce(_ block: @escaping SNRotationGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForRotationGestureRecognizer: SNRotationGestureRecognizerHandlerBlock = { (rotationGestureRecognizer) in
            block(rotationGestureRecognizer)
            self.removeGestureRecognizer(rotationGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let rotationGestureRecognizer = SNRotationGestureRecognizer(handlerBlock: handlerBlockForRotationGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(rotationGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     - configureSwipeGestureRecognizer: Allows to configure `UISwipeGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UISwipeGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipe(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock, configureSwipeGestureRecognizer: SNSwipeGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureSwipeGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     - configureSwipeGestureRecognizer: Allows to configure `UISwipeGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UISwipeGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipeOnce(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock, configureSwipeGestureRecognizer: SNSwipeGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForSwipeGestureRecognizer: SNSwipeGestureRecognizerHandlerBlock = { (swipeGestureRecognizer) in
            block(swipeGestureRecognizer)
            self.removeGestureRecognizer(swipeGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: handlerBlockForSwipeGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureSwipeGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipe(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipeOnce(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForSwipeGestureRecognizer: SNSwipeGestureRecognizerHandlerBlock = { (swipeGestureRecognizer) in
            block(swipeGestureRecognizer)
            self.removeGestureRecognizer(swipeGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: handlerBlockForSwipeGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipeUp(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: block)
        swipeGestureRecognizer.direction = .up
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipeRight(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: block)
        swipeGestureRecognizer.direction = .right
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipeDown(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: block)
        swipeGestureRecognizer.direction = .down
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UISwipeGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UISwipeGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onSwipeLeft(_ block: @escaping SNSwipeGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let swipeGestureRecognizer = SNSwipeGestureRecognizer(handlerBlock: block)
        swipeGestureRecognizer.direction = .left
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(swipeGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIScreenEdgePanGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIScreenEdgePanGestureRecognizer` instance changes its state.
     - configureScreenEdgePanGestureRecognizer: Allows to configure `UIScreenEdgePanGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIScreenEdgePanGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onScreenEdgePan(_ block: @escaping SNScreenEdgePanGestureRecognizerHandlerBlock, configureScreenEdgePanGestureRecognizer: SNScreenEdgePanGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let screenEdgePanGestureRecognizer = SNScreenEdgePanGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(screenEdgePanGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureScreenEdgePanGestureRecognizer(screenEdgePanGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIScreenEdgePanGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIScreenEdgePanGestureRecognizer` instance changes its state.
     - configureScreenEdgePanGestureRecognizer: Allows to configure `UIScreenEdgePanGestureRecognizer` instance.
     It's recommended to change settings of gesture recognizer inside of this block.
     
     For example, you can save `UIScreenEdgePanGestureRecognizer`'s reference somewhere to control it later.
     But it's not necessary since `block` (the first parameter) gives you a full control of the gesture.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onScreenEdgePanOnce(_ block: @escaping SNScreenEdgePanGestureRecognizerHandlerBlock, configureScreenEdgePanGestureRecognizer: SNScreenEdgePanGestureRecognizerConfigurationBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForScreenEdgePanGestureRecognizer: SNScreenEdgePanGestureRecognizerHandlerBlock = { (screenEdgePanGestureRecognizer) in
            block(screenEdgePanGestureRecognizer)
            self.removeGestureRecognizer(screenEdgePanGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let screenEdgePanGestureRecognizer = SNScreenEdgePanGestureRecognizer(handlerBlock: handlerBlockForScreenEdgePanGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(screenEdgePanGestureRecognizer)
        
        
        /*
         * Call configuration block for gesture recognizer.
         */
        
        configureScreenEdgePanGestureRecognizer(screenEdgePanGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIScreenEdgePanGestureRecognizer` instance to receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     - parameters:
     - block: Called when `UIScreenEdgePanGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onScreenEdgePan(_ block: @escaping SNScreenEdgePanGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Create gesture recognizer instance.
         */
        
        let screenEdgePanGestureRecognizer = SNScreenEdgePanGestureRecognizer(handlerBlock: block)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(screenEdgePanGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    /**
     Adds `UIScreenEdgePanGestureRecognizer` instance to receiver.
     Block will be called the first time only. After that, gesture recognizer will be removed from receiver.
     
     Since this method returns receiver instance, it supports chain calls.
     
     **Note**: After first recognition, gesture recognizer will be removed from view.
     
     - parameters:
     - block: Called when `UIScreenEdgePanGestureRecognizer` instance changes its state.
     
     - returns:
     Receiver instance for support of chain calls.
     */
    @discardableResult
    public func onScreenEdgePanOnce(_ block: @escaping SNScreenEdgePanGestureRecognizerHandlerBlock) -> UIView {
        /*
         * Obtain handler block for gesture recognizer.
         */
        
        let handlerBlockForScreenEdgePanGestureRecognizer: SNScreenEdgePanGestureRecognizerHandlerBlock = { (screenEdgePanGestureRecognizer) in
            block(screenEdgePanGestureRecognizer)
            self.removeGestureRecognizer(screenEdgePanGestureRecognizer)
        }
        
        
        /*
         * Create gesture recognizer instance.
         */
        
        let screenEdgePanGestureRecognizer = SNScreenEdgePanGestureRecognizer(handlerBlock: handlerBlockForScreenEdgePanGestureRecognizer)
        
        
        /*
         * Add gesture recognizer to receiver.
         */
        
        addGestureRecognizer(screenEdgePanGestureRecognizer)
        
        
        /*
         * Return receiver's instance for support of chain calls.
         */
        
        return self
    }
    
    
    // MARK: Private object methods
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
