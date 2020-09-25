internal enum FontType {
    case titiliumWebRegular
    case titiliumWebBold
    case titiliumWebMedium
}

internal extension UIFont {

    static func font(type: FontType, size: CGFloat) -> UIFont? {
        switch type {
        case .titiliumWebRegular:
            return UIFont(name: "Roboto-Regular", size: size)
        case .titiliumWebBold:
            return UIFont(name: "Roboto-Bold", size: size)
        case .titiliumWebMedium:
            return UIFont(name: "Roboto-Medium", size: size)
        }
    }

    static func mainFont(ofSize size: CGFloat) -> UIFont {
        return font(type: .titiliumWebMedium, size: size)!
    }

    private func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
}
