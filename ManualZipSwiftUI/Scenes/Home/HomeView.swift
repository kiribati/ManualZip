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
                if manuals.isEmpty {
                    ContentUnavailableView("저장된 매뉴얼이 없어요".localized,
                                           systemImage: "book.closed",
                                           description: Text("오른쪽 위의 '+' 버튼을 눌러 첫 매뉴얼을 추가해보세요.".localized))
                } else {
                    ForEach(manuals) { manual in
                        NavigationLink(destination: {
                            let parameter = DetailViewModel.Parameter(item: manual)
                            let viewModel = DetailViewModel(parameter: parameter)
                            DetailView(viewModel: viewModel)
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
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            if let currentItem = manuals.safty(index) {
                                modelContext.delete(currentItem)
                            }
                        }
                    })
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
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: ManualItem.self, inMemory: true)
}
