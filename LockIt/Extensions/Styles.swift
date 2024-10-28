import UIKit

class Styles {
    
    //  MARK: - Buttons
    enum Buttons {
        enum MainButton {
            static let height: CGFloat = 44
            static let controlSettings: ControlSettings = ControlSettings(
                font: UIFont.makeAvenir(size: 27,weight: .semibold),
                titleColor: .white,
                backgroundColor: UIColor(named: R.color.color_main.name))
        }
        enum NavigationBarText {
            static let controlSettings: ControlSettings = ControlSettings(
                font: UIFont.makeAvenir(size: 16,weight: .semibold),
                titleColor: UIColor(named: R.color.color_main.name),
                backgroundColor: UIColor.clear)
        }
        enum NextPrevievsText {
            static let controlSettings: ControlSettings = ControlSettings(
                font: UIFont.makeAvenir(size: 16,weight: .semibold),
                titleColor: UIColor(named: R.color.color_main.name),
                backgroundColor: UIColor.white.withAlphaComponent(0.06))
        }
        
    }
    
    enum Typography {
        enum Titles {
            
            enum Title27 {
                static let title: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 27,weight: .semibold),
                    titleColor: .white)
            }
            
            enum Title22 {
                static let title: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 22,weight: .semibold),
                    titleColor: .white)
            }
            
            enum Title22_Light {
                static let title: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 32,weight: .light),
                    titleColor: .white.withAlphaComponent(0.9))
            }
            
            enum Title18 {
                static let title: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 18, weight: .semibold),
                    titleColor: UIColor.white
                )
            }
            
            enum Title16 {
                static let title: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 16, weight: .semibold),
                    titleColor: UIColor(named: R.color.color_main.name)
                )
            }
            enum Title16_white {
                static let title: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 16, weight: .semibold),
                    titleColor: UIColor.white
                )
            }
        }
        
        
        // MARK: - Texts
        enum Texts {

            enum Text14 {
                static let text: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 14, weight: .regular),
                    titleColor: UIColor(named: R.color.color_gray40.name)
                )
            }
            enum Text12 {
                static let text: ControlSettings = ControlSettings(
                    font: UIFont.makeAvenir(size: 12, weight: .regular),
                    titleColor: UIColor(named: R.color.color_gray50.name)
                )
            }
        }
    }
    
    enum Error {
        enum Text13 {
            static let text: ControlSettings = ControlSettings(
                font: UIFont.makeAvenir(size: 14, weight: .medium),
                titleColor: UIColor(named: R.color.color_red.name)
            )
        }
    }
    
    enum Button {
        enum Second {
            enum Small {
                static let normal: ControlSettings = ControlSettings (
                    font: UIFont.makeAvenir(size: 16,weight: .semibold),
                    titleColor: .white)
            }
        }
    }
}

