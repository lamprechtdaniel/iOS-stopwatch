//
//  RoundedButton.swift
//  My First App
//
//  Created by Daniel Lamprecht on 15.04.19.
//  Copyright © 2019 Daniel Lamprecht. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = frame.size.height/2
    }

}
