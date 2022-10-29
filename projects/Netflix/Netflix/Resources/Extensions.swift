//
//  Extensions.swift
//  Netflix
//
//  Created by Vladislavs on 29/10/2022.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
