//
//  ScrollToEndpoint.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/20.
//

import UIKit

enum ScrollDirection {
    case top,bottom
    
    func contentOffsetWith(scrollView: UIScrollView) -> CGPoint{
        var contentOffset = CGPoint.zero
        switch self {
        case .top:
            contentOffset = CGPoint(x: 0, y: scrollView.contentInset.top)
        case .bottom:
            //contentSize是指scrollView視圖的大小，bound是指用於描述在自己系統中視圖(手機)的位置和大小。
            contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height) //- scrollView.bounds.size.height)
        }
        return contentOffset
    }
}


extension UIScrollView {
    func scrollTo(direction: ScrollDirection,animated: Bool = true) {
        //setContentOffset: 設置偏移量(從contentView原點到接收者原點)
        self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
    }
}
