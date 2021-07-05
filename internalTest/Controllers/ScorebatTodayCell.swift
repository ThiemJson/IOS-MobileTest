//
//  ScorebatTodayCell.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit

class ScorebatTodayCell: UICollectionViewCell {
    public static let identifier = "ScorebatTodayCell"
    var scorebat : ScorebatModel?{
        didSet{
            self.reload()
        }
    }
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var thumbnailImage: UIImageView! {
        didSet{
            thumbnailImage.layer.cornerRadius = thumbnailImage.frame.size.height / 9
            thumbnailImage.clipsToBounds = true
            thumbnailImage.backgroundColor = UIColor.systemGray5
        }
    }
    @IBOutlet weak var title: UILabel!{
        didSet{
            title.textColor = UIColor.systemGray3
            title.backgroundColor = UIColor.systemGray3
            title.layer.cornerRadius = 8.0
            title.clipsToBounds = true
        }
    }
    @IBOutlet weak var competiveName: UILabel!{
        didSet{
            competiveName.textColor = UIColor.systemGray3
            competiveName.backgroundColor = UIColor.systemGray3
            competiveName.layer.cornerRadius = 8.0
            competiveName.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func reload(){
        if let scorebat = self.scorebat {
            self.thumbnailImage.loadImage(with: scorebat.thumbnail, completion: { [weak self] uiImage in
                DispatchQueue.main.async{
                    self?.competiveName.text = scorebat.competition.name
                    self?.competiveName.textColor = .white
                    self?.competiveName.backgroundColor = .clear
                    
                    self?.title.text = scorebat.title
                    self?.title.textColor = .white
                    self?.title.backgroundColor = .clear
                    
                    
                    self?.thumbnailImage.image = uiImage
                    self?.thumbnailImage.backgroundColor = .clear
                    
                    self?.bottomView.layer.cornerRadius = (self?.thumbnailImage.frame.size.height)! / 9
                    
                    self?.bottomView.layer.maskedCorners = [[.layerMinXMaxYCorner, .layerMaxXMaxYCorner]]
                    
                    self?.bottomView.layer.masksToBounds =  true
                    
                    self?.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                }
            })
        }
    }
}
