//
//  Flowers
//
//  Pierre Navarre
//

import UIKit
import CustomViews
import Style

class FlowerItemCell: UICollectionViewCell {
    static let ReuseIdentifier: String = "FlowerItemCell"
    
    static var cellHeight: CGFloat {
        Constants.imageY + Constants.imageSize + Constants.margin
    }
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let topMargin: CGFloat = 4
        static let margin: CGFloat = 8 // other margins for contentView
        static let imageY: CGFloat = 28
        static let imageSize: CGFloat = 140
        static let horizontalSpace: CGFloat = 16 // between image and title
    }
    
    private weak var imageView: ImageView?
    private weak var categoryLabel: UILabel?
    private weak var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let category = UILabel()
        self.contentView.addSubview(category)
        category.translatesAutoresizingMaskIntoConstraints = false
        self.categoryLabel = category
        
        let imageView = ImageView(
            frame: CGRect(
                origin: CGPoint(x: Constants.margin, y: Constants.imageY),
                size: CGSize(width: Constants.imageSize, height: Constants.imageSize)
            )
        )
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        self.imageView = imageView
        
        let title = UILabel()
        title.numberOfLines = 0
        title.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        self.contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel = title
        
        NSLayoutConstraint.activate([
            category.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constants.margin),
            category.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constants.margin),
            category.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.topMargin),
            
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.horizontalSpace),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constants.margin),
            title.topAnchor.constraint(equalTo: imageView.topAnchor),
        ])
        
        self.contentView.backgroundColor = Color.itemCellBackground.color
        self.contentView.layer.cornerRadius = Constants.cornerRadius
    }
    
    func update(with model: FlowerItemCellModel) {
        self.imageView?.placeHolder = model.placeHolder.image
        Task { await self.imageView?.loadImage(from: model.imageUrl) }
        self.categoryLabel?.attributedText = model.category
        self.titleLabel?.attributedText = model.title
    }
    
}
