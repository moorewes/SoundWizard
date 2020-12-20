//
//  Appearance.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/14/20.
//

import SwiftUI

struct Appearance {
    
    static func setup() {
        UITableView.setCustomAppearance()
        UINavigationBar.setCustomAppearance()
        UITabBar.setCustomAppearance()
        UISegmentedControl.setCustomAppearance()
    }
    
    private init() {}
    
}

extension UITableView {
    
    static func setCustomAppearance() {
        UITableView.appearance().backgroundColor = UIColor(Color.darkBackground)
        UITableViewCell.appearance().backgroundColor = UIColor(Color.darkBackground)
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().tintColor = .white
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
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .font: UIFont.std(.headline),
            .foregroundColor: UIColor(Color.lightGray)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.systemTeal
    }
    
}

extension UITabBar {
    
    static func setCustomAppearance() {
        UITabBar.appearance().barTintColor = UIColor(Color.darkBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        UITabBar.appearance().tintColor = UIColor(Color.teal)
    }
    
}

extension UISegmentedControl {
    
    // TODO: Unselected segment text color changes with dark/light mode changes
    static func setCustomAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black.withAlphaComponent(0.95)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.std(.subheadline)], for: .normal)
    }
    
}
