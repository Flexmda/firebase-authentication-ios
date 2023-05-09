//
//  TextFieldModifier.swift
//  FirebaseLogin
//
//  Created by Gilda on 04/03/23.
//

import SwiftUI

/// -> customise your text fields for user input(s)
/// 
struct InputField: ViewModifier {
    // To detect system color scheme:
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .padding()
            .frame(maxWidth: .infinity)
        // Providing light and dark mode variants using system colors:
            .background(colorScheme == .light ? .black.opacity(0.06) : .white.opacity(0.1))
            .cornerRadius(13)

    }
}

