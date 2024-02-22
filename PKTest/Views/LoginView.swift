//
//  LoginView.swift
//  PKTest
//
//  Created by Sultan alyahya on 11/08/1445 AH.
//

import SwiftUI

struct LoginView: View {
    @State private var userName = ""
    @State private var password = ""
    @State private var isPresentingHmePage = false
    var body: some View {
        VStack{
                
            Spacer()
            Text("Login")
                .font(.title)
            TextField("Username", text: $userName)
                .frame(maxHeight: 50)
                .background(.white)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
                .padding(.horizontal, 20)
            TextField("Password", text: $password)
                .frame(maxHeight: 50)
                .background(.white)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom)
                .padding(.horizontal, 20)
                
  
            Button("Login") {
                login()
            }
            .frame(maxWidth: 100, maxHeight: 30)
            .background(Color.button)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            Spacer()
            Spacer()
        }
        .background(Color.backgroundLogin)
        .fullScreenCover(isPresented: $isPresentingHmePage) {
            HomePage(userName: userName)
        }
    }
    func login(){
        let passData = KeychainModel.load(key: "password")
        if let passData = passData{
            let pass = String(data: passData, encoding: .utf8)!
            print("old pass: \(pass)")
            if pass == password{
                isPresentingHmePage = true
            }
            return
        }
        let saveStatus = KeychainModel.save(key: "password", data: password.data(using: .utf8)!)
        isPresentingHmePage = true
        print("save status \(saveStatus)")
    }
}


#Preview {
    LoginView()
}
