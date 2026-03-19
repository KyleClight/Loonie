import SwiftUI

struct LoginView: View {
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var isAdmin: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(red: 0.62, green: 0.4, blue: 0.9).ignoresSafeArea()
            
            VStack(spacing: 20) {
                if isLoggedIn == true {
                    Text("Welcome, \(login)")
                } else {
                    Text("Loonie")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                    
                    TextField("Login", text: $login)
                        .frame(height: 30, alignment: .center)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .frame(height: 30, alignment: .center)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    
                    HStack() {
                        Text("Admin:").foregroundColor(.black).fontWeight(.semibold)
                        Spacer()
                        Toggle("", isOn: $isAdmin)
                    }
                    Button(action: {
                        
                    }) {
                        Text("Enter")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 100)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
