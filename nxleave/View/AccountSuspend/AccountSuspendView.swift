//
//  AccountSuspendView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 09/02/2024.
//

import SwiftUI
import Lottie

struct AccountSuspendView: View {
    
    @AppStorage("uid") var uid: String = ""
    @EnvironmentObject var router: Router
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack {
            LottieView(name: "plant")
                .frame(width: screenWidth, height: screenWidth)
            
            Text("Account Disabled")
                .font(.title)
            
            Text("Your employment account appears\rto be disabled.")
                .multilineTextAlignment(.center)
                .font(.callout)
            
            Spacer()
            
            Button {
                uid = ""
                router.navigateToRoot()
                router.navigate(to: "Onboard")
            } label: {
                Text("LOGOUT")
                    .frame(maxWidth: .infinity)
                    .padding(10)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

struct AccountSuspendView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSuspendView()
            .environmentObject(Router())
    }
}

struct LottieView: UIViewRepresentable {
    let name: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
