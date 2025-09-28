//
//  AddManualView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData

struct AddManualView: View {
    // ViewModel을 이 View의 상태로 관리합니다.
    // View가 살아있는 동안 ViewModel 인스턴스가 유지됩니다.
    @StateObject private var viewModel = AddManualViewModel()
    
    // 데이터를 저장하기 위한 ModelContext
    @Environment(\.modelContext) private var modelContext
    
    // 모달을 닫기 위한 dismiss 액션
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("매뉴얼 정보")) {
                    TextField("매뉴얼 이름", text: $viewModel.name)
                }
            }
            .navigationTitle("새 매뉴얼 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 취소 버튼
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss() // 현재 화면(모달)을 닫습니다.
                    }
                }
                // 저장 버튼
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        // ViewModel의 save 함수를 호출하고 성공하면 화면을 닫습니다.
                        if viewModel.save(context: modelContext) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddManualView()
        .modelContainer(for: ManualItem.self, inMemory: true)
}
