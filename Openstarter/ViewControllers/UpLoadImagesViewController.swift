//
//  UpLoadImagesViewController.swift
//  Openstarter
//
//  Created by tarek on 10/04/2018.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit

class UpLoadImagesViewController: UIViewController {
    
   fileprivate let cellIdentifier = "PhotoViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var maw: UIImage?
    lazy var addButton : UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        return button
    }()
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        images = Array.init(repeating: #imageLiteral(resourceName: "photo"), count: 2)
        navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        collectionView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
         print("jjjjjjj")
    }
    var pickerImage: UIImage? {
        didSet{
            //kkkkkkk
        }
    }
    
    @objc private func addImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        //picker.present(picker, animated: false, completion: nil)
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}

extension UpLoadImagesViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageEdited = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.pickerImage = imageEdited
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
           self.pickerImage=originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UpLoadImagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as?PhotoViewCell else {print("erreuuuur")
            return UICollectionViewCell()
        }
        cell.iv.image = images[indexPath.row]
       
        
        return cell
    }
}
extension UpLoadImagesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWith = UIScreen.main.bounds.width
        let width = (screenWith-40)/2
        return CGSize.init(width: width, height: width)
    }
}
