import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            WorkoutPage()                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Workout")
                }
            
            AddDataView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add Data")
                }
            HomePageView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            VoucherListView()
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("Voucher")
                }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }.accentColor(.black)
    }
}


struct HomePageView: View {
    let username = "John"
    var days = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hi, \(username)!")
                .font(Font.custom("SF Pro", size: 28).weight(.bold))
                .padding(.leading)
                .lineSpacing(13)
                .foregroundColor(.black)
            
            Text("You have been here for \(days) days")
                .font(Font.custom("SF Pro", size: 16))
                .padding([.leading, .bottom])
                .lineSpacing(13)
                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
            
            ZStack(alignment: .top) { // Rectangle layers
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 309, height: 276)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(
                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                        radius: 4,
                        x: 0,
                        y: 4
                    )
                
                VStack { // Text and Image in Rectangle layers
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.black)
                            .padding(.trailing, 8) // Adjust padding as needed
                        
                        Text("Today Weight")
                            .font(Font.custom("SF Pro", size: 15).weight(.bold))
                            .multilineTextAlignment(.leading)
                            .padding([.top, .bottom, .trailing])
                            .lineSpacing(13)
                            .foregroundColor(.black)
                    }
                    
                    HStack(spacing: 0) {
                        // Add your content inside the HStack if needed
                    }
                    .padding(
                        EdgeInsets(top: 3.44, leading: 2.06, bottom: 3.44, trailing: 2.03)
                    )
                    .frame(width: 22, height: 22)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align to the top
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // Align to top left corner
    }
}

struct AddDataView: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: headerView("HEALTH INFORMATION", systemImage: "heart.circle")) {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        // Add your data handling logic here
                        saveData()
                    }) {
                        Text("Save Data")
                            .foregroundStyle(.blue)
                    }
                }
            }
            .navigationTitle("Add Data")
        }
    }
    
    private func headerView(_ title: String, systemImage: String) -> some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
            Text(title)
        }
    }
    
    private func saveData() {
        // Add your data saving logic here
    }
}


struct Voucher: Identifiable {
    let id = UUID()
    let code: String
    let discount: Int
    let expirationDate: Date
    let store : String
}

// Create a view to display the list of vouchers
struct VoucherListView: View {
    // Sample data for vouchers
    let vouchers: [Voucher] = [
        Voucher(code: "SAVE20", discount: 20, expirationDate: createDate(year: 2024, month: 12, day: 31),store:"JUI"),
        Voucher(code: "FREESHIP", discount: 100, expirationDate: createDate(year: 2024, month: 11, day: 30),store:"KEEROR"),
        Voucher(code: "HOLIDAY50", discount: 50, expirationDate: createDate(year: 2024, month: 12, day: 25),store:"NOCOTEL SIAM"),
        Voucher(code: "BUFFET50", discount: 50, expirationDate: createDate(year: 2024, month: 04, day: 30),store:"OISHA EATERIUM"),
        Voucher(code: "SONGKRAN35", discount: 35, expirationDate: createDate(year: 2024, month: 04, day: 15),store:"BBQ MALA"),
        Voucher(code: "SONGKRAN35", discount: 35, expirationDate: createDate(year: 2024, month: 04, day: 15),store:"BBQ MALA"),
    ]
    
    var body: some View {
        
        NavigationView {// Use a List to display the vouchers, sorted by expiration date
            List(vouchers.sorted(by: { $0.expirationDate < $1.expirationDate })) { voucher in
                // Use NavigationLink to navigate to the voucher details
                NavigationLink(destination: VoucherDetailView(voucher: voucher)) {
                    // Display each voucher using a custom row view
                    VoucherRow(voucher: voucher)
                }
            }
            .navigationTitle("Voucher List") // Set the navigation title
        }
    }
}

// Create a view for displaying each voucher in a row
struct VoucherRow: View {
    let voucher: Voucher
    
    var body: some View {
        // Use HStack to arrange content horizontally
        HStack {
            // Display voucher information in a vertical stack
            VStack(alignment: .leading) {
                // Display voucher code in headline font
                Text("Code: \(voucher.code)")
                    .font(.headline)
                // Display voucher discount
                Text("Discount: \(voucher.discount)%")
                // Display formatted expiration date in gray color
                Text("Store: \(voucher.store)")
                    .foregroundStyle(.gray)
                Text("Expires on: \(formattedDate(voucher.expirationDate))")
                    .foregroundStyle(.gray)
            }
        }
        .padding() // Add padding to the entire row
    }
}

// Create a view for displaying voucher details
struct VoucherDetailView: View {
    let voucher: Voucher
    
    var body: some View {
        // Vertical stack to arrange content vertically
        VStack {
            // Title for the voucher details
            Text("Voucher Details")
                .font(.title)
                .padding() // Add padding
            
            Spacer() // Add spacer to push content to the top
            
            // Vertical stack for voucher details
            VStack(alignment: .leading) {
                // Display voucher information
                Text("Code: \(voucher.code)")
                    .font(.headline)
                Text("Discount: \(voucher.discount)%")
                // Display formatted expiration date
                Text("Store: \(voucher.store)")
                    .foregroundStyle(.gray)
                Text("Expires on: \(formattedDate(voucher.expirationDate))")
                    .foregroundColor(.gray)
            }
            .padding() // Add padding to the content
            
            Spacer() // Add spacer to push content to the bottom
        }
        .navigationBarTitle(voucher.code) // Set the navigation bar title
    }
}

struct Exercise: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var estimatedTime: String
    var estimatedKcal: Int
    var sets: Int?
    var reps: Int?
    var weight: String?
}

struct Workout: Identifiable {
    var id = UUID()
    var name: String
    var exercises: [Exercise]
}

struct WorkoutDay: Identifiable {
    var id = UUID()
    var day: String
    var workouts: [Workout]
}

struct WorkoutPage: View {
    let workoutDays: [WorkoutDay] = [
        WorkoutDay(day: "Day 1", workouts: [
            Workout(name: "Morning Routine", exercises: [
                Exercise(name: "Push-ups", description: "Do 3 sets of 10 push-ups", estimatedTime: "15 minutes", estimatedKcal: 50),
                Exercise(name: "Squats", description: "Do 3 sets of 15 squats", estimatedTime: "15 minutes", estimatedKcal: 60),
            ]),
            Workout(name: "Evening Workout", exercises: [
                Exercise(name: "Plank", description: "Hold plank position for 1 minute", estimatedTime: "5 minutes", estimatedKcal: 20),
                Exercise(name: "Lunges", description: "Do 3 sets of 12 lunges", estimatedTime: "15 minutes", estimatedKcal: 50),
            ]),
        ]),
        WorkoutDay(day: "Day 2", workouts: [
            Workout(name: "Cardio Session", exercises: [
                Exercise(name: "Running", description: "Run for 20 minutes", estimatedTime: "20 minutes", estimatedKcal: 150),
                Exercise(name: "Jumping Jacks", description: "Do 3 sets of 30 jumping jacks", estimatedTime: "10 minutes", estimatedKcal: 80),
            ]),
            Workout(name: "Strength Training", exercises: [
                Exercise(name: "Deadlifts", description: "Do 4 sets of 8 deadlifts", estimatedTime: "25 minutes", estimatedKcal: 120, sets: 4, reps: 8, weight: "50 lbs"),
                Exercise(name: "Bicep Curls", description: "Do 3 sets of 12 bicep curls", estimatedTime: "15 minutes", estimatedKcal: 70, sets: 3, reps: 12, weight: "20 lbs"),
            ]),
        ]),
        // Add more workout days as needed
    ]

    var body: some View {
        NavigationView {
            List(workoutDays) { day in
                NavigationLink(destination: WorkoutDetail(workoutDay: day)) {
                    Text(day.day)
                }
            }
            .navigationTitle("Workout Plan")
        }
    }
}

struct WorkoutDetail: View {
    var workoutDay: WorkoutDay

    var body: some View {
        List {
            ForEach(workoutDay.workouts) { workout in
                Section(header: Text(workout.name)) {
                    ForEach(workout.exercises) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)
                            Text(exercise.description)
                                .font(.subheadline)
                            if let sets = exercise.sets, let reps = exercise.reps, let weight = exercise.weight {
                                Text("Sets: \(sets), Reps: \(reps), Weight: \(weight)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }

            Section(header: Text("Day Summary")) {
                Text("Total Estimated Time: \(totalTimeForDay(workoutDay.workouts)) minutes")
                Text("Total Estimated Kcal: \(totalKcalForDay(workoutDay.workouts)) kcal")
            }
        }
        .navigationTitle(workoutDay.day)
    }

    func totalTimeForDay(_ workouts: [Workout]) -> Int {
        return workouts.flatMap { $0.exercises }.reduce(0) { $0 + (Int($1.estimatedTime) ?? 0) }
    }

    func totalKcalForDay(_ workouts: [Workout]) -> Int {
        return workouts.flatMap { $0.exercises }.reduce(0) { $0 + $1.estimatedKcal }
    }
}

//Support Function

func createDate(year: Int, month: Int, day: Int) -> Date {
    // Create a Date from year, month, and day components
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    return Calendar.current.date(from: dateComponents) ?? Date()
}

func formattedDate(_ date: Date) -> String {
    // Helper function to format the date for display
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter.string(from: date)
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
