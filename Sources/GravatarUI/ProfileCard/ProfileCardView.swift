import Gravatar
import UIKit

public protocol ProfileCardModel: AboutMeModel, DisplayNameModel, PersonalInfoModel, AvatarIdentifierProvider {}
extension UserProfile: ProfileCardModel {}

public class ProfileCardView: UIView, UIContentView {
    private enum Constants {
        static let avatarLength: CGFloat = 132.0
    }

    public private(set) lazy var rootStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, displayNameLabel, personalInfoLabel, aboutMeLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .DS.Padding.single
        stack.setCustomSpacing(.DS.Padding.double, after: avatarImageView)
        stack.setCustomSpacing(0, after: displayNameLabel)
        stack.alignment = .leading
        return stack
    }()

    public private(set) lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: Constants.avatarLength).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.avatarLength).isActive = true
        imageView.layer.cornerRadius = Constants.avatarLength / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    public private(set) lazy var aboutMeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    public private(set) lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    public private(set) lazy var personalInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    public let containerLayoutGuide = UILayoutGuide()
    public var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    public struct Configuration: UIContentConfiguration {
        public func updated(for state: UIConfigurationState) -> ProfileCardView.Configuration {
            self
        }

        var paletteType: PaletteType
        var model: ProfileCardModel?

        public init(paletteType: PaletteType, model: ProfileCardModel? = nil) {
            self.paletteType = paletteType
            self.model = model
        }

        public func makeContentView() -> UIView & UIContentView {
            ProfileCardView(self)
        }
    }

    override public init(frame: CGRect) {
        self.configuration = Configuration(paletteType: .system)
        super.init(frame: frame)
        addSubview(rootStackView)
        addLayoutGuide(containerLayoutGuide)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: containerLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: containerLayoutGuide.bottomAnchor),
            topAnchor.constraint(equalTo: rootStackView.topAnchor),
            leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: rootStackView.bottomAnchor),
        ])
    }

    public convenience init(_ configuration: ProfileCardView.Configuration) {
        self.init(frame: .zero)
        self.configuration = configuration
        refresh(with: configuration.paletteType)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadAvatar(
        with avatarIdentifier: AvatarIdentifier,
        placeholder: UIImage? = nil,
        rating: Rating? = nil,
        preferredSize: CGSize? = nil,
        defaultAvatarOption: DefaultAvatarOption? = nil,
        options: [ImageSettingOption]? = nil,
        completionHandler: ImageSetCompletion? = nil
    ) {
        avatarImageView.gravatar.setImage(
            avatarID: avatarIdentifier,
            placeholder: placeholder,
            rating: rating,
            preferredSize: preferredSize ?? CGSize(width: Constants.avatarLength, height: Constants.avatarLength),
            defaultAvatarOption: defaultAvatarOption,
            options: options
        ) { [weak self] result in
            switch result {
            case .success:
                guard let configuration = self?.configuration as? Configuration else { return }
                self?.avatarImageView.layer.borderColor = configuration.paletteType.palette.avatarBorder.cgColor
                self?.avatarImageView.layer.borderWidth = 1
            default:
                self?.avatarImageView.layer.borderColor = UIColor.clear.cgColor
            }
            completionHandler?(result)
        }
    }

    private func refresh(with paletteType: PaletteType) {
        avatarImageView.layer.borderColor = paletteType.palette.avatarBorder.cgColor
        backgroundColor = paletteType.palette.background.primary
        Configure(aboutMeLabel).asAboutMe().palette(paletteType)
        Configure(displayNameLabel).asDisplayName().palette(paletteType)
        Configure(personalInfoLabel).asPersonalInfo().palette(paletteType)
    }

    private func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        if let model = configuration.model {
            Configure(aboutMeLabel).asAboutMe().content(model)
            Configure(displayNameLabel).asDisplayName().content(model)
            Configure(personalInfoLabel).asPersonalInfo().content(model)
        }
        refresh(with: configuration.paletteType)
    }
}
