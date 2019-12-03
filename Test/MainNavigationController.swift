//
//  MainNavigationController.swift
//  DonetDoctor
//
//  Created by Pankaj Kumar on 21/02/18.
//  Copyright © 2018 GreyChain. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationBar.setBackgroundImage(UIColor(named: "Themecolor")!.as1ptImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
