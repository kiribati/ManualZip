//
//  IntroViewModel.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Foundation
import Combine
import FirebaseAuth

final class IntroViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loginAnonymously() {
        AuthService.shared.signInAnonymous()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
}
