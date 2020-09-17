//
//  CustomBackActionType.swift
//  Exchange
//
//  Created by mac on 2019/1/15.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension String {

    //方法
    public func textSize(font: UIFont, maxSize: CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
}

extension UIViewController {

    public func setBackButton(_ icon: UIImage?, _ text: String? = nil) -> Observable<()> {

        let leftButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))

        if let icon = icon {
            leftButton.imageView?.contentMode = .scaleAspectFit
            leftButton.contentHorizontalAlignment = .left
            leftButton.setImage(icon, for: .normal)
            leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        if let text = text {
            let textSize = text.textSize(font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
            leftButton.frame = CGRect(x: 0, y: 0, width: textSize.width + 10, height: 44)
            leftButton.setTitleColor(.black, for: .normal)
            leftButton.setTitle(text, for: .normal)
            leftButton.layoutButton(with: .left, imageTitleSpace: 10)
        }

        let buttonItem = UIBarButtonItem.init(customView: leftButton)

        self.navigationItem.leftBarButtonItem = buttonItem

        return leftButton.rx.tap.asObservable()
    }

    public func setNavRightItem(_ button: UIButton) -> Observable<()> {

//        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)

        return button.rx.tap.asObservable()
    }
}
