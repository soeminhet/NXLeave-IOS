//
//  SectionHeader.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct SectionHeader: View {
    
    let title: String
    let viewAll: (() -> Void)?
    
    init(title: String, viewAll: @escaping () -> Void) {
        self.title = title
        self.viewAll = viewAll
    }
    
    init(title: String) {
        self.title = title
        self.viewAll = nil
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            if viewAll != nil {
                Text("View All")
                    .font(.caption)
                    .foregroundColor(Color.theme.blue)
                    .onTapGesture {
                        viewAll?()
                    }
            }
        }
        .padding(.vertical, 16)
        .background(Color(UIColor.systemBackground))
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SectionHeader(
                title: "Title"
            ) {}
            
            SectionHeader(title: "Just Title")
        }
            .previewLayout(.sizeThatFits)
    }
}
