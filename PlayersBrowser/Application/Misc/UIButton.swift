//
//  UIButtonClosureAdditions.swift
//  pickerTest
//
//  Created by valvoline on 27/10/15.
//  Copyright © 2015 ISALabs. All rights reserved.
//
import UIKit
import ObjectiveC

class ClosureWrapper: NSObject, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let wrapper: ClosureWrapper = ClosureWrapper()
        wrapper.closure = closure
        return wrapper
    }
    
    var closure: (() -> Void)?
    convenience init(closure: (() -> Void)?) {
        self.init()
        self.closure = closure
    }
}

extension UIButton {
    private struct AssociatedKeys {
        static var SNGLSActionHandlerTapKey   = "sngls_ActionHandlerTapKey"
    }
    func handleControlEvent(event: UIControl.Event, handler:(() -> Void)?) {
        let aBlockClassWrapper = ClosureWrapper(closure: handler)
        objc_setAssociatedObject(self, &AssociatedKeys.SNGLSActionHandlerTapKey, aBlockClassWrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.addTarget(self, action: #selector(callActionBlock), for: event)
    }
    
    @objc func callActionBlock(sender: AnyObject) {
        let actionBlockAnyObject = objc_getAssociatedObject(self, &AssociatedKeys.SNGLSActionHandlerTapKey) as? ClosureWrapper
        actionBlockAnyObject?.closure?()
    }
}
