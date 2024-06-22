//
//  LaunchView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject private var router: Router
    @AppStorage("uid") var uid: String = ""
    
    var body: some View {
        VStack {
            Image("nxl")
                .resizable()
                .frame(width: 200, height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.theme.white)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if uid.isEmpty { router.navigate(to: "Onboard") }
                else { router.navigate(to: "BottomTab") }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LaunchView()
                .environmentObject(Router())
        }
    }
}
