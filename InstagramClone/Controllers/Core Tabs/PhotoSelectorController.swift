//
//  PhotoSelectorVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/8.
//

import UIKit
import Photos

class PhotoSelectorController: UIViewController {
    
    // MARK: - Properties
    
    private let photoSelectorView = PhotoSelectorView()
    
    var images = [UIImage]()
    var selectedImage: UIImage?
    var assets =  [PHAsset]()
    // 為了傳值
    var header: PhotoSelectorHeader?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = photoSelectorView
        photoSelectorView.collectionView.delegate = self
        photoSelectorView.collectionView.dataSource = self
        setupNavigationButtons()
        fetchPhotos()
        
    }
    
    // MARK: - Methods
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    private func setupNavigationButtons() {
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        self.tabBarController?.selectedIndex = 0
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let vc = SharePhotoController()
        vc.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Handle Photoes
    private func assetsFetchOptions() -> PHFetchOptions {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDesriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDesriptor]
        
        return fetchOptions
    }
    
    private func fetchPhotos() {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        
                        DispatchQueue.main.async {
                            self.photoSelectorView.collectionView.reloadData()
                        }
                        
                    }
                }
            }
        }
        
    }
    
}

//MARK: - CollectionViewDelegateFlowLayout,CollectionViewDataSource

extension PhotoSelectorController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = images[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionView.id, for: indexPath) as! PhotoSelectorCell
        
        cell.photoImageView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width-5) / 4
        
        return CGSize(width: width, height: width)
    }
    
    //MARK: Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            //footer
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoSelectorHeader.id, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        
        header.photoImageView.image = selectedImage
        ///照片變清晰
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    
                    header.photoImageView.image = image
                }
            }
        }
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = view.frame.width
        
        return CGSize(width: width, height: width)
    }
    
    //MARK: didSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let image = images[indexPath.item]
        selectedImage = image
        photoSelectorView.collectionView.reloadData()
        
        let path = IndexPath(item: 0, section: 0)
        photoSelectorView.collectionView.scrollToItem(at: path, at: .bottom, animated: true)
        
    }
    
    
}
