//
//  PrivacyPolicySheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 30/01/2024.
//

import SwiftUI

struct PrivacyPolicySheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("NXLeave is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share your personal information when you use the NXLeave mobile application.")
                
            
            Text("Information We Collect")
                .font(.headline)
                .padding(.top, 10)
            
            VStack(alignment: .leading) {
                Text(
 """
 We collect the following types of information:
 • Personal Information: Information that identifies you personally, such as your name, email address, phone number, and employment information.
 • Device Information: Information about your device, such as your device ID, operating system, and IP address.
 • Usage Information: Information about how you use the NXLeave app, such as the dates and times you access the app, the features you use, and the leave requests you submit.
 """)
            }
            .padding(.top, 6)
            
            Text("How We Use Your Information")
                .font(.headline)
                .padding(.top, 10)
            
            VStack(alignment: .leading) {
                Text(
"""
We use your information to:
• Provide you with the NXLeave app and its features.
• Process your leave requests.
• Communicate with you about your leave requests and other app-related matters.
• Improve the NXLeave app and its features.
• Personalize your experience in the NXLeave app.
""")
            }
            
            Spacer()
        }
        .font(.callout)
        .padding()
        .padding(.top)
        .presentationDragIndicator(.visible)
    }
}

struct PrivacyPolicySheet_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicySheet()
    }
}
