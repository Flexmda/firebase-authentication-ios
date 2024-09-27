import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var vm: FirebaseLoginViewModel
    // - user input(s):
    @State var mail: String = ""
    @State var password: String = ""
    // - to hide/show password
    @State var showPassword = false
    // - control para mostrar alertas
    @State private var showAlert = false
    @State private var alertMessage = ""

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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registro"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
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
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
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
                                .autocapitalization(.none)
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
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
    }
    
    // MARK: Sign-up button
    @ViewBuilder
    func SignUpButton() -> some View {
        VStack(alignment: .center, spacing: 16) {
            Button {
                guard !mail.isEmpty, !password.isEmpty else {
                    alertMessage = "Por favor ingresa todos los campos."
                    showAlert = true
                    return
                }
                vm.signUp(email: mail, password: password) { success, errorMessage in
                    if success {
                        alertMessage = "Registro exitoso"
                        showAlert = true
                    } else {
                        alertMessage = errorMessage ?? "Ocurrió un error al registrarse."
                        showAlert = true
                    }
                }
            } label: {
                Text("Crear una cuenta".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

