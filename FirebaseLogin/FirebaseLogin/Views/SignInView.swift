//
//  SignInView.swift
//  FirebaseLogin
//
//  Created by Gilda on 23/02/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var vm : FirebaseLoginViewModel
    // - user input(s):
    @State var mail: String = ""
    @State var password: String = ""
    // - to hide/show password
    @State var showPassword = false

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Spacer()
            Text("Welcome\nback!")
                .multilineTextAlignment(.leading)
                .font(.largeTitle)
                .fontWeight(.black)
            SignInFields()
            Spacer()
            Buttons()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6), ignoresSafeAreaEdges: .all)
        .navigationTitle("Back to Login")
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

/// Subviews
extension SignInView {
    // MARK: Text fields for credentials input
    @ViewBuilder
    func SignInFields() -> some View {
        VStack(alignment: .leading) {
            // - field for email input
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.caption2)
                TextField("example@mailprovider.suffix", text: $mail)
            }
            .modifier(InputField())
            .padding(.bottom, 4)
            // - field for password input
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Password")
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
    
    // MARK: Login button & sign-up page link
    @ViewBuilder
    func Buttons() -> some View {
        VStack (alignment: .center, spacing: 16) {
            Button {
                guard !mail.isEmpty, !password.isEmpty else { return }
                vm.signIn(email: mail, password: password)
                
            } label: {
                Text("Login".uppercased())
                    .modifier(OnButtonText())
            }
            .modifier(LargeButton())
            SignUpLink()
        }
    }
    @ViewBuilder
    func SignUpLink() -> some View {
        HStack {
            Text("New on the app?")
            NavigationLink("Sign-up now!", destination: SignUpView())
        }
    }
}


