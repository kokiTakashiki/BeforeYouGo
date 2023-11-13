//
//  VisualEffect.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/09.
//

import SwiftUI

struct VisualEffect: UIViewRepresentable {
    @State var style : UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.layer.cornerRadius = 25
        view.layer.opacity = 0.8
        view.clipsToBounds = true
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
