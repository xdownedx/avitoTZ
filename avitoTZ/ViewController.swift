//
//  ViewController.swift
//  avitoTZ
//
//  Created by Максим Палёхин on 02.01.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView?
    var button: UIButton?
    var product: data?
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: "result",
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf16) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    private func parse(jsonData: Data)->data? {
        do {
            let decodedData = try JSONDecoder().decode(data.self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    fileprivate func setupCollectionView() {
            collectionView = UICollectionView(frame: CGRect(x: 0, y: 185, width: view.bounds.width, height: view.bounds.height-305), collectionViewLayout: UICollectionViewFlowLayout())
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.backgroundColor = .white
            collectionView?.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CellID")
            view.addSubview(collectionView!)
            collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }
    fileprivate func setupButton() {
        button = UIButton(frame: CGRect(x: 20, y: view.bounds.height-70, width: view.bounds.width-40, height: 50))
        button?.backgroundColor = .blue
        button?.setTitle(product!.result.actionTitle, for: .normal)
        button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button?.layer.cornerRadius = 5
        button?.backgroundColor = #colorLiteral(red: 0.2392938435, green: 0.6638772488, blue: 0.9710217118, alpha: 1)
        self.view.addSubview(button!)
        let buttonClose = UIButton(frame: CGRect(x: 20, y: 30, width:25, height: 25))
        buttonClose.setImage(UIImage(named: "CloseIconTemplate"), for: .normal)
        buttonClose.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
        buttonClose.contentMode = .scaleAspectFit
        self.view.addSubview(buttonClose)
        let title = UILabel(frame: CGRect(x: 20, y: 70, width: view.bounds.width-40, height: 75))
        title.text = product!.result.title
        title.numberOfLines = 0
        title.font = UIFont(name: "AvertaCY-Bold", size: 26)
        self.view.addSubview(title)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        var json = readLocalFile(forName: "result")!
        product = parse(jsonData: json)

        setupButton()
        setupCollectionView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 5
        cell.title.text = product!.result.list[indexPath.row].title
        cell.descript.text = product!.result.list[indexPath.row].description
        cell.price.text = product!.result.list[indexPath.row].price
        cell.checkmark.isHidden=true
        let url = NSURL(string:  product!.result.list[indexPath.row].icon["52x52"]!)
        let data = try? Data(contentsOf: url! as URL)
        cell.icon.image = UIImage(data: data!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.checkmark.isHidden = !(cell.checkmark.isHidden)
            if !(cell.checkmark.isHidden){
                button?.setTitle(product!.result.selectedActionTitle, for: .normal)
            }else{
                button?.setTitle(product!.result.actionTitle, for: .normal)
            }
            
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.checkmark.isHidden = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width-40, height: 170)
    }
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }
}

