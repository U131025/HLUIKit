//
//  TextViewTableViewCell.swift
//  Community
//
//  Created by mac on 2019/9/20.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxSwift

open class TextViewTableViewCell: HLTableViewCell {

    public let textView = UITextView()
    public let hintLabel = UILabel()

    public let remarkSubject = PublishSubject<String>()

    /// 备注内容的最大值
    public var maxTextCount: Int = 100 {
        didSet {
            hintLabel.text = "0/\(maxTextCount)"
        }
    }

    public var constraint: HLTextFieldConstraint? {
        didSet {
            maxTextCount = constraint?.maxInputLen ?? 100
        }
    }

    public func setTextViewText(text: String?) {

        var result: String = text ?? ""

        if let expression = constraint?.regularExpressions, expression.count > 0 {
            result = text?.pregReplace(pattern: expression, with: "") ?? ""
        }

        if result.count > self.maxTextCount {
            self.textView.text = result.substring(to: self.maxTextCount-1)
            self.hintLabel.textColor = UIColor.red
        } else {
            self.textView.text = result
            self.hintLabel.textColor = UIColor.systemGray
        }

        self.textView.textColor = UIColor.black
        self.hintLabel.text = "\(self.textView.text.count)/\(self.maxTextCount)"

        self.remarkSubject.onNext(self.textView.text)
        self.cellEvent.onNext((tag: self.textView.tag, value: self.textView.text))
    }

    override open func initConfig() {
        super.initConfig()

        backgroundColor = UIColor.white

        textView.font   = .pingfang(ofSize: 15)
        hintLabel.font  = .pingfang(ofSize: 15)

        textView.layer.cornerRadius = 4
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1

        textView.delegate = self

        contentView.addSubview(textView)
        contentView.addSubview(hintLabel)
    }

    override open func layoutConfig() {

        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15))
        }

        hintLabel.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(textView).offset(-6)
            make.height.equalTo(14)
        }
    }

    override open func bindConfig() {
        super.bindConfig()

        textView.rx.didChange.subscribe(onNext: {[unowned self] _ in

            let toBeString = self.textView.text

            let lang = self.textView.textInputMode?.primaryLanguage
            if lang == "zh-Hans" || lang == "zh-Hant" {

                /// textfield 拼音高亮处理
                let selectedRange = self.textView.markedTextRange
                guard selectedRange != nil else {
                    self.setTextViewText(text: toBeString)
                    return
                }

                let position = self.textView.position(from: selectedRange!.start, offset: 0)
                guard position != nil else {
                    self.setTextViewText(text: toBeString)
                    return
                }
            } else {
                self.setTextViewText(text: toBeString)
            }

        }).disposed(by: disposeBag)
    }

    override open func updateData() {
        if let config = data as? TextCellConfig {

            if config.textColor != nil { textView.textColor = config.textColor }
            if config.font != nil { textView.font = config.font }
            if config.placeholder != nil { textView.placeholder = config.placeholder }

            constraint = config.constraint
            textView.tag = config.tag

            setTextViewText(text: config.text)

            textView.isUserInteractionEnabled = config.allowEdit
            hintLabel.isHidden = !config.allowEdit
        }
    }

}

extension TextViewTableViewCell: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        guard let primaryLanguage = textView.textInputMode?.primaryLanguage else {
            return false
        }

        if primaryLanguage == "emoji" {
            return false
        }

        /// 非九宫格下判断表情
        if text.isNineKeyBoard() == false && (text.containsEmoji() || text.hasEmoji()) {
            return false
        }

        return true
    }
}
