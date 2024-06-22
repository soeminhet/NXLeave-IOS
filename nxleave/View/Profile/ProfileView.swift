//
//  ProfileView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 29/01/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("uid") var uid: String = ""
    @Environment(\.openURL) var openURL
    @EnvironmentObject private var router: Router
    @Environment(\.accessLevel) var accessLevel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showLogout: Bool = false
    @State private var showContactUs: Bool = false
    @State private var showPrivacyPolicy: Bool = false
    @State private var showPhone: Bool = false
    @State private var showEmail: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            profileHeader
                
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    if accessLevel != AccessLevel.none {
                        Section {
                            ProfileItem(icon: "LeaveTypes", name: "Leave Types")
                                .onTapGesture {
                                    router.navigate(to: "LeaveTypes")
                                }
                            ProfileItem(icon: "Roles", name: "Roles")
                                .onTapGesture {
                                    router.navigate(to: "Roles")
                                }
                            ProfileItem(icon: "Projects", name: "Projects")
                                .onTapGesture {
                                    router.navigate(to: "Projects")
                                }
                            ProfileItem(icon: "LeaveBalances", name: "LeaveBalance")
                                .onTapGesture {
                                    router.navigate(to: "LeaveBalances")
                                }
                            ProfileItem(icon: "Staves", name: "Staves")
                                .onTapGesture {
                                    router.navigate(to: "Staves")
                                }
                            ProfileItem(icon: "Events", name: "Events")
                                .onTapGesture {
                                    router.navigate(to: "Events")
                                }
                            ProfileItem(icon: "Report", name: "Report")
                                .onTapGesture {
                                    router.navigate(to: "Report")
                                }
                        } header: {
                            Text("Management")
                                .padding(.all)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.theme.whiteGray)
                        }
                    }
                    
                    Section {
                        ProfileItem(icon: "Staves", name: "Assigned team")
                            .onTapGesture {
                                router.navigate(to: "AssignedTeam")
                            }
                        ProfileItem(icon: "UpcomingEvents", name: "Upcoming events")
                            .onTapGesture {
                                router.navigate(to: "UpcomingEvents")
                            }
                    } header: {
                        Text("Management")
                            .padding(.all)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme.whiteGray)
                    }
                    
                    Section {
                        ProfileItem(icon: "PrivacyPolicy", name: "Privacy Policy")
                            .onTapGesture {
                                showPrivacyPolicy.toggle()
                            }
                        ProfileItem(icon: "ContactUs", name: "Contact us")
                            .onTapGesture {
                                showContactUs.toggle()
                            }
                        ProfileItem(icon: "Logout", name: "Log out")
                            .onTapGesture {
                                showLogout.toggle()
                            }
                    } header: {
                        Text("Management")
                            .padding(.all)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme.whiteGray)
                    }
                    
                    Text("NXLeave Version 1.0.0")
                        .padding()
                        .font(.footnote)
                }
            }
        }
        .background(Color.theme.whiteGray)
        .onAppear {
            viewModel.fetchCurrentStaff(uid: uid)
        }
        .alert(isPresented: $showLogout) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure want to logout?"),
                primaryButton: .default(Text("Logout"), action: {
                    DispatchQueue.main.async {
                        uid = ""
                        router.navigateToRoot()
                        router.navigate(to: "Onboard")
                    }
                }),
                secondaryButton: .cancel()
            )
        }
        .confirmationDialog("", isPresented: $showContactUs) {
            Button("EMAIL") { sendEmail() }
            Button("PHONE") { callPhone() }
            Button("CANCEL", role: .cancel){}
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicySheet()
        }
        .alert("This device does not support phone call", isPresented: $showPhone) {
            Button("OK", role: .cancel){}
        }
        .alert("This device does not support email", isPresented: $showEmail) {
            Button("OK", role: .cancel){}
        }
    }
    
    func sendEmail() {
        guard let url = URL(string: "mailto:nxleave2023@gmail.com") else { return }
        openURL(url) { accepted in
            if !accepted {
                showEmail.toggle()
            }
        }
    }
    
    func callPhone() {
        let telephone = "tel://09111222333"
        guard let url = URL(string: telephone) else { return }
        UIApplication.shared.open(url) { completion in
            if !completion {
                showPhone.toggle()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(Router())
    }
}

extension ProfileView {
    private var profileHeader: some View {
        ZStack(alignment: .topTrailing) {
            Image("bgProfile")
                .resizable()
                .cornerRadius(20)
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.1),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.5)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Spacer()
                
                AsyncImage(url: URL(string: viewModel.staff?.photo ?? "")) { image in
                    image
                        .resizable()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .strokeBorder(.black, lineWidth: 1)
                        .background(Circle().fill(Color.theme.placeholder))
                        .frame(width: 90, height: 90)
                    
                }
                
                Text(viewModel.staff?.name ?? "Unkown")
                    .padding(.leading, 6)
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(viewModel.staffRole?.name ?? "Unknown")
                    .padding(.leading, 6)
                    .foregroundColor(.white)
                    .font(.footnote)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                router.navigate(to: "EditProfile")
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
            }
            .clipShape(Capsule())
            .tint(.white)
            .foregroundColor(.black)
            .buttonStyle(.borderedProminent)
            .padding(.top, 60)
            .padding(.trailing, 14)
        }
        .ignoresSafeArea()
        .frame(height: 200, alignment: .topTrailing)
    }
}
