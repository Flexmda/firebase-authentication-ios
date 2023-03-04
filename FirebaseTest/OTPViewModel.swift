//
//  OTPViewModel.swift
//  FirebaseTest
//
//  Created by Gilda on 23/02/23.
//

import SwiftUI

class OTPViewModel: ObservableObject {

    @Published var otpText : String = ""
    @Published var otpField : [String] = Array(repeating: "", count: 6)
    
    
}
