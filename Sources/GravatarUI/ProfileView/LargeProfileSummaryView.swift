import Gravatar
import UIKit

public class LargeProfileSummaryView: BaseProfileView {
    private enum Constants {
        static let avatarLength: CGFloat = 132.0
        static let displayNamePlaceholderHeight: CGFloat = 32
    }

    public static var personalInfoLines: [PersonalInfoLine] {
        [
            .init([.namePronunciation, .defaultSeparator, .pronouns, .defaultSeparator, .location]),
        ]
    }

    override public var avatarLength: CGFloat {
        Constants.avatarLength
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        [avatarImageView, displayNameLabel, personalInfoLabel, profileButton, UIView.spacer()].forEach(rootStackView.addArrangedSubview)
        rootStackView.alignment = .center
        setRootStackViewSpacing()
    }
    
    private func setRootStackViewSpacing() {
        rootStackView.setCustomSpacing(.DS.Padding.double, after: avatarImageView)
        rootStackView.setCustomSpacing(0, after: displayNameLabel)
        rootStackView.setCustomSpacing(0, after: personalInfoLabel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(with model: ProfileSummaryModel?) {
        isEmpty = model == nil
        guard let model else { return }
        Configure(displayNameLabel).asDisplayName().content(model).palette(paletteType)
        Configure(personalInfoLabel).asPersonalInfo().content(model, lines: Self.personalInfoLines).palette(paletteType)
        displayNameLabel.textAlignment = .center
        personalInfoLabel.textAlignment = .center
        Configure(profileButton).asProfileButton().style(.view).palette(paletteType)
    }
    
    override public func update(with config: ProfileViewConfiguration) {
        super.update(with: config)
        update(with: config.summaryModel)
    }
    
    public override func showPlaceholders() {
        super.showPlaceholders()
        rootStackView.setCustomSpacing(.DS.Padding.split, after: displayNameLabel)
        rootStackView.setCustomSpacing(.DS.Padding.single, after: personalInfoLabel)
    }
    
    public override func hidePlaceholders() {
        super.hidePlaceholders()
        setRootStackViewSpacing()
    }
    
    override public var displayNamePlaceholderHeight: CGFloat {
        Constants.displayNamePlaceholderHeight
    }
}
