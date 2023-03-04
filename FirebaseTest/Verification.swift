//
//  Verification.swift
//  FirebaseTest
//
//  Created by Gilda on 23/02/23.
//

import SwiftUI

struct Verification: View {
    
    var body: some View {
        NavigationView {
            VStack {
                OTPField()
                    .padding(.vertical)
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Verification")
        }
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        Verification()
    }
}

