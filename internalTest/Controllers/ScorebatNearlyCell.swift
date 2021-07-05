//
//  ScorebatNearlyCell.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit

class ScorebatNearlyCell: UITableViewCell {
    public static let identifier = "ScorebatNearlyCell"
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
