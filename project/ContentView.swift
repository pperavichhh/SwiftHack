
//
//  ContentView.swift
//  Manu
//
//  Created by User on 11/3/2567 BE.
//
import AVKit
import WebKit
import SwiftUI
import Charts
// tabbed bar

struct ContentView: View {
    @State private var isShowingWelcomePage = true
    @State private var birthday = Date()
    @State private var selectedGender: Gender = .male
    @State private var weight = "" // Example weight in kg
    @State private var height = "" // Example height in cm
    @State private var username = ""
    @State private var days = 10 // Example number of days
    @State private var isShowingAddDataView = false
    @State private var selectedTab = "Home"
    @State private var age: Int = 0


    var body: some View {
        NavigationView {
            if isShowingWelcomePage {
                WelcomePage(birthday: $birthday, selectedGender: $selectedGender, weight: $weight, height: $height, username: $username, isShowingWelcomePage: $isShowingWelcomePage)
            } else {
                TabView(selection: $selectedTab) {
                    WorkoutPage()
                        .tabItem {
                            Image(systemName: "figure.run")
                            Text("Workout")
                        }
                        .tag("Workout")

                    AddDataView(isShowingAddDataView: $isShowingAddDataView, weight: $weight, height: $height, selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "plus.circle")
                            Text("Edit Data")
                        }
                        .tag("Add")

                    HomePageView(username: username, days: days, weight: weight, height: height)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag("Home")

                    VoucherListView()
                        .tabItem {
                            Image(systemName: "ticket.fill")
                            Text("Voucher")
                        }
                        .tag("Voucher")

                    SettingsView(isShowingWelcomePage: $isShowingWelcomePage) // Pass isShowingWelcomePage binding here
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Setting")
                        }
                        .tag("Setting")
                }
                .accentColor(.green)
            }
        }
    }
}


struct AVPlayerView: View {
    let url: String
    var body: some View {
        VStack {
            if let videoURL = URL(string: url) {
                WebView(url: videoURL)
            } else {
                Text("Invalid video URL")
            }
        }
        .navigationTitle("Workout Video")
    }
}
struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    init(url: URL, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
        }
    }
}
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    init(url: URL) {
        self.url = url
        loadImage()
    }
    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
struct WelcomePage: View {
    @Binding var birthday: Date
    @Binding var selectedGender: Gender
    @Binding var weight: String
    @Binding var height: String
    @Binding var username: String
    @Binding var isShowingWelcomePage: Bool

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Username", text: $username)
                Picker("Gender", selection: $selectedGender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                DatePicker("Birthday", selection: $birthday, in: ...Date(), displayedComponents: [.date])
                    .labelsHidden()

                TextField("Weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)

                TextField("Height (cm)", text: $height)
                    .keyboardType(.numberPad)
            }

            Section {
                Button(action: {
                    // Perform validation if needed
                    isShowingWelcomePage = false
                }) {
                    Text("Continue")
                }
            }
        }
        .navigationTitle("Welcome")
    }
}
struct WorkoutPage: View {
    let descriptions = [
        // Descriptions for each day
        [
            "    Push-ups Do 3 sets of 10 push-ups   ",
            " ChessPress Do 3 sets of 15 chest press ",
            "   LegPress Do 3 sets of 15 Leg press   ",
            " shoulder Do 3 sets of 15 shoulder press "
        ],
        [
            "    Push-ups Do 3 sets of 10 push-ups   ",
            " ChessPress Do 3 sets of 15 chest press ",
            "   LegPress Do 3 sets of 15 Leg press   ",
            " shoulder Do 3 sets of 15 shoulder press "
        ],
        [
            "    Push-ups Do 3 sets of 10 push-ups   ",
            " ChessPress Do 3 sets of 15 chest press ",
            "   LegPress Do 3 sets of 15 Leg press   ",
            " shoulder Do 3 sets of 15 shoulder press "
        ],
        [
            "    Push-ups Do 3 sets of 10 push-ups   ",
            " ChessPress Do 3 sets of 15 chest press ",
            "   LegPress Do 3 sets of 15 Leg press   ",
            " shoulder Do 3 sets of 15 shoulder press "
        ],
        [
            "    Push-ups Do 3 sets of 10 push-ups   ",
            " ChessPress Do 3 sets of 15 chest press ",
            "   LegPress Do 3 sets of 15 Leg press   ",
            " shoulder Do 3 sets of 15 shoulder press "
        ]
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                LazyVStack {
                    ForEach(0..<5) { dayIndex in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Guide Line \(dayIndex + 1)")
                                .font(.headline)
                                .padding(.top)
                            ForEach(0..<4) { boxIndex in
                                VStack {
                                    Text("Exercise \(boxIndex + 1)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.bottom)
                                    Text(descriptions[dayIndex][boxIndex])
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.bottom)
                                    let videoLinks = [
                                        "https://www.youtube.com/embed/JyCG_5l3XLk?si=HdR_EwnqNHAyrVxI",
                                        "https://www.youtube.com/embed/NwzUje3z0qY?si=vl5CoWjdNR-U3aZX",
                                        "https://www.youtube.com/embed/yZmx_Ac3880?si=gNP3wEJFOBFCiRxl",
                                        "https://www.youtube.com/embed/WvLMauqrnK8?si=2aWiGNNn_Vp92B2J",
                                        "https://www.youtube.com/embed/Orxowest56U?si=7uuYYY4r7_W0hXLG",
                                        "https://www.youtube.com/embed/gJjfnubfPLY?si=Rxc0whGiRadU-DC6"
                                        // Add more video links here
                                    ]
                                    
                                    let thumbnailLinks = [
                                        "https://img.youtube.com/vi/JyCG_5l3XLk/hqdefault.jpg",
                                        "https://img.youtube.com/vi/NwzUje3z0qY/hqdefault.jpg",
                                        "https://img.youtube.com/vi/yZmx_Ac3880/hqdefault.jpg",
                                        "https://img.youtube.com/vi/WvLMauqrnK8/hqdefault.jpg","https://img.youtube.com/vi/Orxowest56U/hqdefault.jpg","https://img.youtube.com/vi/gJjfnubfPLY/hqdefault.jpg",
                                        // Add more thumbnail links here
                                    ]

                                    NavigationLink(destination: AVPlayerView(url: videoLinks[boxIndex % videoLinks.count])) {
                                        VStack {
                                            AsyncImage(url: URL(string: thumbnailLinks[boxIndex % thumbnailLinks.count])!) {
                                                ProgressView()
                                            }
                                            .frame(width: 150, height: 100)
                                            .cornerRadius(10)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Workout") // Edit the navigation title
        }
        .tabItem {
            Image(systemName: "rectangle.grid.2x2.fill")
            Text("Workout") // Edit the tab label
        }
    }
}


struct Weight {
    var date: Date
    var weight: Double
    var bmi: Double
}
//Home Page
struct HomePageView: View {
    let username: String
    let days: Int // Assuming this is the number of days the user has been using the app
    let weight: String // Assuming this is the user's current weight in kg
    let height: String // Assuming this is the user's height in cm

    var bmi: Double {
        guard let weight = Double(weight), let height = Double(height), height > 0 else { return 0.0 }
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Hi, \(username)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.bottom, 5)

            Text("Current Weight: \(weight) kg")
                .font(.title)
                .foregroundColor(.gray)

            Text("BMI: \(String(format: "%.2f", bmi))")
                .font(.title)
                .foregroundColor(.gray)

            // Add more content as needed...
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white) // Set background color
        .cornerRadius(10) // Add a corner radius
        .padding() // Add padding to the entire view
    }
}




// Add Data
struct AddDataView: View {
    @Binding var isShowingAddDataView: Bool
    @Binding var weight: String
    @Binding var height: String
    @Binding var selectedTab: String

    @State private var isShowingAddDataAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: headerView("HEALTH INFORMATION", systemImage: "heart.circle")) {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.numberPad)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.numberPad)
                }

                Section {
                    Button(action: {
                        guard let weightValue = Int(weight), let heightValue = Int(height), weightValue > 0, heightValue > 0 else {
                            isShowingAddDataAlert = true
                            return
                        }
                        // Save data and navigate back to home page
                        saveData()
                        isShowingAddDataView = false
                        selectedTab = "Home"
                    }) {
                        Text("Save Data")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Edit Data")
            .alert(isPresented: $isShowingAddDataAlert) {
                Alert(title: Text("Invalid Input"), message: Text("Weight and height must be positive integers."), dismissButton: .default(Text("OK")))
            }
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


// Voucher
struct Voucher: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let discount: Int
    let expirationDate: Date
    let store: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Voucher, rhs: Voucher) -> Bool {
        return lhs.id == rhs.id
    }
}

struct VoucherListView: View {
    @State private var searchText = ""
    @State private var isSearching = false
    
    let vouchers: [Voucher] = [
        Voucher(code: "SAVE20", discount: 20, expirationDate: createDate(year: 2024, month: 12, day: 31), store: "JUI"),
        Voucher(code: "FREESHIP", discount: 100, expirationDate: createDate(year: 2024, month: 11, day: 30), store: "KEEROR"),
        Voucher(code: "HOLIDAY50", discount: 50, expirationDate: createDate(year: 2024, month: 12, day: 25), store: "NOCOTEL SIAM"),
        Voucher(code: "BUFFET50", discount: 50, expirationDate: createDate(year: 2024, month: 04, day: 30), store: "OISHA EATERIUM"),
        Voucher(code: "SONGKRAN35", discount: 35, expirationDate: createDate(year: 2024, month: 04, day: 15), store: "BBQ MALA"),
        Voucher(code: "SONGKRAN35", discount: 35, expirationDate: createDate(year: 2024, month: 04, day: 15), store: "BBQ MALA")
    ]
    
    var sortedVouchers: [Voucher] {
        vouchers.sorted(by: { $0.expirationDate < $1.expirationDate })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                
                List(sortedVouchers.filter { voucher in
                    searchText.isEmpty ||
                    voucher.code.localizedCaseInsensitiveContains(searchText) ||
                    voucher.store.localizedCaseInsensitiveContains(searchText)
                }) { voucher in
                    NavigationLink(destination: VoucherDetailView(voucher: voucher)) {
                        VoucherRow(voucher: voucher)
                    }
                }
                .navigationTitle("Voucher List")
            }
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            TextField("Search ...", text: $searchText)
                .padding(.leading, 24)
            
            Button(action: {
                searchText = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .padding(.trailing)
            })
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct VoucherRow: View {
    let voucher: Voucher
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Code: \(voucher.code)")
                    .font(.headline)
                Text("Discount: \(voucher.discount)%")
                Text("Store: \(voucher.store)")
                    .foregroundStyle(.gray)
                Text("Expires on: \(formattedDate(voucher.expirationDate))")
                    .foregroundStyle(.gray)
            }
        }
        .padding()
    }
}

struct VoucherDetailView: View {
    let voucher: Voucher
    
    var body: some View {
        VStack {
            Text("Voucher Details")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading) {
                Text("Code: \(voucher.code)")
                    .font(.headline)
                Text("Discount: \(voucher.discount)%")
                Text("Store: \(voucher.store)")
                    .foregroundStyle(.gray)
                Text("Expires on: \(formattedDate(voucher.expirationDate))")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationBarTitle(voucher.code)
    }
}

// Settings Page
struct SettingsView: View {
    @State private var isShowingLogoutAlert = false
    @Binding var isShowingWelcomePage: Bool

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General")) {
                    NavigationLink(destination: GeneralSettingsView()) {
                        HStack {
                            Image(systemName: "gear")
                            Text("General Settings")
                        }
                    }
                }

                Section {
                    Button(action: {
                        isShowingLogoutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.left.circle")
                                .foregroundStyle(.black)
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                    }
                    .alert(isPresented: $isShowingLogoutAlert) {
                        Alert(title: Text("Logout"), message: Text("Are you sure you want to logout?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Logout"), action: {
                            // Handle logout action here
                            // You may want to implement your logout logic
                            isShowingWelcomePage = true
                        }))
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
        }
    }
}


enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}

struct GeneralSettingsView: View {
    @State private var selectedDate = Date()
    @State private var selectedGender: Gender = .male
    
    var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    var age: Int {
        currentYear - Calendar.current.component(.year, from: selectedDate)
    }

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                HStack {
                    Image(systemName: "person")
                    VStack(alignment: .leading) {
                        Text("Gender")
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                HStack {
                    Image(systemName: "calendar")
                    DatePicker("Birthday", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                        .labelsHidden()
                }
                HStack {
                    Image(systemName: "clock")
                    Text("Age: \(age)")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                        .padding(.leading, 5)
                }
            }

            Section(header: Text("App Information")) {
                HStack {
                    Image(systemName: "info.circle")
                    Text("App Version")
                    Spacer()
                    Text("Pre-alpha") // Replace with your actual app version
                }
            }
        }
        .navigationBarTitle("General Settings")
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
