//
//  EditProfileView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 03/02/2024.
//
import PhotosUI
import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = EditProfileViewModel()
    @State private var name: String = ""
    @State private var phonenumber: String = ""
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var data: Data?
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("NXLeave")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.blackVarient)
                    
                    Text("Take flight from paperwork.")
                        .font(.caption)
                        .foregroundColor(Color.theme.blackVarient)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                ZStack(alignment: .bottomTrailing) {
                    if let data = data,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 90, height: 90)
                            .border(Color.black, width: 1)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: viewModel.staff?.photo ?? "")) { image in
                            image
                                .resizable()
                                .frame(width: 90, height: 90)
                                .border(Color.black, width: 1)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .strokeBorder(.black, lineWidth: 1)
                                .background(Circle().fill(Color.theme.placeholder))
                                .frame(width: 90, height: 90)
                            
                        }
                    }
                    
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Image(systemName: "camera")
                            .foregroundColor(.black)
                            .padding(.all, 10)
                            .background(.yellow)
                            .clipShape(Circle())
                            .offset(x: CGFloat(10), y: CGFloat(10))
                    }
                }
                .padding(.vertical, 30)
                
                NXTextField("Name", text: $name)
                
                NXTextField("PhoneNumber", text: $phonenumber)
                    .padding(.top)
                    .keyboardType(.phonePad)
                
                Button {
                    Task {
                        let success = await viewModel.updateStaff(name: name, phonenumber: phonenumber, data: data)
                        if success {
                            router.navigateBack()
                        }
                    }
                } label: {
                    Text("UPDATE")
                        .frame(maxWidth: .infinity)
                        .padding(.all, 10)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
                
                Spacer()
            }
                .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        
        .task {
            await viewModel.fetchStaff()
        }
        .onChange(of: viewModel.staff) { value in
            self.name = value?.name ?? ""
            self.phonenumber = value?.phoneNumber ?? ""
        }
        .onChange(of: pickerItem) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    self.data = data
                } else {
                    print("Failed")
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(Router())
    }
}
