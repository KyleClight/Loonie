import SwiftUI

struct SleepLog: Identifiable {
    let id = UUID()
    var date: String
    var duration: Double
    var notes: String
}

struct MainView: View {
    @Binding var isLoggedIn: Bool
    let userRole: String
    
    @State private var sleepLogs = [
        SleepLog(date: "19.03.2026", duration: 8.0, notes: "Хороший отдых"),
        SleepLog(date: "20.03.2026", duration: 6.5, notes: "Поздняя работа")
    ]
    
    @State private var showCalcAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(sleepLogs) { log in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(log.date).font(.headline)
                                Text(log.notes).font(.subheadline).foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(String(format: "%.1f", log.duration)) ч")
                                .fontWeight(.bold).foregroundColor(.blue)
                        }
                    }
                    .onDelete(perform: deleteLog)
                }
                
                Button("Рассчитать средний сон") {
                    showCalcAlert = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle(userRole == "admin" ? "Администрирование" : "Дневник сна")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Выход") {
                        withAnimation { isLoggedIn = false }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addLog) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Результат запроса", isPresented: $showCalcAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                let avg = sleepLogs.map { $0.duration }.reduce(0, +) / Double(sleepLogs.count)
                Text("Средняя продолжительность сна за период: \(String(format: "%.1f", avg)) ч.")
            }
        }
    }
    
    func deleteLog(at offsets: IndexSet) {
        sleepLogs.remove(atOffsets: offsets)
    }
    
    func addLog() {
        let newLog = SleepLog(date: "21.03.2026", duration: 7.0, notes: "Новая запись")
        sleepLogs.append(newLog)
    }
}
