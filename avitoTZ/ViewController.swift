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
    // MARK: Parsing data from file
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
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
    // MARK: setup ui
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
    fileprivate func setupViewController() {
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
        
        let json = readLocalFile(forName: "result")!
        product = parse(jsonData: json)
        setupViewController()
        setupCollectionView()
    }
    // MARK: CollectionView method

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var i = 0
        for cell in product!.result.list{
            if !(cell.isSelected){
                product?.result.list.remove(at: i)
                i-=1
            }
            i+=1

        }
        return product!.result.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 5
        cell.title.text = product!.result.list[indexPath.row].title
        if product!.result.list[indexPath.row].description == nil{
            cell.descript.isHidden = true
        } else {
            cell.descript.text = product!.result.list[indexPath.row].description

        }
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
        return CGSize(width: Int(view.bounds.width)-40, height: heightForCell(title: product!.result.list[indexPath.row].title, description: product!.result.list[indexPath.row].description ?? "", price: product!.result.list[indexPath.row].price))
    }
    //function for height
    func heightForCell(title: String, description: String, price: String) -> Int {
        var heightTitle = (title.count/21)
        if title.count%21 > 0{
            heightTitle+=1
        }
        var heightDescription = (description.count/42)
        if description.count%42 > 0{
            heightDescription+=1
        }
        return heightTitle*25 + heightDescription*17 + 70
    }
    // MARK: Action Button
    @objc func buttonAction(sender: UIButton!) {
        for cell in collectionView!.visibleCells{
            let cellDublicate = cell as! CollectionViewCell
            if !(cellDublicate.checkmark.isHidden){
                let alertVC = UIAlertController(
                    title: "Выбрана услуга",
                    message: "Название услуги:"+cellDublicate.title.text!,
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
                break
            }
        }
        let alertVC = UIAlertController(
            title: "Услуга не выбрана",
            message: "Выбрано продолжение без изменений",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
