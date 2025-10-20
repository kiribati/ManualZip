//
//  HomeView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \ManualItem.createdAt, order: .reverse) private var manuals: [ManualItem]
    
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                // manuals 배열에 데이터가 없으면 안내 문구를 보여줌.
                if manuals.isEmpty {
                    ContentUnavailableView("저장된 매뉴얼이 없어요",
                                           systemImage: "book.closed",
                                           description: Text("오른쪽 위의 '+' 버튼을 눌러 첫 매뉴얼을 추가해보세요."))
                } else {
                    ForEach(manuals) { manual in
                        VStack(alignment: .leading) {
                            Text(manual.name)
                                .font(.headline)
                            Text(manual.createdAt, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteManual) // 스와이프하여 삭제하는 기능
                }
            }
            .navigationTitle("내 매뉴얼")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddSheet = true // 버튼을 누르면 isShowingAddSheet이 true로 변경
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddManualView()
            }
        }
    }
    
    // 리스트에서 항목을 삭제하는 함수
    private func deleteManual(at offsets: IndexSet) {
        for index in offsets {
            let manualToDelete = manuals[index]
            modelContext.delete(manualToDelete)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: ManualItem.self, inMemory: true)
}
