//
//  ViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

final class SlideInPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var direction: PresentationDirection = .bottom
    var categoryName = ""
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
        presentationController.catergoryLabel.text = categoryName
        return presentationController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}



final class SlideInPresentationController: UIPresentationController, UIGestureRecognizerDelegate {
    
    private var direction: PresentationDirection
    
    private var dimmingView: UIView!
    
    lazy var closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "down")
        imageView.setImageColor(color: .white)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var catergoryLabel : UITextView = {
        let label = UITextView()
        label.textColor = .white
        label.backgroundColor = .clear
        label.isEditable = false
        label.dataDetectorTypes = UIDataDetectorTypes.all
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }else{
           label.font = UIFont.boldSystemFont(ofSize: 21)
        }
        label.isSelectable = false
        label.textAlignment = .center
        return label
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {

        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
    
        switch direction {
        case .right:
            frame.origin.x = containerView!.frame.width*(1.0/3.0)
        case .bottom:
            frame.origin.y = containerView!.frame.height*(1.0/2.0)
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
        self.direction = direction
        
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else {
            return
        }
        containerView?.insertSubview(dimmingView, at: 0)
        dimmingView.fillSuperview()
        
//        catergoryLabel.anchorWithConstants(top: containerView!.safeAreaLayoutGuide.topAnchor, left: dimmingView.leftAnchor, bottom: nil, right: dimmingView.rightAnchor, topConstant: 64, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        dimmingView.addSubview(closeImageView)
        _ = closeImageView.anchor(top: containerView!.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: containerView!.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 22, heightConstant: 22)
        
        dimmingView.addSubview(catergoryLabel)
        catergoryLabel.anchorWithConstants(top: closeImageView.bottomAnchor, left: dimmingView.leftAnchor, bottom: containerView!.bottomAnchor, right: dimmingView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: containerView!.frame.height*(1.0/2.0) + 22, rightConstant: 16)
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.masksToBounds = true
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left, .right:
            return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
        case .bottom, .top:
            return CGSize(width: parentSize.width, height: parentSize.height*(1.0/2.0))
        }
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        dimmingView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
}


