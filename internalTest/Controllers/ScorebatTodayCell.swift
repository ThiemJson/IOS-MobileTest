//
//  ScorebatTodayCell.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit

class ScorebatTodayCell: UICollectionViewCell {
    public static let identifier = "ScorebatTodayCell"
    
    @IBOutlet weak var thumnailImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var competiveName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
