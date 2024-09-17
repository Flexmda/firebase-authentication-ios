//
//  SignInView.swift
//  FirebaseLogin
//
//  Created by Gilda on 23/02/23.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var vm : FirebaseLoginViewModel
    // - user input(s):
    @State var mail: String = ""
    @State var password: String = ""
    // - to hide/show password
    @State var showPassword = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 32) {
            Spacer()
            Text("Regístrate\nmi amor!")
                .multilineTextAlignment(.trailing)
                .font(.largeTitle)
                .fontWeight(.black)
            SignUpFields()
            Spacer()
            SignUpButton()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6), ignoresSafeAreaEdges: .all)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

/// Subviews
extension SignUpView {
    // MARK: Text fields for credentials input
    @ViewBuilder
    func SignUpFields() -> some View {
        VStack(alignment: .leading) {
            // - field for email input
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.caption2)
                TextField("aquivasucorreo.com", text: $mail)
            }
            .modifier(InputField())
            .padding(.bottom, 4)
            // - field for password input
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Su contraseña")
                            .font(.caption2)
                        if showPassword {
                            // * show password
                            TextField("...", text: $password)
                        } else {
                            // * hide password
                            SecureField("...", text: $password)
                        }
                    }
                    Button {
                        self.showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                    }
                }
            }
            .modifier(InputField())
        }
    }
    
    // MARK: Sign-up button
    @ViewBuilder
    func SignUpButton() -> some View {
        VStack (alignment: .center, spacing: 16) {
            Button {
                guard !mail.isEmpty, !password.isEmpty else { return }
                vm.signUp(email: mail, password: password)
                
            } label: {
                Text("Crear una cuenta".uppercased())
                    .modifier(OnButtonText())
            }
            .modifier(LargeButton())
        }
    }
}

