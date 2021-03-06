//
//  SettingsView.swift
//  EnjoyOKGN
//
//  Created by Blake Patenaude on 2022-06-25.
//

import SwiftUI

struct SettingsView: View {
    
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/blakepat")!
    let portfolioURL = URL(string: "https://blakepat.wixsite.com/portfolio")!
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(named: "OKGNDarkGray")
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        }
    
    var body: some View {

        NavigationView {
            ZStack {
                Color.OKGNDarkGray.ignoresSafeArea()
                
                List {
                    aboutSection
                }
                .navigationTitle("Settings")
                .listStyle(.grouped)
                .toolbar {
                    XDismissButton(color: .OKGNDarkYellow)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



extension SettingsView {
    
    
    private var aboutSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("GoldTrophy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was created by me, Blake Pat. I am an aspiring iOS Developer! If you enjoy using the app, want to support me in my journey, or just want to support my caffeine addiction use the link below.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.gray)
            }
            .padding(.vertical)
            
            Link("Support coffee addiction ??????", destination: coffeeURL)
            Link("iOS Portfolio", destination: portfolioURL)
            
        } header: {
            Text("About")
        }
        .listRowBackground(Color(UIColor(named: "OKGNSecondaryDarkGray")!))
    }
    
    
    private var otherSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("SilverTrophy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was created by me, Blake Pat. I am an aspiring iOS Developer! If you enjoy using the app, want to support me in my journey, or just want to support my caffeine addiction use the link below.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.secondary)
            }
            .padding(.vertical)
            
            Link("Support ??????", destination: coffeeURL)
            
            
        } header: {
            Text("About")
        }
    }
    
    
    private var anotherSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("BronzeTrophy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was created by me, Blake Pat. I am an aspiring iOS Developer! If you enjoy using the app, want to support me in my journey, or just want to support my caffeine addiction use the link below.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.secondary)
            }
            .padding(.vertical)
            
            Link("Support coffee addiction ??????", destination: coffeeURL)
            
        } header: {
            Text("About")
        }
    }
}
