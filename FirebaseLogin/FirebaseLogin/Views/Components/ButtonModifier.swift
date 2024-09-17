//
//  ButtonModifier.swift
//  FirebaseLogin
//
//  Created by Gilda on 04/03/23.
//

import SwiftUI

/// -> customise your buttons
///
struct LargeButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(.orange)
            .foregroundColor(.white)
            .cornerRadius(13)
    }
}
///
struct OnButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
    }
}


