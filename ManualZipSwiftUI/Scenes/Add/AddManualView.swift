//
//  AddManualView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData

struct AddManualView: View {
    @StateObject private var viewModel = AddManualViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("매뉴얼 정보")) {
                    TextField("매뉴얼 이름", text: $viewModel.name)
                }
                
                Section(header: Text("이미지")) {
                    
                }
                
                Section(header: Text("링크")) {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Link", text: .constant(""))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        
                        if let url = viewModel.board {
                            Button {
                                
                            } label: {
                                Text("$\(url) \n붙여넣기")
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                                
                            }
                        }
                    }
                }
            }
            .navigationTitle("새 매뉴얼 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss() // 현재 화면(모달)을 닫습니다.
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        if viewModel.save(context: modelContext) {
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                viewModel.checkClipboard()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewModel.checkClipboard()
            }
        }
    }
}

#Preview {
    AddManualView()
        .modelContainer(for: ManualItem.self, inMemory: true)
}
