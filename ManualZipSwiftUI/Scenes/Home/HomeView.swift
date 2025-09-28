//
//  HomeView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    // SwiftData가 관리하는 Manual 데이터를 가져옵니다.
    // createdAt 기준으로 최신순으로 정렬합니다.
    @Query(sort: \ManualItem.createdAt, order: .reverse) private var manuals: [ManualItem]
    
    // ModelContext는 데이터 추가, 삭제 등 작업을 위해 필요합니다.
    @Environment(\.modelContext) private var modelContext
    
    // '+ 버튼'을 눌렀을 때 AddManualView를 모달로 띄우기 위한 상태 변수
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                // manuals 배열에 데이터가 없으면 안내 문구를 보여줍니다.
                if manuals.isEmpty {
                    ContentUnavailableView("저장된 매뉴얼이 없어요",
                                           systemImage: "book.closed",
                                           description: Text("오른쪽 위의 '+' 버튼을 눌러 첫 매뉴얼을 추가해보세요."))
                } else {
                    // ForEach를 사용해 목록을 만듭니다.
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
                // 네비게이션 바 오른쪽에 '+' 버튼 추가
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddSheet = true // 버튼을 누르면 isShowingAddSheet이 true로 변경
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // isShowingAddSheet이 true일 때 모달(sheet)을 띄웁니다.
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
