//
//  Appearance.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/14/20.
//

import SwiftUI

enum Appearance {
    static func setup() {
        UITableView.setCustomAppearance()
        UINavigationBar.setCustomAppearance()
        UITabBar.setCustomAppearance()
        UISegmentedControl.setCustomAppearance()
    }
}

extension UITableView {
    static func setCustomAppearance() {
        UITableView.appearance().backgroundColor = UIColor.clear //(Color.primaryBackground)
        UITableViewCell.appearance().backgroundColor = UIColor(Color.primaryBackground)
        
        let selectedCellView = UIView()
        selectedCellView.backgroundColor = UIColor(Color.primaryBackground.opacity(0.3))
        UITableViewCell.appearance().selectedBackgroundView = selectedCellView
        UITableViewCell.appearance().accessoryType = .none
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().tintColor = .white
    }
}

extension UINavigationBar {
    static func setCustomAppearance() {
        UINavigationBar.appearance().isTranslucent = true
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = UIColor(Color.primaryBackground.opacity(0.9))
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
        UINavigationBar.appearance().isTranslucent = true
    }
}

extension UITabBar {
    static func setCustomAppearance() {
        UITabBar.appearance().barTintColor = UIColor(Color.extraDarkGray)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray)
        UITabBar.appearance().tintColor = UIColor(Color.white)
    }
}

extension UISegmentedControl {
    static func setCustomAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.teal).withAlphaComponent(0.9)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black.withAlphaComponent(0.95)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.std(.footnote)], for: .normal)
    }
}
