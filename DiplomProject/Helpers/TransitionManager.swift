//
//  TransitionManager.swift
//  DiplomProject
//
//  Created by Александр Молчан on 6.03.23.
//

import UIKit

enum ControllerTransitionType {
    case presentation
    case dismissal
    
    var blurAlpha: CGFloat { return self == .presentation ? 1: 0 }
    var dimAlpha: CGFloat { return self == .presentation ? 0.5 : 0 }
    var cornerRadius: CGFloat { return self == .presentation ? 20 : 0 }
    var cardMode: CardViewMode { return self == .presentation ? .card : .full }
    var next: ControllerTransitionType { return self == .presentation ? .dismissal : .presentation }
}

final class TransitionManager: NSObject {
    let transitionDuration: Double = 0.8
    let shrinkDuration: Double = 0.2
    var transition: ControllerTransitionType = .presentation
    
    lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blur)
        return visualEffectView
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var takkenCard: AnalyticsCardView?
    var viewModel: AnalyticsViewModel?
    
    private func addEffects(to view: UIView) {
        blurView.frame = view.frame
        blurView.alpha = transition.next.blurAlpha
        view.addSubview(blurView)
        dimmingView.frame = view.frame
        dimmingView.alpha = transition.next.dimAlpha
        view.addSubview(dimmingView)
    }
    
    private func createCopyOfView(view: AnalyticsCardView) -> AnalyticsCardView {
        guard let account = view.currentAccount,
              let totalSumm = view.totalSumm else { return AnalyticsCardView() }
        let viewCopy = AnalyticsCardView()
        viewCopy.viewSettings(account: account, type: transition.cardMode, totalSumm: totalSumm)
        return viewCopy
    }
    
    func takeCard(card: AnalyticsCardView, viewModel: AnalyticsViewModel) {
        self.takkenCard = card
        self.viewModel = viewModel
    }
}

extension TransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        addEffects(to: containerView)
        
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
  
        guard let takkenCard else { return }
        let cardViewCopy = createCopyOfView(view: takkenCard)
        containerView.addSubview(cardViewCopy)
        takkenCard.isHidden = true
        
        let absoluteViewFrame = takkenCard.convert(takkenCard.frame, to: nil)
        cardViewCopy.frame = absoluteViewFrame
        cardViewCopy.layoutIfNeeded()
        
        whiteView.frame = transition == .presentation ? cardViewCopy.containerView.frame : containerView.frame
        whiteView.layer.cornerRadius = transition.cornerRadius
        cardViewCopy.insertSubview(whiteView, aboveSubview: cardViewCopy.shadowView)
        
        if transition == .presentation {
            guard let detailView = toView as? AnalyticsDetailViewController else { return }
            containerView.addSubview(detailView.view)
            detailView.viewsHidden = true
            
            moveAndConvertToCardView(card: cardViewCopy, container: containerView, yOriginToMoveTo: 0) {
                detailView.viewsHidden = false
                detailView.showElementsWithAnimate()
                cardViewCopy.removeFromSuperview()
                takkenCard.isHidden = false
                transitionContext.completeTransition(true)
            }
            
        } else {
            guard let detailView = fromView as? AnalyticsDetailViewController,
                  let width = detailView.cardView?.frame.size.width,
                  let height = detailView.cardView?.frame.size.height else { return }
            detailView.viewsHidden = true
            cardViewCopy.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            moveAndConvertToCardView(card: cardViewCopy, container: containerView, yOriginToMoveTo: absoluteViewFrame.origin.y) {
                takkenCard.isHidden = false
                transitionContext.completeTransition(true)
            }
            
        }
    }
    
    private func shrinkAnimator(for card: AnalyticsCardView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: shrinkDuration, curve: .easeOut) {
            card.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.dimmingView.alpha = 0.07
        }
    }
    
    private func expendAnimator(for card: AnalyticsCardView, in container: UIView, yOrigin: CGFloat) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            card.transform = .identity
            card.containerView.layer.cornerRadius = self.transition.next.cornerRadius
            card.frame.origin.y = yOrigin
            self.blurView.alpha = self.transition.blurAlpha
            self.dimmingView.alpha = self.transition.dimAlpha
            self.whiteView.layer.cornerRadius = self.transition.next.cornerRadius
            container.layoutIfNeeded()
            self.whiteView.frame = self.transition == .presentation ? container.frame : card.containerView.frame
        }
        return animator
    }
    
    private func moveAndConvertToCardView(card: AnalyticsCardView, container: UIView, yOriginToMoveTo: CGFloat, completion: @escaping (() -> Void)) {
        let shrinkAnimator = shrinkAnimator(for: card)
        let expendAnimator = expendAnimator(for: card, in: container, yOrigin: yOriginToMoveTo)
        
        expendAnimator.addCompletion { _ in
            completion()
        }
        
        if transition == .presentation {
            shrinkAnimator.addCompletion { _ in
                card.layoutIfNeeded()
                card.updateLayout(for: self.transition.next.cardMode)
                expendAnimator.startAnimation()
            }
            shrinkAnimator.startAnimation()
        } else {
            card.layoutIfNeeded()
            card.updateLayout(for: self.transition.next.cardMode)
            expendAnimator.startAnimation()
        }
    }
    
}

extension TransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}
