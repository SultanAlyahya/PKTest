//
//  WebSocketMdoel.swift
//  PKTest
//
//  Created by Sultan alyahya on 12/08/1445 AH.
//

import Foundation
import Combine

class WebSocketModel: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    var connectTask: Task<Void, Error>? = nil
    let url = URL(string: "wss://echo.websocket.org/")!
    
    @Published var isConnected = false
    @Published  var recivedMeg = ""
    @Published  var msgStatus = ""
    
    //MARK: clear the previouse msg and status then create new session
    func connect()  {
        recivedMeg = ""
        msgStatus = ""
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        connectTask = Task{
            webSocketTask?.resume()
            await receiveMessage()
        }
        isConnected = true
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        connectTask?.cancel()
        isConnected = false
    }
    
    func sendMessage(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
                Task{ [weak self] in
                    await self?.updateMessage(status: "can't send msg", msg: error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: loop to check if there is any new msgs, the task is async and canclable so no need to make self weak
    private func receiveMessage() async {
        while let webSocketTask = webSocketTask {
            do {
                try Task.checkCancellation()
                let message = try await webSocketTask.receive()
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                    await updateMessage(status: "Message revived", msg: text)
                default:
                    print("Received an unknown message type")
                    await self.updateMessage(status: "can't receive msg", msg: "Received an unknown message type")
                }
                
            } catch {
                print("WebSocket receiving error: \(error)")
                await self.updateMessage(status: "can't receive msg", msg: error.localizedDescription)
                break
            }
        }
    }
    
    @MainActor func updateMessage(status: String, msg: String){
        recivedMeg = msg
        msgStatus = status
    }
}
