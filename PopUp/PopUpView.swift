//
//  PopUpView.swift
//  PopUp
//
//  Created by Alexey on 14.02.2021.
//

import UIKit

class PopUpView: UIView {
    @IBOutlet var labelText: UILabel!
    @IBOutlet weak var popUpView: UIView!
    private weak var delegate: UIViewController?
    private var changingConstraint: NSLayoutConstraint?
    init(delegate: UIViewController, text: String = "Set text in init"){
        self.delegate = delegate
        super.init(frame: .zero)
        self.commonInit(text: text)
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(text: String = "Set text in init"){
        Bundle.main.loadNibNamed("PopUpView", owner: self)
        guard let delegate = delegate else {
            return
        }
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        delegate.view.addSubview(popUpView)
        labelText.text = text
        connectToTop()
        setupUI(viewToSet: popUpView)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panPiece(_:)))
        popUpView.addGestureRecognizer(gesture)
    }
    var initialCenter = CGPoint()
    let distanceToKill: Float = 75.0
    @objc private func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
       guard gestureRecognizer.view != nil else {return}
       let piece = gestureRecognizer.view!
        let distance = Float(sqrt(pow(initialCenter.x - piece.center.x + 1, 2) +
                                    pow(initialCenter.y - piece.center.y + 1, 2)))
       
       
       let translation = gestureRecognizer.translation(in: piece.superview)
       if gestureRecognizer.state == .began {
          
          self.initialCenter = piece.center
       }
        if gestureRecognizer.state != .cancelled {
          let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.layer.opacity = Float(distanceToKill) / distance
          piece.center = newCenter
        }
        if gestureRecognizer.state == .ended {
            if distance >= distanceToKill{
                UIView.animate(withDuration: 0.4, animations: {
                    piece.center = CGPoint(x: 10 * (piece.center.x - self.initialCenter.x), y: 10 * (piece.center.y - self.initialCenter.y))
                    piece.layer.opacity = 0
                })
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    piece.center = self.initialCenter
                    piece.layer.opacity = 1
                })
            }
            

       }
    }
}

extension PopUpView{
    private func connectToTop(){
        guard let delegate = delegate else {
            return
        }
        
        changingConstraint = popUpView.topAnchor.constraint(equalTo: delegate.view.topAnchor, constant: 24)
        changingConstraint!.isActive = true
        popUpView.centerXAnchor.constraint(equalTo: delegate.view.centerXAnchor).isActive = true
        popUpView.widthAnchor.constraint(equalTo: delegate.view.widthAnchor, multiplier: 0.9).isActive = true
        
        var height = popUpView.subviews[0].sizeThatFits(CGSize(width: delegate.view.bounds.width * 0.9, height: 0.2 * delegate.view.bounds.height)).height + 12
        height = min(0.2 * delegate.view.bounds.height, height)
        popUpView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    private func setupUI(viewToSet: UIView){
        viewToSet.layer.cornerRadius = viewToSet.bounds.height / 16
        viewToSet.backgroundColor = .gray
    }
}
