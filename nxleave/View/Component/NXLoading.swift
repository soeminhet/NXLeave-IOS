//
//  NXLoading.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import SwiftUI

struct NXLoading: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            ProgressView()
                .padding()
                .background()
                .cornerRadius(10)
        }
    }
}

struct NXLoading_Previews: PreviewProvider {
    static var previews: some View {
        NXLoading()
    }
}
