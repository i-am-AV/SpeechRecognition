//
//  Constraints.swift
//  SpeechRecognition
//
//  Created by  Alexander on 22.09.2020.
//

import UIKit

public extension UIView {
    @discardableResult func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    func pinEdgesToSuperviewEdges(withOffset offset: CGFloat) {
        self.pinEdgesToSuperviewEdges(top: offset, left: offset, bottom: offset, right: offset)
    }

    func pinEdgesToSuperviewEdges(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        leftAnchor ~= superview.leftAnchor + left
        rightAnchor ~= superview.rightAnchor - right
        topAnchor ~= superview.topAnchor + top
        bottomAnchor ~= superview.bottomAnchor - bottom
    }

    @available(*, deprecated, renamed: "pinEdgesToSuperviewEdges(top:left:bottom:right:)")
    func pinEdgesToSuperviewEdges(top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat) {
        pinEdgesToSuperviewEdges(top: top, left: left, bottom: bottom, right: right)
    }

    enum PinnedSide {
        case top
        case left
        case right
        case bottom
    }

    func pinEdgesToSuperviewEdges(excluding side: PinnedSide) {
        switch side {
        case .top:
            self.pinToSuperview([.left, .right, .bottom])
        case .left:
            self.pinToSuperview([.top, .right, .bottom])
        case .right:
            self.pinToSuperview([.top, .left, .bottom])
        case .bottom:
            self.pinToSuperview([.top, .left, .right])
        }
    }

    func pinToSuperview(_ sides: [PinnedSide]) {
        guard let superview = superview, !sides.isEmpty else {
            fatalError("There is no superview or sides")
        }

        sides.forEach { side in
            switch side {
            case .top:
                topAnchor ~= superview.topAnchor
            case .right:
                rightAnchor ~= superview.rightAnchor
            case .left:
                leftAnchor ~= superview.leftAnchor
            case .bottom:
                bottomAnchor ~= superview.bottomAnchor
            }
        }
    }

    func pin(to view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        pin(to: view, edgesInsets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    @available(*, deprecated, renamed: "pin(to:top:left:bottom:right:)")
    func pin(to view: UIView, top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat) {
        pin(to: view, top: top, left: left, bottom: bottom, right: right)
    }

    func pin(to view: UIView, edgesInsets: UIEdgeInsets) {
        if view.translatesAutoresizingMaskIntoConstraints != false &&
            self.translatesAutoresizingMaskIntoConstraints != false {
            fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
        }
        topAnchor ~= view.topAnchor + edgesInsets.top
        rightAnchor ~= view.rightAnchor - edgesInsets.right
        leftAnchor ~= view.leftAnchor + edgesInsets.left
        bottomAnchor ~= view.bottomAnchor - edgesInsets.bottom
    }

    func pin(as view: UIView, using sides: [PinnedSide]) {
        if view.translatesAutoresizingMaskIntoConstraints != false &&
            self.translatesAutoresizingMaskIntoConstraints != false {
            fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
        }
        sides.forEach { side in
            switch side {
            case .top:
                topAnchor ~= view.topAnchor
            case .right:
                rightAnchor ~= view.rightAnchor
            case .left:
                leftAnchor ~= view.leftAnchor
            case .bottom:
                bottomAnchor ~= view.bottomAnchor
            }
        }
    }
}

public struct ConstraintAttribute<T: AnyObject> {
    let anchor: NSLayoutAnchor<T>
    let const: CGFloat
}

public struct LayoutGuideAttribute {
    let guide: UILayoutSupport
    let const: CGFloat
}

public func + <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: rhs)
}

public func + (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: rhs)
}

public func - <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: -rhs)
}

public func - (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: -rhs)
}

// ~= is used instead of == because Swift can't overload == for NSObject subclass
@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: UILayoutSupport) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.bottomAnchor)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: LayoutGuideAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.guide.bottomAnchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}


