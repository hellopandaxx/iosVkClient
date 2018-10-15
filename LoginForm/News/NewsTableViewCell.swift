//
//  NewsTableViewCell.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 27/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    let indents: CGFloat = 10.0
    
    @IBOutlet weak var authorImage: UIImageView! {
        didSet {
            authorImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var authorNameTxt: UILabel! {
        didSet {
            authorNameTxt.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var contentTextTxt: UILabel! {
        didSet {
            contentTextTxt.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var mainImageImg: UIImageView! {
        didSet {
            mainImageImg.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func getLabelSize(text: String, font: UIFont, maxHeight: CGFloat) -> CGSize {
        // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
        let maxWidth = bounds.width - indents * 2
        // получаем размеры блока под надпись
        // используем максимальную ширину и максимально возможную высоту
        let textBlock = CGSize(width: maxWidth, height: maxHeight)
        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options:
            .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font],
                                     context: nil)
        // получаем ширину блока, переводим ее в Double
        let width = Double(rect.size.width)
        // получаем высоту блока, переводим ее в Double
        let height = Double(rect.size.height)
        // получаем размер, при этом округляем значения до большего целого числа
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func authorImageFrame() {
        let iconSideLength: CGFloat = 50
        let iconSize = CGSize(width: iconSideLength, height:
            iconSideLength)
        let iconOrigin = CGPoint(x: indents, y : indents)
        authorImage.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    func textLabelFrame() {
        // получаем размер текста, передавая сам текст и шрифт
        let textLabelSize = getLabelSize(text: contentTextTxt.text!, font: contentTextTxt.font, maxHeight: 100)
        // рассчитываем координату по оси Х
        let timeLabelX = indents
        // рассчитываем координату по оси Y
        let timeLabelY = authorImage.frame.height + indents*2
        // получаем точку верхнего левого угла надписи
        let timeLabelOrigin = CGPoint(x: timeLabelX, y: timeLabelY)
        // получаем фрейм и устанавливаем UILabel
        contentTextTxt.frame = CGRect(origin: timeLabelOrigin, size: textLabelSize)
    }
    
    func mainImageFrame() {
        let iconSideLength: CGFloat = 130
        let iconSize = CGSize(width: iconSideLength, height:
            iconSideLength)
        let iconOrigin = CGPoint(x: indents, y : 170)
        mainImageImg.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageFrame()
        textLabelFrame()
        mainImageFrame()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
