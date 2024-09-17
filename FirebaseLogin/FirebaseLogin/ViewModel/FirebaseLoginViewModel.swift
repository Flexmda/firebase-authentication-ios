//
//  FirebaseLoginViewModel.swift
//  FirebaseLogin
//
//  Created by Gilda on 23/02/23.
//

import Foundation
import FirebaseAuth


class FirebaseLoginViewModel : ObservableObject {
    @Published var signedIn = false
    
    let auth = Auth.auth()
    
    // MARK: Utility variable to check user status (
    /// - returns:  true if already logged; false if not logged yet
    var isSignedIn : Bool {
        return auth.currentUser != nil
    }
    
    // MARK: Sign-in function
    ///  - parameters: a String object for email, a String object for password
    func signIn(email: String, password: String) {
        // Firebase provides its own sign-in methods with different login options
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            // result check:
            DispatchQueue.main.async {
                // SUCCESS:
                self?.signedIn = true
            }
        }
    }
    
    // MARK: Sign-in function
    ///  - parameters: a String object for email, a String object for password
    func signUp(email: String, password: String) {
        // Firebase provides its own sign-up methods with different registration options
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
                guard result != nil, error == nil else { return }
            // result check:
            DispatchQueue.main.async {
                // SUCCESS:
                self?.signedIn = true
            }
        }
    }
    
    // MARK: Sign-out
    func signOut() {
        // Firebase provides its own sign-out method
        try? auth.signOut()
        // SUCCESS:
        self.signedIn = false
    }
}
