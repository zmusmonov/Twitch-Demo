//
//  UIView+ext.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import UIKit

extension UIView {
    func addsubViews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}

