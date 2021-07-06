//
//  ScorebatNearlyCell.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit

class ScorebatNearlyCell: UITableViewCell {
    public static let identifier = "ScorebatNearlyCell"
    var scorebat : ScorebatModel?{
        didSet{
            self.reload()
        }
    }
    
    @IBOutlet weak var thumbnailImage: UIImageView! {
        didSet{
            thumbnailImage.layer.cornerRadius = thumbnailImage.frame.size.height / 9
            thumbnailImage.clipsToBounds = true
            thumbnailImage.backgroundColor = UIColor.systemGray5
        }
    }
    
    @IBOutlet weak var date: UILabel!{
        didSet{
            date.textColor = UIColor.systemGray5
            date.backgroundColor = UIColor.systemGray5
            date.layer.cornerRadius = 8.0
            date.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var title: UILabel!{
        didSet{
            title.textColor = UIColor.systemGray5
            title.backgroundColor = UIColor.systemGray5
            title.layer.cornerRadius = 8.0
            title.clipsToBounds = true
        }
    }
    
    let loadedError : UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reload(){
        if let scorebat = self.scorebat {
            self.thumbnailImage.loadImage(with: scorebat.thumbnail, completion: { [weak self] uiImage in
                DispatchQueue.main.async{
                    self?.date.text =  scorebat.date.getFormattedDate()
                    self?.date.textColor = .label
                    self?.date.backgroundColor = .clear
                    self?.date.layer.cornerRadius = 10.0
                    
                    self?.title.text = scorebat.title
                    self?.thumbnailImage.image = uiImage
                    self?.thumbnailImage.backgroundColor = .clear
                    
                    self?.title.textColor = .label
                    self?.title.backgroundColor = .clear
                    self?.title.layer.cornerRadius = 10.0
                }
            })
        }
    }
}
