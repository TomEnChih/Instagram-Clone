//
//  EditProfileVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

    
    struct EditProfileFormModel {
        let label: String
        let placeholder: String
        var value: String?
    }
    
    class EditProfileVC: UIViewController {
        
        // MARK: - Properties
        
        private let editProfileView = EditProfileView()
        
        private var models = [[EditProfileFormModel]]()
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            editProfileView.editProfileTableView.tableHeaderView = createTableHeaderView()
            view = editProfileView
            editProfileView.editProfileTableView.dataSource = self
            editProfileView.editProfileTableView.delegate = self
            configureNavigationBar()
            configureModels()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            editProfileView.editProfileTableView.frame = view.bounds
        }
        
        // MARK: - Methods
        
        func configureNavigationBar() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(didTapSave))
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(didTapCancel))
            
        }
        
        @objc private func didTapSave() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc private func didTapCancel() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc private func didTapChangeProfilePicture() {
            let actionSheet = UIAlertController(title: "大頭貼照", message: "更換大頭貼照", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "從圖庫選擇", style: .default, handler: { (action) in
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            
            actionSheet.popoverPresentationController?.sourceView = view
            actionSheet.popoverPresentationController?.sourceRect = view.bounds
            
            present(actionSheet, animated: true, completion: nil )
            
        }
        
        
        private func createTableHeaderView() -> UIView{
            let header = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.bounds.width,
                                              height: view.bounds.height/5).integral)
            let size = header.bounds.height/2
            let profilePhotoButton: UIButton = {
                let button = UIButton(frame: CGRect(x: (view.bounds.width-size)/2,
                                                    y: (header.bounds.height-size)/2,
                                                    width: size,
                                                    height: size))
                
                button.addTarget(self, action: #selector(didTapChangeProfilePicture), for: .touchUpInside)
                
                button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
                button.layer.masksToBounds = true
                button.layer.cornerRadius = size/2
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.secondarySystemBackground.cgColor
                return button
            }()
            header.addSubview(profilePhotoButton)
            
            return header
        }
        
        @objc private func didTapProfilePhotoButton() {
            
        }
        
        private func configureModels() {
            //name, username, website, bio
            let section1Labels = ["Name","Username","Bio"]
            var section1 = [EditProfileFormModel]()
            for label in section1Labels {
                let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
                section1.append(model)
            }
            models.append(section1)
            
            //email, phone, gender
            let section2Labels = ["Email","Phone","Gender"]
            var section2 = [EditProfileFormModel]()
            for label in section2Labels {
                let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
                section2.append(model)
            }
            models.append(section2)
        }
        
        
    }
    
    //MARK: - TableViewDelegate,TableViewDataSource
    extension EditProfileVC: UITableViewDelegate,UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            models.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            models[section].count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let model = models[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.cellKey, for: indexPath) as!
                FormTableViewCell
            
            cell.configure(with: model)
            cell.delegate = self
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            guard section == 1 else {
                return nil
            }
            return "Private Information"
        }
        
    }
    
    extension EditProfileVC: FormTableViewCellDelegate {
        
        func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel?) {
            //update the model
            print(updatedModel?.value ?? "nil")
        }
        
    }
