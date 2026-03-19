import SwiftUI
import UniformTypeIdentifiers

struct LoginView: View {
    let columns = [GridItem(.fixed(100)), GridItem(.fixed(100))]
    
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var isAdmin: Bool = false
    @State private var attempts: Int = 0
    @State private var isBlocked: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage = ""
    
    // Порядок картинок: 0 соответствует Puzzle1, 1 -> Puzzle2 и т.д
    @State private var picOrder = [2, 0, 3, 1]
    @State private var draggedTileIndex: Int? = nil
    @State private var targettingTileIndex: Int? = nil
    @State private var puzzleIsSolved: Bool = false
    
    func checkUserInDatabase() {
        let mockAdminUsername = "admin"
        let mockAdminPassword = "123"
        
        if login == mockAdminUsername && password == mockAdminPassword {
            print("SQL Query: User found with role 'admin'")
            withAnimation {
                self.isLoggedIn = true
                self.isAdmin = true
            }
        } else if !login.isEmpty && !password.isEmpty {
            print("SQL Query: User found with role 'user'")
            withAnimation {
                self.isLoggedIn = true
                self.isAdmin = false
            }
        } else {
            print("SQL Error: User not found or incorrect password")
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.4, blue: 0.9).ignoresSafeArea()
            
            VStack(spacing: 20) {
                if isLoggedIn {
                    MainView(isLoggedIn: $isLoggedIn, userRole: isAdmin ? "admin" : "user")
                } else {
                    Text("Loonie")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        TextField("Login", text: $login)
                            .padding().background(Color.white.opacity(0.8)).cornerRadius(10)
                        
                        SecureField("Password", text: $password)
                            .padding().background(Color.white.opacity(0.8)).cornerRadius(10)
                        
                        HStack {
                            Text("Admin:").fontWeight(.semibold)
                            Spacer()
                            Toggle("", isOn: $isAdmin).labelsHidden()
                        }
                        
                        // Блок капчи
                        VStack(spacing: 10) {
                            Text(puzzleIsSolved ? "Verification Passed ✅" : "Prove you're not a robot")
                                .font(.caption).foregroundColor(.white)
                            
                            if !puzzleIsSolved {
                                puzzleGridView
                            }
                        }
                        .padding().background(Color.black.opacity(0.2)).cornerRadius(15)
                        
                        Button(action: {
                            checkLogin()
                        }) {
                            Text("Enter")
                                .font(.headline).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding()
                                .background(puzzleIsSolved ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                        .disabled(!puzzleIsSolved)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Система"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            if alertMessage == "Вы успешно авторизовались" {
                                withAnimation {
                                    self.isLoggedIn = true
                                }
                            }
                        }
                    )
                }
    }
    
    var puzzleGridView: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<4) { index in
                let tileValue = picOrder[index]
                
                Image("Puzzle\(tileValue + 1)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
                    .opacity(draggedTileIndex == index ? 0.3 : 1.0)
                    .onDrag {
                        self.draggedTileIndex = index
                        return NSItemProvider(object: String(index) as NSString)
                    }
                    .onDrop(of: [.plainText], delegate: PuzzleDropDelegate(
                        currentIndex: index,
                        picOrder: $picOrder,
                        draggedTileIndex: $draggedTileIndex,
                        isSolved: $puzzleIsSolved
                    ))
            }
        }
    }
    
    func checkLogin() {
        if attempts >= 3 {
            alertMessage = "Вы заблокированы. Обратитесь к администратору"
            showAlert = true
            return
        }

        if login.isEmpty || password.isEmpty {
            alertMessage = "Поля Логин и Пароль обязательны для заполнения"
            showAlert = true
            return
        }

        let isValidUser = (login == "admin" && password == "123") || (login == "user" && password == "user")
        
        if isValidUser {
            alertMessage = "Вы успешно авторизовались"
            attempts = 0
            showAlert = true
        } else {
            attempts += 1
            if attempts >= 3 {
                alertMessage = "Вы заблокированы. Обратитесь к администратору"
            } else {
                alertMessage = "Вы ввели неверный логин или пароль. Пожалуйста проверьте ещё раз введенные данные"
            }
            showAlert = true
        }
    }
}

struct PuzzleDropDelegate: DropDelegate {
    let currentIndex: Int
    @Binding var picOrder: [Int]
    @Binding var draggedTileIndex: Int?
    @Binding var isSolved: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        guard let sourceIndex = draggedTileIndex else { return false }
        
        withAnimation(.spring()) {
            picOrder.swapAt(sourceIndex, currentIndex)
        }
        
        draggedTileIndex = nil
        
        if picOrder == [0, 1, 2, 3] {
            withAnimation { isSolved = true }
        }
        return true
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
