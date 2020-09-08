//
//  UIImageExtension.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/22/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@available(iOS 13.0, *)
let reel = UIImage(named: "Reel")

/* used to download images asynchronously   */ 
// MARK: - extension to parse an image
@available(iOS 13.0, *)
extension UIImageView {
    
    func load(string: String?) {
        DispatchQueue.global().async { [weak self] in
            guard let url = string else {
                
                self?.loadImage()
                return
            }
            
            if let newURL = URL(string: url), let data = try? Data(contentsOf: newURL){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        
    }
    
    
    @available(iOS 13.0, *)
    func loadImage(){
        DispatchQueue.main.async {
            self.image = reel
        }
        
    }
}
