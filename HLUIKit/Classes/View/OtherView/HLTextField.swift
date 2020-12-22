//
//  CustomUITextField.swift
//  Exchange
//
//  Created by Apple on 2019/1/10.
//  Copyright © 2019 mac. All rights reserved.
//
// swiftlint:disable identifier_name
// swiftlint:disable line_length

import UIKit
import RxSwift
import RxCocoa

public enum HLTextFieldConstraint {

    case system

    case phone
    case email
    case username
    case password
    case inviteCode
    case dynamicCode(len: Int)

    case identify           // 身份证号
    case bankNumber         // 银行卡号
    case letterAndDigital
    case realName           // 真实名称
    case nickName           // 昵称——10位
    case integal
    case decimal

    case money
    case coinNumber

    case wechatAccount
    case alipayAccount
    case branchBank         // 开户支行
    case bankName           // 开户银行

    case chinesePhone
    case sellerPartnerAccount
    case text(maxLen: Int)

    public var regularExpressions: String {
        switch self {
        case .sellerPartnerAccount:
            return "[^(\\u4E00-\\u9FA5)|(a-zA-Z0-9)]"

        case .username,
             .email,
             .wechatAccount,
             .alipayAccount,
             .password:
            return "[^a-zA-Z0-9_~!@$%&,;?\\-\\.\\*\\#]"
        case .inviteCode,
             .letterAndDigital:
            return "[^a-zA-Z0-9]"

        case .dynamicCode,
             .phone,
             .chinesePhone,
             .bankNumber,
             .integal:
            return "[^0-9]"

        case .identify:
            return "[^a-zA-Z0-9]"

        case .nickName,
             .realName:     // "[^A-Za-z\\u4E00-\\u9FA5]"
            return "[^(\\u4E00-\\u9FA5)|(a-zA-Z0-9_~!@$%&,;?\\-\\.\\*\\#)]"

        case .system:
            return ""
        case .decimal,
             .money,
             .coinNumber:
            return "[^0-9.]"

        case .branchBank,
             .bankName:
            return "[^(\\u4E00-\\u9FA5)|(a-zA-Z0-9_~!@$%&,;?\\-\\.\\*\\#)]"
        case .text:
            return ""
        }
    }

    public var maxInputLen: Int {
        switch self {
        case .phone:
            return 20
        case .chinesePhone:
            return 11
        case .email:
            return 30
        case .alipayAccount:
            return 50
        case .username:
            return 50
        case .password,
             .sellerPartnerAccount:
            return 18
        case .inviteCode:
            return 6
            
        case .dynamicCode(let maxLen):
            return maxLen
        case .bankNumber:
            return 40
        case .identify:
            return 18
        case .nickName:
            return 40
        case .realName:
            return 40

        case .wechatAccount:
            return 25

        case .system:
            return -1

        case .branchBank:
            return 150
        case .bankName:
            return 150

        case .letterAndDigital,
             .integal,
             .decimal,
             .money,
             .coinNumber:
            return -1
        case .text(let maxLen):
            return maxLen
        }
    }
}

open class HLTextField: UITextField {
    private let disposeBag = DisposeBag()
    public let textSubject = PublishSubject<String>()

    public var expression = ""
    public var maxLen: Int = -1
    public var constraint: HLTextFieldConstraint? {
        didSet {
            guard let constraint = constraint else { return }

            maxLen = constraint.maxInputLen
            expression = constraint.regularExpressions
            bindConfig()
        }
    }

    public func set(constraint: HLTextFieldConstraint, maxLen: Int? = nil) {
        self.constraint = constraint

        if let len = maxLen, len > 0 {
            self.maxLen = len
        }
    }

    public init() {
        super.init(frame: CGRect.zero)

        self.delegate = self
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.bindConfig()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.bindConfig()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.bindConfig()
    }

    open func getTextFieldText(with str: String?) -> String? {

        guard let s = str, s.count > maxLen, maxLen > 0 else {
            return str
        }

        /// 邮箱类型限制条件为@前最多30位
        switch constraint {
        case .email, .alipayAccount:
            let ch = s.subStringWithRang(location: maxLen, length: 1)

            if ch == "@" {
                return str
            }

        default:
            break
        }

        return s.substring(to: maxLen - 1)
    }

    open func setTextFieldText(_ text: String?) {
        guard let text = text else { return }
        var result = text
        /// 身份证信息不做处理
        if !self.expression.isEmpty {
            switch constraint {
            case .identify:
                break
            default:
                result = text.pregReplace(pattern: self.expression, with: "")
            }
        }
        self.text = result
        self.textSubject.onNext(result)
    }

    open func bindConfig() {
        self.rx.controlEvent(UIControl.Event.editingChanged)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (_) in

                let toBeString = self.text

                let lang = self.textInputMode?.primaryLanguage
                if lang == "zh-Hans" || lang == "zh-Hant" {

                    /// textfield 拼音高亮处理
                    let selectedRange = self.markedTextRange
                    guard selectedRange != nil else {
                        self.setTextFieldText(self.getTextFieldText(with: toBeString))
                        return
                    }

                    let position = self.position(from: selectedRange!.start, offset: 0)
                    guard position != nil else {
                        self.setTextFieldText(self.getTextFieldText(with: toBeString))
                        return
                    }
                } else {
                    self.setTextFieldText(self.getTextFieldText(with: toBeString))
                }

            }).disposed(by: disposeBag)
    }

    /// 禁用编辑手势
    @available(iOS 13.0, *)
    override public var editingInteractionConfiguration: UIEditingInteractionConfiguration {
        return .none
    }

    /// 输入限制
    ///
    /// - Parameter constraint: 限制规则
    /// - Returns: 返回限制后的结果
    func setInputLimit(by constraint: HLTextFieldConstraint) -> Observable<String?> {

        return self.rx
            .controlEvent(UIControl.Event.editingChanged)
            .asObservable()
            .do(onNext: {[unowned self] (_) in
                let toBeString = self.text

                /// 格式处理
                var result: String = toBeString ?? ""
                if constraint.regularExpressions.count > 0 {
                    result = toBeString?.pregReplace(pattern: constraint.regularExpressions, with: "") ?? ""
                } else {
                    print("=== Notify: 输入文本没有使用正则过滤")
                }

                let lang = self.textInputMode?.primaryLanguage
                if lang == "zh-Hans" || lang == "zh-Hant" {
                    /// textfield 拼音高亮处理
                    let selectedRange = self.markedTextRange
                    guard selectedRange != nil else {
                        self.text = self.getTextFieldText(with: result)
                        return
                    }

                    let position = self.position(from: selectedRange!.start, offset: 0)
                    guard position != nil else {
                        self.text = self.getTextFieldText(with: result)
                        return
                    }
                } else {
                    self.text = self.getTextFieldText(with: result)
                }
            })
            .flatMap({ (_) -> Observable<String?> in
                return Observable.just(self.text)
            })
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateClearImage()
    }

    private var updatedClearImage = false
    var clearImage: UIImage?
    open func updateClearImage() {
        if updatedClearImage { return }
        if let button = self.value(forKey: "clearButton") as? UIButton,
            let image = clearImage ?? UIImage(named: "ClearBtn") {
            button.setImage(image, for: .normal)
            button.setImage(image, for: .highlighted)
            button.tintColor = .white
            updatedClearImage = true
        }
    }
    // MARK: 缩进
    open var leftViewOfffset: CGFloat = 0
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftViewOfffset
        return rect
    }
    
    open var rightViewSize: CGSize = .zero
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - rightViewSize.width, y: 0, width: rightViewSize.width , height: bounds.height)
    }
    
    
    open var textOffset: CGFloat = 0
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
//        rect.origin.x += textOffset
        return CGRect(x: rect.origin.x + textOffset, y: rect.origin.y, width: rect.size.width - textOffset, height: rect.size.height)
    }
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
//        rect.origin.x += textOffset
        return CGRect(x: rect.origin.x + textOffset, y: rect.origin.y, width: rect.size.width - textOffset, height: rect.size.height)
    }
    
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return true
//    }

}

extension HLTextField: UITextFieldDelegate {

    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// 禁止使用表情符号
        guard let primaryLanguage = textField.textInputMode?.primaryLanguage else {
            return false
        }

        if primaryLanguage == "emoji" {
            return false
        }
        /// 非九宫格下判断表情
        if string.isNineKeyBoard() == false && (string.containsEmoji() || string.hasEmoji()) {
            return false
        }
        return true
    }
}
