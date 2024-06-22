//
//  ProfileItem.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 30/01/2024.
//

import SwiftUI

struct ProfileItem: View {
    
    let icon: String
    let name: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(icon)
                    .font(.title3)
                
                Text(name)
                    .padding(.leading, 4)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
            }
            .padding()
            
            Divider()
        }
        .background(.white)
    }
}

struct ProfileItem_Previews: PreviewProvider {
    static var previews: some View {
        ProfileItem(
            icon: "square.and.arrow.up",
            name: "Leave Types"
        )
        .previewLayout(.sizeThatFits)
    }
}
