//
//  IntroView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI

struct IntroView: View {
    var onFinish: () -> Void
    @StateObject private var viewModel: IntroViewModel = .init()
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 5) {
                    Text("Save Find Share Manuals".localized)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.loginAnonymously()
            }
        }
        .onChange(of: viewModel.user, { oldValue, newValue in
            if let _ = newValue {
                print("login successed")
                onFinish()
            }
        })
        .padding()
    }
}

#Preview {
    IntroView {
        
    }
}
