//
//  UISearchBar+Extension.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 11.11.2021.
//

import UIKit

extension UISearchBar {
    
    func setBookmark() {
        
        showsBookmarkButton = true
        
        if let btn = searchTextField.rightView as? UIButton {
            btn.setImage(UIImage(named: "mark_grey.png"), for: .normal)
            btn.setImage(UIImage(named: "mark_color.png"), for: .highlighted)
            btn.setImage(UIImage(named: "mark_color.png"), for: .selected)
            
        }
    }
}
