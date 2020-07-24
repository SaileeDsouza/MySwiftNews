//
//  NewsTableViewCell.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import UIKit
import SDWebImage

final class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbnailImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.selectionStyle = .default
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
    }
    
    //configure the cell to display appropriate title and image
    func configureCell(with model: ArticleModel) {
        titleLabel.text = model.title
        imageHeight.constant = CGFloat(model.thumbnail_height)
        if let imageUrl = URL(string: model.thumbnailUrl ?? "") {
            thumbnailImage.isHidden = false
            thumbnailImage.sd_setImage(with: imageUrl, completed: nil)
        } else {
            thumbnailImage.isHidden = true
        }
    }
    
}
