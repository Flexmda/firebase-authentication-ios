//
//  ContentView.swift
//  FirebaseLogin
//
//  Created by Gilda on 23/02/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm : FirebaseLoginViewModel
    
    var body: some View {
        NavigationView {
            if vm.signedIn {
                VStack(spacing: 32){
                    /// Put here your app main view for logged users!
                    Text("You are now\nsigned in!")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    /// Providing the 'logout' button
                    Button {
                        vm.signOut()
                    } label: {
                        Text("Logout".uppercased())
                            .modifier(OnButtonText())
                    }
                    .modifier(LargeButton())
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray6), ignoresSafeAreaEdges: .all)
            } else {
                SignInView()
            }
        }
        .tint(.orange)
        .onAppear{
            vm.signedIn = vm.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirebaseLoginViewModel())
    }
}
