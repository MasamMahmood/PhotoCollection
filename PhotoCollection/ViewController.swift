//
//  ViewController.swift
//  PhotoCollection
//
//  Created by Masam Mahmood on 19.12.2019.
//  Copyright © 2019 Masam Mahmood. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate {

    let cellName = "PhotoCollectionViewCell"
    var id: Int?
    var data: [PhotoModel]?
    var images: [UIImage]?
    var imagePicker: UIImagePickerController!
    let deleteAlertView: FotoDeleteAlert! = nil
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.register(UINib(nibName:cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
        
        images = []
        data = []
        collectionView.dataSource = self
        collectionView.delegate = self
    }


enum ImageSource {
        case photoLibrary
        case camera
    }
    
    //MARK: - Take image
    @objc func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    @objc func takePhotoLib() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.photoLibrary)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        let model = PhotoModel(parentId: id, path: "info[UIImagePickerControllerMediaURL]", identifier: "info[UIImagePickerControllerMediaURL]" )
        images?.append(selectedImage)
        data?.append(model)
        collectionView.reloadData()
    }
}
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(indexPath.row < (data?.count ?? 0)){
            let fullView = UIImageView(image: images![indexPath.row])
            fullView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            fullView.contentMode = .scaleAspectFit
            fullView.isUserInteractionEnabled = true
            fullView.backgroundColor = UIColor.black
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeFullscreen(_:)))
            fullView.addGestureRecognizer(tapGestureRecognizer)
            self.view.addSubview(fullView)
            
        }else{
            takePhoto()
        }
    }
}

//MARK: - CollectionView

extension ViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (data?.count ?? 0) + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! PhotoCollectionViewCell
        
        if(indexPath.row < (data?.count ?? 0)){
            cell.imageView.isHidden = false
            cell.closeIcon.isHidden = false
            cell.addIcon.isHidden = true
            cell.imageView.image = self.images![indexPath.row]
            
            cell.closeIcon.isUserInteractionEnabled = true
            cell.closeIcon.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeImage(_:)))
            cell.closeIcon.addGestureRecognizer(tapGestureRecognizer)
            
        } else {
            cell.imageView.isHidden = true
            cell.closeIcon.isHidden = true
            cell.addIcon.isHidden = false
        }
        return cell
    }
    
    @objc func removeImage(_ sender: AnyObject){
        
        let alert = FotoDeleteAlert.loadViewFromNib()
        alert!.frame = self.view.bounds
        self.view.addSubview(alert!)
               
    }
    
   
    func deleteImage(_ sender: AnyObject){
    
        let row = sender.view.tag
        self.data?.remove(at: row)
        self.images?.remove(at: row)
        self.collectionView.reloadData()
    }
    
    @objc func closeFullscreen(_ sender: AnyObject){
        sender.view.removeFromSuperview()
    }
}

//MARK: - Delegate Function

extension ViewController: handleDeleteAction {
    
    func didDeleteButtonClicked(_ sender: UIButton) {
        let row = IndexPath(item: sender.tag, section: 0)
        //let row = sender.view.tag
        self.data?.remove(at: row.row)
        self.images?.remove(at: row.row)
        self.collectionView.reloadData()

    }
}

