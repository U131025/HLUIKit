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
    
    public func toImageWithUrlSring() -> UIImage? {
        
        if  let url = self.url, let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}

extension String {
    public var url: URL? {
        return URL(string: self)
    }
}
