//
//  Extensions.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import SwiftUI

extension UserDefaults {
    
    func optionalBool(forKey defaultsName: String) -> Bool? {
        if let value = value(forKey: defaultsName) {
            return value as? Bool
        } else {
            return nil
        }
    }
    
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Float {
    var uiString: String {
        let isInt = self - Float(Int(self)) == 0
        return isInt ? "\(Int(self))" : String(format: "%.1f", self)
    }
    
    
}

extension Array {
    var centerItem: Element? {
        guard self.count > 0 else { return nil }
        let index = self.count / 2
        return self[index]
    }
}


extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

extension Numeric where Self: CVarArg {
    func scoreString(digits: Int) -> String {
        return String(format: "%0\(digits)d", self)
    }
}

extension UITableView {
    static func setCustomAppearance() {
        UITableView.appearance().backgroundColor = UIColor(Color.darkBackground)
        UITableViewCell.appearance().backgroundColor = UIColor(Color.darkBackground)
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().tintColor = .white
        UITableViewCell.appearance()
    }
}

extension UINavigationBar {
    static func setCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(Color.darkBackground)
        appearance.titleTextAttributes = [
            .font: UIFont.std(.headline),
            .foregroundColor: UIColor(Color.lightGray)
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.std(.largeTitle),
            .foregroundColor: UIColor(Color.teal)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        //UINavigationBar.appearance().tintColor = UIColor.systemTeal
    }
}
