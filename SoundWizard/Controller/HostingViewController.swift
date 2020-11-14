//
//  HostingViewController.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import SwiftUI

class HostingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: EQDetectiveGameplayView(level: EQDetectiveLevel.level(0)!))
        addChild(childView)
        childView.view.frame = view.frame
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }

}
