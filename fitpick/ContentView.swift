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

struct BodyMeasurementView: View {
    
    @State private var gender = "Male"
    @State private var selectedHeight = 100 // Default value
    @State private var selectedWeight = 100 // Default value
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50){
                Picker("Gender", selection: $gender) {
                                    Text("Male").tag("Male")
                                    Text("Female").tag("Female")
                                }
                                .pickerStyle(.segmented)
                Text("Body Measurements")
                    .font(.largeTitle)
                    .navigationTitle("User Information")
            ZStack {
                    if gender == "Male" {
                        Image("Male")
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .position(x:240, y:200)
                            .scaledToFill()
                    } else {
                        Image("Female")
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .position(x:240, y:200)
                            .scaledToFill()
                    }
                
                Picker("Weight", selection: $selectedWeight) {
                    ForEach(1...150, id: \.self) { number in
                        Text("\(number) kg").tag(number)
                    }
                }
                // This modifier makes it look like a dropdown menu
                .pickerStyle(.menu)
                .position(x:280, y:-110)
                
                Picker("Height", selection: $selectedHeight) {
                    ForEach(1...150, id: \.self) { number in
                        Text("\(number) cm").tag(number)
                    }
                }
                // This modifier makes it look like a dropdown menu
                .pickerStyle(.menu)
                .position(x:110, y:70)
                
                Text("Shoulder Width") // Custom label above the wheel
                        .font(.headline)
                        .position(x:110, y:45)
                Text("Weight") // Custom label above the wheel
                        .font(.headline)
                        .position(x:200, y:-110)
                
                Button("Save") {
                    print("Button was tapped!")
                    // Add your logic here, like resetting the height to 100:
                    // selectedHeight = 100
                }.position(x:380, y:420)
                
            }
                
            
                
                
            }
            .padding()
            .navigationTitle("Body Measurement")
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
                    Label("Body Mesaurement", systemImage: "ruler")
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
