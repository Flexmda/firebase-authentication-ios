import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseLoginViewModel: ObservableObject {
    @Published var signedIn = false

    let auth = Auth.auth()
    let db = Firestore.firestore()

    // Verificar si el usuario está autenticado
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    // Escuchar el estado de autenticación
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.signedIn = true
                self?.createOrUpdateUserInFirestore(user: user)  // Crear o actualizar datos en Firestore
            } else {
                self?.signedIn = false
            }
        }
    }

    // Crear o actualizar el documento del usuario en Firestore
    private func createOrUpdateUserInFirestore(user: User) {
        let userDoc = db.collection("users").document(user.uid)

        userDoc.getDocument { document, error in
            if let document = document, document.exists {
                print("Documento de usuario ya existe.")
                // Aquí puedes cargar otros datos si deseas
            } else {
                // Si el documento no existe, crearlo con los datos de FirebaseAuth
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "name": user.displayName ?? "",
                    "email": user.email ?? "",
                    "createdAt": Timestamp(date: Date())
                ]

                userDoc.setData(userData) { error in
                    if let error = error {
                        print("Error al crear el documento de usuario: \(error.localizedDescription)")
                    } else {
                        print("Documento de usuario creado correctamente.")
                    }
                }
            }
        }
    }

    // Función para registrar un usuario
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error al registrarse: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }

            guard let user = authResult?.user else {
                completion(false, "Error desconocido")
                return
            }

            self.createOrUpdateUserInFirestore(user: user)
            completion(true, nil)
        }
    }

    // Función para iniciar sesión
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Error al iniciar sesión: \(error.localizedDescription)")
                return
            }

            if let user = result?.user {
                self?.createOrUpdateUserInFirestore(user: user)
            }

            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }

    // Función para cerrar sesión
    func signOut() {
        do {
            try auth.signOut()
            self.signedIn = false
        } catch {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }
}

