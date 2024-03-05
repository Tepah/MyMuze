//
//  PhoneSignInView.swift
//  MyMuze
//
//  Created by Pete Potipitak on 3/4/24.
//

import SwiftUI
import Combine

struct PhoneSignInView: View {
    @State private var phone1: String = ""
    @State private var phone2: String = ""
    @State private var phone3: String = ""
    @State private var inputError: Bool = false
    @State private var verificationModalPresented = false
    
    private var phoneLimit3 = 4
    
    @FocusState private var focusedField: Field?
    enum Field: Int, Hashable {
       case phone1
       case phone2
       case phone3
    }

    var body: some View {
        BackgroundView()
            .overlay(
                VStack {
                    HStack {
                        TextField("(XXX)", text: $phone1)
                            .focused($focusedField, equals: .phone1)
                            .foregroundColor(Color.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: phone1) { _ in
                                if phone1.count == 3 {
                                    self.focusNextField($focusedField)
                                }
                            }
                        Text("-")
                            .foregroundColor(.white)
                        TextField("XXX", text: $phone2)
                            .focused($focusedField, equals: .phone2)
                            .foregroundColor(Color.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: phone2) { _ in
                                if phone2.count == 3 {
                                    self.focusNextField($focusedField)
                                }
                            }
                        Text("-")
                            .foregroundColor(.white)
                        TextField("XXXX", text: $phone3)
                            .focused($focusedField, equals: .phone3)
                            .foregroundColor(Color.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onReceive(Just(phone3)) { _ in limitText(phoneLimit3) }
                    }
                    .frame(width: 275)
                    Rectangle()
                        .foregroundColor(Color.myMuzeAccent)
                        .frame(width:100, height:50)
                        .padding(20)
                        .overlay(
                            Button("Get Text") {
                                if (phone1 + phone2 + phone3).count == 10 {
                                    verifyPhoneSignIn("+1"+phone1+phone2+phone3)
                                    verificationModalPresented = true
                                } else {
                                    inputError = true
                                }
                            }
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                        )
                }
                .alert(isPresented: $inputError) {
                    Alert(
                        title: Text("Invalid Input"),
                        message: Text("Please make sure all fields are filled out correctly."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .sheet(isPresented: $verificationModalPresented) {
                    VerificationModal()
                }
            )
    }
    
    func limitText(_ upper: Int) {
        if phone3.count > upper {
            phone3 = String(phone3.prefix(upper))
        }
    }
}

#Preview {
    PhoneSignInView()
}
