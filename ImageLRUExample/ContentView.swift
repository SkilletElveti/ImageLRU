//
//  ContentView.swift
//  ImageLRUExample
//
//  Created by Shubham Kamdi on 3/24/24.
//

import SwiftUI
import ImageLRU
struct ContentView: View {
    @StateObject var vm = ViewModel()
    @State var dataLRU: [Int] = []
    @State var dataToEnter: String = ""
    var body: some View {
        List() {
            HStack {
                Spacer().frame(width: 20)
                Text("Add Data")
                Spacer()
                TextField("Add to LRU", text: $dataToEnter)
                
                Spacer().frame(width: 20)
            }.submitLabel(.done)
                .onSubmit {
                    vm.addData(Int(dataToEnter)!)
                    dataToEnter = ""
                    vm.ver2GetData()
                }
            ForEach(dataLRU, id: \.self) { i in
                Text("\(i)")
            }
        }.listStyle(InsetGroupedListStyle())
            .onReceive(vm.$dataPUB, perform: { data in
                if data.count > 0 {
                    withAnimation {
                        self.dataLRU = data
                        print("Data: \(dataLRU)")
                    }
                }
            }).onAppear(perform: {
                vm.setQuatity()
                vm.downloadImage()
            })
    }
}

class ViewModel: ObservableObject {
    var source = LRUSwift.shared
    var src2 = LRUV2.shared
    @Published var dataPUB: [Int] = []
    func getAllData() {
        Task {
            let data = await source.getAllData() ?? []
            await MainActor.run { self.dataPUB = data }
        }
    }
    
    func addData(_ data: Int) {
//        Task { await source.put(data) }
        src2.put(data, data)
    }
    
    func setQuatity() {
        src2.set(10)
    }
    
    func ver2GetData() {
        dataPUB = []
        dataPUB = src2.getData()
    }
    
    func downloadImage() {
        Task {
            await ImageDL.utility.download(image: URL(string: "https://picsum.photos/200/300")!)
        }
        
    }
}

#Preview {
    ContentView()
}
