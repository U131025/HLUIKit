//
//  CustomTextView.swift
//  Exchange
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019 mac. All rights reserved.
//
// swiftlint:disable identifier_name
// swiftlint:disable line_length

import UIKit.UITextView
import RxSwift
import RxCocoa

public class HLTextView: UITextView {

    open var expression = "[<>\"”“/]"
    open var maxTextCount: Int = 0  /// 备注内容的最大值

    private let disposeBag = DisposeBag()
    let textSubject = PublishSubject<String>()

    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        bindConfig()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        bindConfig()
    }

    public func getText(with str: String?) -> String? {
        guard maxTextCount > 0, let s = str, s.count > maxTextCount else {
            return str
        }
        return s.substring(to: maxTextCount-1)
    }

    public func setText(_ text: String?) {
        guard let text = text else { return }

        var result = text
        if !self.expression.isEmpty {
            result = text.pregReplace(pattern: self.expression, with: "")
        }

        self.text = result
        self.textSubject.onNext(result)
    }

    func bindConfig() {

        self.delegate = self

        self.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: {[unowned self] _ in

            let toBeString = self.text

            let language = self.textInputMode?.primaryLanguage
            if language == "zh-Hans" || language == "zh-Hant" {

                guard let selectedRange = self.markedTextRange else {
                    self.setText(self.getText(with: toBeString))
                    return
                }
                guard self.position(from: selectedRange.start, offset: 0) != nil else {
                    self.setText(self.getText(with: toBeString))
                    return
                }
            } else {
                self.setText(self.getText(with: toBeString))
            }
        }).disposed(by: disposeBag)
    }
}

extension HLTextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let primaryLanguage = textView.textInputMode?.primaryLanguage else {
            return false
        }
        if primaryLanguage == "emoji" {
            return false
        }
        if text.containsEmoji() {
            return false
        }
        return true
    }
}
