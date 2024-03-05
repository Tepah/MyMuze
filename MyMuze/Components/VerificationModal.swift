//
//  VerificationModal.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/3/24.
//

import SwiftUI

struct VerificationModal: View {
    @State var verificationCode = ""
    @State var inputError = false
    
    var body: some View {
        BackgroundView()
            .overlay(
            VStack {
                Text("Verify your phone")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                TextField("XXXXXXX", text: $verificationCode)
                    .frame(width: 300)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .shadow(radius: 5)
            }
            .frame(width: 350, height: 170)
            .background(Color(hex: 0x494949))
            .cornerRadius(10)
            .alert(isPresented: $inputError) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("The code you entered is invalid. Please try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    handleVerify()
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 50))
                        .foregroundColor(Color.myMuzeAccent)
                }
                .offset(x:0, y: 30)
                
            }
            .navigationBarItems(leading:
                Button(action: {
                    
                }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.white)
                }
            )
        )
    }
    
    func handleVerify() {
        inputError = verifyCode(verificationCode)
    }
    
}

#Preview {
    VerificationModal()
}
