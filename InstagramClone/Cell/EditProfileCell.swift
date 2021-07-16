//
//  EditProfileCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func editProfileCell(_ cell: EditProfileCell, didUpdateField updatedModel: EditProfileModel?)
}


class EditProfileCell: UITableViewCell,UITextFieldDelegate {
    
    // MARK: - Properties
    
    static let id = "EditProfileCell"
    
    public weak var delegate: EditProfileCellDelegate?
    
    private var model: EditProfileModel?
    
    // MARK: - IBElements
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        return textField
    }()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        formLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.height.equalTo(40)
            make.width.equalTo(contentView).multipliedBy(0.2)
        }
        
        field.snp.makeConstraints { (make) in
            make.left.equalTo(formLabel.snp.right).offset(20)
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.height.equalTo(40)
        }
        
        separateView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(formLabel.snp.right).offset(20)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        contentView.addSubview(separateView)
        field.delegate = self
        selectionStyle = .none
        autoLayout()
        field.addTarget(self, action: #selector(handleSendValue), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    public func configure(with model: EditProfileModel,index:IndexPath) {
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    @objc func handleSendValue() {
        model?.value = field.text
        guard let model = model else { return }
        
        delegate?.editProfileCell(self, didUpdateField: model)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
