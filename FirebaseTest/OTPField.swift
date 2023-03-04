//
//  OTPField.swift
//  FirebaseTest
//
//  Created by Gilda on 23/02/23.
//

import SwiftUI

struct OTPField: View {
    
    @StateObject var otpVM = OTPViewModel()
    @FocusState var activeField : OTPFieldState?
    
    var body: some View {
        HStack(spacing: 14) {
            ForEach(0..<6, id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $otpVM.otpField[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ?
                            .blue : .gray.opacity(0.3))
                        .frame(height: 4)
                }
                .frame(width: 44)
            }
        }
    }
    
    func activeStateForIndex(index: Int) -> OTPFieldState {
        
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        case 5: return .field6
        default: return .field6
        }
    }
}

struct OTPField_Previews: PreviewProvider {
    static var previews: some View {
        OTPField()
    }
}
