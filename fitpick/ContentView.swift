//
//  ContentView.swift
//  fitpick
//
//  Created by Amuel Ryco Nidoy on 1/9/26.
//

import SwiftUI
import CoreData



struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home Screen")
                .font(.largeTitle)
                .navigationTitle("Home")
        }
    }
}

struct ClosetView: View {
    var body: some View {
        NavigationStack {
            Text("Closet Screen")
                .font(.largeTitle)
                .navigationTitle("Closet")
        }
    }
}

struct SocialsView: View {
    var body: some View {
        NavigationStack {
            Text("Socials Screen")
                .font(.largeTitle)
                .navigationTitle("Socials")
        }
    }
}





// Custom enum to handle the side of the avatar
enum PointerSide {
    case leading, trailing
}




struct BodyMeasurementView: View {
    // User Identity
    @State private var username: String = ""
    @State private var gender: String = "Male"
    
    // The 10 Required Statistics (Hips Added)
    @State private var height: Double = 175
    @State private var bodyWeight: Double = 70
    @State private var chest: Double = 90
    @State private var shoulderWidth: Double = 45
    @State private var armLength: Double = 60
    @State private var waist: Double = 80
    @State private var hips: Double = 95 // Added Hips
    @State private var inseam: Double = 80
    @State private var shoeSize: Double = 9

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // --- Header ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("User Information")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 10)

                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    Picker("Gender", selection: $gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)

                ZStack {
                    // Avatar Image
                    Image(gender)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: .infinity)
                        .padding(.vertical, 40)
                        .opacity(0.8)

                    // --- VERTICAL MEASUREMENTS ---
                    
                    MeasurementLine(label: "Height", value: $height, unit: "cm", isVertical: true)
                        .frame(height: 380)
                        .offset(x: -165, y: -17)

                    MeasurementLine(label: "Arm", value: $armLength, unit: "cm", isVertical: true)
                        .frame(height: 160)
                        .offset(x: -70, y: -70)

                    MeasurementLine(label: "Inseam", value: $inseam, unit: "cm", isVertical: true)
                        .frame(height: 190)
                        .offset(x: 0, y: 80)

                    // --- HORIZONTAL MEASUREMENTS ---
                    
                    MeasurementLine(label: "Shoulder", value: $shoulderWidth, unit: "cm", isVertical: false)
                        .frame(width: 100)
                        .offset(y: -130)
                    
                    MeasurementLine(label: "Chest", value: $chest, unit: "cm", isVertical: false)
                        .frame(width: 60)
                        .offset(y: -100)
                    
                    MeasurementLine(label: "Waist", value: $waist, unit: "cm", isVertical: false)
                        .frame(width: 50)
                        .offset(y: -65)

                    // Hips Placement: Positioned between waist and inseam
                    MeasurementLine(label: "Hips", value: $hips, unit: "cm", isVertical: false)
                        .frame(width: 70)
                        .offset(y: -30)

                    // --- STAT BOXES ---
                    VStack {
                        Spacer()
                        HStack {
                            StatBox(label: "Body", value: $bodyWeight, unit: "kg")
                            Spacer()
                            StatBox(label: "Shoe Size", value: $shoeSize, unit: "")
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 15)
                    }
                }
                
                // --- Footer ---
                VStack(spacing: 12) {
                    Button(action: { print("Selfie tapped") }) {
                        Text("Selfie")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }

                    Button(action: { print("Saved Profile: \(username)") }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(username.isEmpty ? Color.gray.opacity(0.5) : Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .disabled(username.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Subcomponents (Required to fix the error)

struct MeasurementLine: View {
    let label: String
    @Binding var value: Double
    let unit: String
    let isVertical: Bool

    var body: some View {
        VStack(spacing: 4) {
            Menu {
                Picker(label, selection: $value) {
                    ForEach(Array(stride(from: 1, through: 250, by: 1)), id: \.self) { num in
                        Text("\(num) \(unit)").tag(Double(num))
                    }
                }
            } label: {
                VStack(spacing: 0) {
                    Text(label).font(.system(size: 8, weight: .bold)).foregroundColor(.secondary).textCase(.uppercase)
                    Text("\(Int(value))").font(.system(size: 12, weight: .bold)).foregroundColor(.blue)
                }
                .padding(4)
                .background(Color.white.opacity(0.9))
                .cornerRadius(6)
            }

            if isVertical {
                VStack(spacing: 0) {
                    Rectangle().frame(width: 8, height: 1.5)
                    Rectangle().frame(width: 1.5, height: .infinity)
                    Rectangle().frame(width: 8, height: 1.5)
                }
                .foregroundColor(.blue.opacity(0.5))
            } else {
                HStack(spacing: 0) {
                    Rectangle().frame(width: 1.5, height: 8)
                    Rectangle().frame(width: .infinity, height: 1.5)
                    Rectangle().frame(width: 1.5, height: 8)
                }
                .foregroundColor(.blue.opacity(0.5))
            }
        }
    }
}

struct StatBox: View {
    let label: String
    @Binding var value: Double
    let unit: String
    
    var body: some View {
        Menu {
            Picker(label, selection: $value) {
                ForEach(1...200, id: \.self) { num in
                    Text("\(num) \(unit)").tag(Double(num))
                }
            }
        } label: {
            VStack(alignment: .leading) {
                Text(label).font(.caption2).bold().foregroundColor(.secondary)
                Text("\(Int(value))\(unit)").font(.subheadline).bold().foregroundColor(.primary)
            }
            .padding(10)
            .frame(width: 80)
            .background(BlurView(style: .systemUltraThinMaterial))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.2)))
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}







// MARK: - Subview for the Pointer Logic
struct MeasurementPointer: View {
    let label: String
    @Binding var value: Double
    let unit: String
    let range: ClosedRange<Double>
    var step: Double = 1.0

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Menu {
                Picker(label, selection: $value) {
                    ForEach(Array(stride(from: range.lowerBound, through: range.upperBound, by: step)), id: \.self) { val in
                        Text("\(val, specifier: "%.1f") \(unit)").tag(val)
                    }
                }
            } label: {
                Text("\(value, specifier: "%.1f")")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            // The "Line" specified in your requirement
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 1)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ClosetView()
                .tabItem {
                    Label("Closet", systemImage: "hanger")
                }
            SocialsView()
                .tabItem {
                    Label("Socials", systemImage: "person.2")
                }
            BodyMeasurementView()
                .tabItem {
                    Label("Body Mesaurementsss", systemImage: "ruler")
                }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ClosetView()
                .tabItem {
                    Label("Closet", systemImage: "hanger")
                }

            SocialsView()
                .tabItem {
                    Label("Socials", systemImage: "person.2")
                }
            BodyMeasurementView()
                .tabItem {
                    Label("Body Mesaurement", systemImage: "ruler")
                }
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Log In") {
                // Replace with real authentication
                appState.isLoggedIn = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}


   

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    BodyMeasurementView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
