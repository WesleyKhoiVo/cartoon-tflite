import UIKit

struct Font {

    static var title: UIFont { with(size: .extraLarge) }
    
    static var subtitle: UIFont { with(size: .medium) }
    
    static var paragraph: UIFont { with(size: .small) }

    static var small: UIFont { with(size: .extraSmall) }
    
    enum Size: CGFloat {
        case extraLarge = 80.0
        case large = 64.0
        case medium = 32.0
        case small = 23.0
        case extraSmall = 17.0
        case mini = 12.0
    }
    
    private struct Constants {
        static let name = "SF Pro"
    }
    
    static func with(size: Size) -> UIFont {
        return UIFont(name: Constants.name, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    
}
