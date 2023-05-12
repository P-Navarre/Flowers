//
//  Flowers
//
//  Pierre Navarre
//

import UIKit
import CustomViews
import FlowerCategoryData
import FlowerItemData

@MainActor
protocol DetailViewControllerInput: AnyObject {
    func showContent(_ model: DetailViewModel)
}

public final class DetailViewController: UIViewController {
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let imageHeight: CGFloat = 250
        static let verticalMargin: CGFloat = 12 // Between image and stackView
        static let stackViewVerticaleSpace : CGFloat = 8
        static let lineHorizontalSpace: CGFloat = 4
    }
    
    // MARK: - Properties
    private let content: (item: FlowerItem, category: String?)
    private var presenter: DetailViewPresenterInput?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: ImageView = ImageView(frame: .zero)
    private let categoryLabel: UILabel = UILabel()
    private let idLabel: UILabel = UILabel()
    private let titleLabel: UILabel = UILabel()
    private let descriptiontLabel: UILabel = UILabel()
    
    public init(item: FlowerItem, category: String?) {
        self.content = (item, category)
        super.init(nibName: nil, bundle: nil)
        self.presenter = DetailViewPresenter(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.willAppear(for: self.content.item, category: self.content.category)
    }
    
}

// MARK: - UI configuration
private extension DetailViewController {
    func configureUI() {
        self.scrollView.frame = self.view.bounds
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.backgroundColor = .systemBackground
        self.view.addSubview(self.scrollView)
        
        self.layoutImageView()
        self.layoutStackView()
    }
    
    func layoutImageView() {
        let background = UIView() // A background view for image, with backgroundColor
        background.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(background)
        background.backgroundColor = .systemGray6
        
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            background.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            background.topAnchor.constraint(equalTo: self.imageView.topAnchor),
            background.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            
            // scrollView contentSize width
            background.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            background.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            
            self.imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.imageView.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor)
        ])
    }
    
    func layoutStackView() {
        var rows: [UIView] {[
            self.idLabel,
            self.categoryLabel,
            self.titleLabel,
            self.descriptiontLabel
        ]}
        
        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.spacing = Constants.stackViewVerticaleSpace
        
        self.scrollView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Constants.verticalMargin),
            stack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.horizontalMargin),
            stack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.horizontalMargin),
            stack.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
        
        self.idLabel.textAlignment = .right
        self.idLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.idLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.titleLabel.numberOfLines = 0
        self.descriptiontLabel.numberOfLines = 0
    }
    
}

// MARK: - DetailViewControllerInput
extension DetailViewController: DetailViewControllerInput {
    func showContent(_ model: DetailViewModel) {
        self.imageView.placeHolder = model.placeHolder.image
        Task { await self.imageView.loadImage(from: model.imageUrl) }
        self.categoryLabel.attributedText = model.category
        self.idLabel.attributedText = model.id
        self.titleLabel.attributedText = model.title
        self.descriptiontLabel.attributedText = model.description
    }
}
