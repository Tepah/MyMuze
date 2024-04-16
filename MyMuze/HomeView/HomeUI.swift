//
//  HomeUI.swift
//  MyMuze
//
//  Created by Diamond Ly on 2/13/24.
//

import SwiftUI
import FirebaseAuth

struct HomeUI: View {
    @State var loading = true
    @State var notifications = [Notification]()
    
    let uid = Auth.auth().currentUser?.uid ?? "temp"
    
    var body: some View {
        NavigationView {
            BackgroundView()
                .overlay(
                        VStack {
                            if loading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(2)
                                    .onAppear() {
                                        loadData()
                                    }
                            } else {
                                HStack {
                                    Text("Home")
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                                        .padding([.leading, .bottom], 10.0)
                                    Spacer()
                                    NavigationLink(destination: ProfileSearchView()) {
                                        Image(systemName: "magnifyingglass")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.white)
                                            .padding(10)
                                    }
                                    if notifications.count > 0 {
                                        NavigationLink(destination: NotificationsView()) {
                                            Image(systemName: "bell.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color.white)
                                                .padding(10)
                                                .overlay(
                                                    Circle()
                                                        .foregroundColor(.red)
                                                        .frame(width: 10, height: 10)
                                                        .offset(x: 10, y: -10)
                                                )
                                        }
                                    } else {
                                        NavigationLink(destination: NotificationsView()) {
                                            Image(systemName: "bell")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color.white)
                                                .padding(10)
                                        }
                                    }
                                }
                                Divider()
                                    .overlay(.white)
                                    .frame(height: 2)
                                    .background(Color.white)
                                ZStack {
                                    VStack{
                                        NavigationLink(destination: ProfileUI()) {
                                            Text("@diamondly")
                                                .foregroundColor(Color("Accent Color"))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .fontWeight(.bold)
                                        }
                                        Text("THE END")
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: . infinity, alignment: .topLeading)
                                        Text("Alesso, Charlotte Lawrence")
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.leading, 10.0)
                                }
                                Divider()
                                    .overlay(.white)
                                
                                ZStack {
                                    VStack{
                                        NavigationLink(destination: ProfileUI()) {
                                            Text("@potipitak")
                                                .foregroundColor(Color("Accent Color"))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .fontWeight(.bold)
                                        }
                                        Text("golden hour - Fujii Kaze Remix")
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: . infinity, alignment: .topLeading)
                                        Text("JVKE, Fujii Kaze")
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.leading, 10.0)
                                }
                                Divider()
                                    .overlay(.white)
                                
                                ZStack {
                                    VStack{
                                        NavigationLink(destination: ProfileUI()) {
                                            Text("@dave123")
                                                .foregroundColor(Color("Accent Color"))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .fontWeight(.bold)
                                        }
                                        Text("Use Somebody")
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: . infinity, alignment: .topLeading)
                                        Text("Kings of Leon")
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding(.leading, 10.0)
                                Divider()
                                    .overlay(.white)
                                Spacer()
                        }
                    }
                )
        }
    }
    
    func loadData() {
        Task {
            do {
                notifications = try await getNotificationsForUser(uid:uid);
                loading = false;
            } catch {
                print("Error loading notifications")
            }
        }
    }
}
#Preview {
    HomeUI()
}
