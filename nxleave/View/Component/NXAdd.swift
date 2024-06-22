//
//  NXAdd.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 30/01/2024.
//

import SwiftUI

struct NXAddCircle: View {
    var body: some View {
        Image(systemName: "plus")
            .tint(.white)
            .padding()
            .background {
                Color.theme.blackVarient
                    .opacity(0.9)
                    .clipShape(Circle())
            }
    }
}

struct NXAdd_Previews: PreviewProvider {
    static var previews: some View {
        NXAddCircle()
    }
}
