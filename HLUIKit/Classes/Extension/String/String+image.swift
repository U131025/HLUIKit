//
//  String+image.swift
//  Community
//
//  Created by mac on 2019/9/25.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

extension String {

    public var image: UIImage? {
        return UIImage(named: self)
    }
}
