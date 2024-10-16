//
//  PaymentSuccessView.swift
//  AstroYeti
//
//  Created by Astrotalk on 16/11/23.
//  Copyright © 2023 Puneet Gupta. All rights reserved.
//

import UIKit

class PaymentSuccessView: UIView {
   private var label: UILabel!
   private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PAYMENT\nSUCCESSFUL"
        label.textAlignment = .center
        label.textColor = kGreenColorText
        label.numberOfLines = 2
        label.font = UIFont(name:K_Poppins_Semibold, size: 30.0)
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "successIcon")
        self.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
