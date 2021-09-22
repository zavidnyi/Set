//
//  SnakeEffect.swift
//  Set
//
//  Created by Ilya Zavidny on 22.09.2021.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}


extension View {
    func shakeEffect(withForce data: CGFloat) -> some View {
        self.modifier(ShakeEffect(animatableData: data))
    }
}
