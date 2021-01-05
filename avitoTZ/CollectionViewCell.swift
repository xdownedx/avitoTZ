//
//  CollectionViewCell.swift
//  avitoTZ
//
//  Created by Максим Палёхин on 02.01.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var stackForSize: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
