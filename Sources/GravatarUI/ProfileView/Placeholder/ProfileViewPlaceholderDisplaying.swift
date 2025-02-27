import UIKit

/// Defines the interactions for showing/hiding placeholder state of the `BaseProfileView`. Placeholder state is defined as the state of `BaseProfileView` when
/// all the fields are empty.
@MainActor
public protocol ProfileViewPlaceholderDisplaying {
    func showPlaceholder(on view: BaseProfileView)
    func hidePlaceholder(on view: BaseProfileView)
    func setup(using view: BaseProfileView)
    func refresh(with placeholderColors: PlaceholderColors)
}

/// ProfileViewPlaceholderDisplayer can convert each element of `BaseProfileView` into a placeholder and revert back.
@MainActor
class ProfileViewPlaceholderDisplayer: ProfileViewPlaceholderDisplaying {
    var elements: [PlaceholderDisplaying]?
    var isShowing: Bool = false

    func setup(using view: BaseProfileView) {
        let color = view.placeholderColors.backgroundColor
        elements = [
            BackgroundColorPlaceholderDisplayer<UIImageView>(
                baseView: view.avatarImageView, color: color, originalBackgroundColor: .clear
            ),
            LabelPlaceholderDisplayer(
                baseView: view.aboutMeLabel,
                color: color,
                cornerRadius: 8,
                height: 14,
                widthRatioToParent: 0.8
            ),
            LabelPlaceholderDisplayer(
                baseView: view.aboutMePlaceholderLabel,
                color: color,
                cornerRadius: 8,
                height: 14,
                widthRatioToParent: 0.6,
                isTemporary: true
            ),
            LabelPlaceholderDisplayer(
                baseView: view.displayNameLabel,
                color: color,
                cornerRadius: view.displayNamePlaceholderHeight / 2,
                height: view.displayNamePlaceholderHeight,
                widthRatioToParent: 0.6
            ),
            LabelPlaceholderDisplayer(
                baseView: view.personalInfoLabel,
                color: color,
                cornerRadius: 8,
                height: 14,
                widthRatioToParent: 0.8
            ),
            ProfileButtonPlaceholderDisplayer(
                baseView: view.profileButton,
                color: color,
                cornerRadius: 8,
                height: 16,
                widthRatioToParent: 0.2
            ),
            AccountButtonsPlaceholderDisplayer(
                containerStackView: view.accountButtonsStackView,
                color: color
            ),
        ]
    }

    func showPlaceholder(on view: BaseProfileView) {
        isShowing = true
        elements?.forEach { $0.showPlaceholder() }
    }

    func hidePlaceholder(on view: BaseProfileView) {
        isShowing = false
        elements?.forEach { $0.hidePlaceholder() }
    }

    func refresh(with placeholderColors: PlaceholderColors) {
        guard let elements else { return }
        for var element in elements {
            element.placeholderColor = placeholderColors.backgroundColor
            if isShowing {
                element.set(viewColor: placeholderColors.backgroundColor)
            }
        }
    }
}
