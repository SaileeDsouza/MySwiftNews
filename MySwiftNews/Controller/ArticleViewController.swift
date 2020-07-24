//
//  ArticleViewController.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import UIKit
import SDWebImage

final class ArticleViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTextView: UITextView!
    
    //MARK:- properties
    var articleModel: ArticleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = articleModel?.title
    }
    
    //configures the UI for the view.
    private func configureUI() {
        setArticleBody()
        if isValidImageUrl(){
            let imageUrl = URL(string: (articleModel?.thumbnailUrl)!)
            articleImageView.sd_setImage(with: imageUrl, completed: nil)
        } else {
            articleImageView.isHidden = true
        }
    }
    
    //encodes the html text and converts into attributed string to be displayed in textView
    private func setArticleBody() {
        articleTextView.isUserInteractionEnabled = true
        articleTextView.dataDetectorTypes = [.link]
        articleTextView.delegate = self
        let htmlText = articleModel?.articleData?.htmlToString
        if let renderedText = htmlText?.htmlToAttributedString {
            renderedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)], range: NSRange(fullRangeOf: renderedText.string))
            articleTextView.attributedText = renderedText
        }
    }
    
    //checks if thumbnail image is valid and can open as URL
    private func isValidImageUrl() -> Bool {
        guard let thumbnailUrl = articleModel?.thumbnailUrl else { return false }
        if let imageUrl = URL(string: thumbnailUrl), UIApplication.shared.canOpenURL(imageUrl) {
            return true
        } else {
            print("Invalid thumbnail Url")
            return false
        }
    }
}

//MARK:- TextView Delegate
extension ArticleViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
