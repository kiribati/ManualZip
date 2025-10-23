//
//  HomeView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var manuals: [ManualItem]
    
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddSheet = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                if filteredManuals.isEmpty {
                    ContentUnavailableView("저장된 매뉴얼이 없어요".localized,
                                           systemImage: "book.closed",
                                           description: Text("오른쪽 위의 '+' 버튼을 눌러 첫 매뉴얼을 추가해보세요.".localized))
                } else {
                    ForEach(filteredManuals) { manual in
                        NavigationLink(destination: {
                            DetailView(item: manual)
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(manual.name)
                                    .font(.headline)
                                Text(manual.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        })
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("내 매뉴얼".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddManualView()
            }
            .navigationTitle("내 매뉴얼".localized)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        }
        .background(.ultraThinMaterial)
    }
    
    private var filteredManuals: [ManualItem] {
        if searchText.isEmpty {
            return manuals
        } else {
            // Swift 표준 필터링을 사용하여 UI 스레드에서 필터링
            // (대규모 데이터가 아닐 경우 이 방법이 간편합니다.)
            return manuals.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { manuals[$0] }.forEach(modelContext.delete)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: ManualItem.self, inMemory: true)
}
