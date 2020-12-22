//
/***********************************************************
            
 File name:     TextFieldCell.swift
 Author:        Mojy
            
 Description:   TexField样式的TableVewlCell
            
 History:  2019/5/8: File created.
            
 ************************************************************/

import UIKit
import RxSwift
import RxCocoa

extension UIColor {
    open class var cellBorderColor: UIColor {
        return .init(hex: "FFFFFF")
    }

    open class var cellPlaceHolderColor: UIColor {
        return .init(hex: "FFFFFF")
    }
}

extension String {

    public func calculateHeight(_ font: UIFont?, _ maxWidth: CGFloat = CGFloat(MAXFLOAT)) -> CGFloat {

        let lable = UILabel.init()
        lable.font = font ?? UIFont.systemFont(ofSize: 15)
        lable.numberOfLines = 0
        lable.text = self

        return lable.sizeThatFits(CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))).height
    }
    
    public func calculateSize(_ font: UIFont?) -> CGSize {
        let lable = UILabel.init()
        lable.font = font ?? UIFont.systemFont(ofSize: 15)
        lable.text = self
        lable.sizeToFit()
        return lable.frame.size
    }
}

public class TextCellConfig: NSObject {

    public var tag: Int = 1000
    public var text: String?
    public var attributedText: NSAttributedString?
    public var placeholder: String?
    public var constraint: HLTextFieldConstraint = .text(maxLen: 50) // 默认支持中英特殊字符
    public var keyboardType: UIKeyboardType = .default
    public var textAlignment = NSTextAlignment.left

    public var useVerificationCode: Bool = false

    public var rightView: UIView?
    public var allowEdit: Bool = true

    public var textColor: UIColor?
    public var placeholderColor: UIColor? = .systemGray
    public var backgroundColor: UIColor?

    public var font: UIFont?
    /// 缩进
    public var offsetX: CGFloat?
    /// 是否根据校验类型自动格式化
    public var autoFormat: Bool = false
    /// 是否需要极验行为验证
    public var needActive: Bool = true

    /// 最大输入限制
    public var maxInputCount = 100

    /// 图标
    public var icon: UIImage?

    /// 输入时的提示信息
    public var tip: String?
}

extension TextCellConfig {

    public func calculateTextHeight(_ maxWidth: CGFloat) -> CGFloat {

        let height = text?.calculateHeight(font, maxWidth) ?? 44

        return height
    }
}

open class DefaultTextFieldCell: HLTableViewCell {

    public let textField = HLTextField().then { (textField) in
//        textField.layer.borderColor = UIColor.cellBorderColor.cgColor
//        textField.layer.borderWidth = 0.5
//        textField.layer.cornerRadius = 4

//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
//        textField.leftView = leftView
//        textField.leftViewMode = .always

        textField.textColor = UIColor.white
        textField.placeholderTextColor = UIColor.systemGray
    }

    lazy public var verificationCodeButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.setTitle("获取验证码".localized, for: .normal)
        $0.frame = CGRect.init(x: 0, y: 0, width: 110, height: 45)

        $0.contentHorizontalAlignment = .right
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.setTitleColor(UIColor.gray, for: .disabled)
    }

    /// 提示信息
    lazy public var tipLabel = UILabel().then { (label) in
        label.font = .pingfang(ofSize: 10)
        label.textColor = .systemRed
        label.isHidden = true
    }

    override open func bindConfig() {
        super.bindConfig()

        textField.textSubject.subscribe(onNext: { [weak self] text in

            guard let weakSelf = self else { return }
            weakSelf.cellEvent.onNext((tag: weakSelf.textField.tag, value: weakSelf.textField.text))
        }).disposed(by: disposeBag)

        /// 输入格式化
        textField.rx.text.orEmpty.subscribe(onNext: {[unowned self] (text) in

            guard let config = self.data as? TextCellConfig else {
                return
            }

            if case .password = config.constraint, config.tip != nil, text.count > 0 {
                self.tipLabel.isHidden = Validate.password(text).isRight
            } else {
                self.tipLabel.isHidden = true
            }

            /// 不自动格式化则直接返回
            if config.autoFormat == false {
                return
            }

            switch config.constraint {
            case .decimal:

                self.textField.text = text.formatCoinNumberString(decimalLen: 8)
            case .money:
                self.textField.text = text.formatPriceString()

            default:
                break
            }

        }).disposed(by: disposeBag)

    }

    override open func initConfig() {

        backgroundColor = .white
    }

    override open func layoutConfig() {

        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalTo(HLTableViewCell.defaultCellMarginValue)
            make.right.equalTo(-HLTableViewCell.defaultCellMarginValue)
        }

        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(HLTableViewCell.defaultCellMarginValue)
            make.right.equalTo(-HLTableViewCell.defaultCellMarginValue)
            make.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
    }

    override open func updateData() {
        super.updateData()

        if let config = data as? TextCellConfig {
            tag = config.tag
            textField.tag = config.tag
            textField.keyboardType = config.keyboardType
            textField.constraint = config.constraint

            textField.placeholder = config.placeholder
            textField.placeholderTextColor = config.placeholderColor

            textField.textAlignment = config.textAlignment
            textField.textColor = config.textColor
            textField.font = config.font
            
            if let offsetX = config.offsetX {
                textField.textOffset = offsetX
            }            

            if case .password = config.constraint {
                textField.isSecureTextEntry = true
            } else {
                textField.isSecureTextEntry = false
            }

            textField.isEnabled = config.allowEdit

            if let rightView = config.rightView {
                textField.rightView = rightView
                textField.rightViewMode = .always
            }

            if let textColor = config.textColor {
                textField.textColor = textColor
            }

            if let content = config.text {
                textField.text = content
            }

            if let backgroudColor = config.backgroundColor {
                textField.backgroundColor = backgroudColor
            }

            if config.useVerificationCode {
                textField.rightView = verificationCodeButton
                textField.rightViewMode = .always
            } else {
                textField.rightView = nil
                textField.rightViewMode = .never
            }
            
            if let icon = config.icon {
                textField.leftView = UIImageView(image: icon)
                textField.leftViewMode = .always
            } else {
                textField.leftView = nil
                textField.leftViewMode = .never
            }

            if let tip = config.tip {
                tipLabel.text = tip
            }
        }
    }
}
