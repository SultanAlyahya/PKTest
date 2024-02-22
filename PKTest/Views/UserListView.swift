//
//  UserListView.swift
//  PKTest
//
//  Created by Sultan alyahya on 11/08/1445 AH.
//

import SwiftUI
import CoreData

struct UserListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.timestamp, ascending: true)],
        animation: .default)
    
    //MARK: will use @FetchRequest to take the data from the CoreData not the reauest to keep single source of truth
    private var users: FetchedResults<User>
    
    @State var getUsersError = ""
    var body: some View {
        VStack{
            List{
                ForEach(users){ user in
                    HStack{
                        VStack(alignment: .leading){
                            Text("\(user.name!)")
                                .font(.system(size: 16))
                            Text("\(user.email!)")
                                .font(.system(size: 12))
                        }
                        Spacer()
                        Text("\(user.status!)")
                    }
                }
            }
            if !getUsersError.isEmpty{
                VStack{
                    Text(getUsersError)
                        .foregroundStyle(.red)
                }
            }
            
        }
        .onAppear{
            Task(priority: .high) {
                await getUsers()
            }
        }
    }
    
    func getUsers() async {
        do{
            let url = URL(string: "https://gorest.co.in/public-api/users")!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let res = response as! HTTPURLResponse
            
            if res.statusCode != 200{
                showErrorMsg(msg: "problem with getting new users")
                return
            }
            let decoder = JSONDecoder()
            let users = try decoder.decode(UsersResponse.self, from: data)
            saveUsers(users: users.data)
            showErrorMsg(msg: "")
        }
        catch{
            if let urlErr = error as? URLError{
                switch urlErr.code{
                case .notConnectedToInternet:
                    showErrorMsg(msg: "no internet connection")
                case .networkConnectionLost:
                    showErrorMsg(msg: "no internet connection")
                default:
                    showErrorMsg(msg: "problem with getting new users")
                }
            }
            print("cant get data: \(error)")
        }
        
    }
    
    @MainActor func showErrorMsg(msg: String){
        getUsersError =  msg
    }
    
    //MARK: made it main actor because coreData will work on main thread
    @MainActor func saveUsers(users: [UserModel]){
        for userM in users {
            if let user = try? getUser(userID: userM.userID), !user.isEmpty{
                continue
            }
            
            let user = User(context: viewContext)
            user.userID = userM.userID
            user.name = userM.name
            user.email = userM.email
            user.status = userM.status
            user.timestamp = Date.now
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    
    //MARK: this get it just to make sure the user is not saved before
    func getUser(userID: Int64) throws -> [User]{
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "userID == %lld", userID as CVarArg)
        return try viewContext.fetch(fetchRequest)
        
    }
}



#Preview {
    UserListView()
}
