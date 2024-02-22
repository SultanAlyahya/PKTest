//
//  HomePage.swift
//  PKTest
//
//  Created by Sultan alyahya on 11/08/1445 AH.
//

import SwiftUI

struct HomePage: View {
    let userName: String
    @StateObject var webSocket = WebSocketModel()
    @State var msg = ""
    @State var recivedMsg = ""
    @State private var navPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navPath){
            VStack{
                HStack{
                    Text("Hello, \(userName)")
                        .foregroundStyle(.white)
                        .font(.title)
                    Spacer()
                    Button("User list") {
                        print("go to users list")
                        navPath.append(HomePagePaths.users)
                    }
                    .frame(maxWidth: 100, maxHeight: 30)
                    .background(.white)
                    .foregroundStyle(.button)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                }
                .padding()
                .background(.button)
                Spacer()
                VStack{
                    if webSocket.isConnected{
                        VStack(alignment: .center){
                            Text(webSocket.msgStatus)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("\(webSocket.recivedMeg)")
                        }
                    }
                    if !webSocket.isConnected {
                        Button("Connect") {
                            print("connect")
                            webSocket.connect()
                        }
                        .frame(maxWidth: 120, maxHeight: 45)
                        .background(.button)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }else {
                        Button("Diconnect") {
                            print("Diconnect")
                            webSocket.disconnect()
                        }
                        .frame(maxWidth: 120, maxHeight: 45)
                        .background(.button)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                Spacer()
                VStack{
                    ZStack(alignment: .trailing){
                        TextField("message", text: $msg)
                            .disabled(!webSocket.isConnected)
                            .frame(maxHeight: 50)
                            .background(.white)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom)
                            .padding(.horizontal, 20)
                            
                            
                        Button("", systemImage: "paperplane") {
                            print("send msg")
                            webSocket.sendMessage(msg)
                            msg = ""
                        }
                        .disabled(!webSocket.isConnected)
                        .frame(maxWidth: 25, maxHeight: 25)
                        .padding(.bottom, 12.5)
                        .padding(.trailing, 30)
                        .foregroundStyle(.black)
                    }
                    .labelsHidden()
                    
                }
            }
            .onDisappear(perform: {
                print("disaappear")
                webSocket.disconnect()
            })
            .navigationDestination(for: HomePagePaths.self) { path in
                switch path {
                case .users:
                    UserListView()
                }
            }
        }
        
    }
    
    
}

enum HomePagePaths: Hashable{
    case users
}

#Preview {
    HomePage(userName: "Sultan")
}
