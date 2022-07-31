//
//  ContentView.swift
//  Periodic Elements
//
//  Created by Yuna on 7/29/22.
//

import SwiftUI

struct ContentView: View {
    @State private var elements = [Element]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(elements) { element in
                NavigationLink(
                    destination: VStack {
                        Text(element.name)
                            .padding()
                        Text(element.symbol)
                            .padding()
                        Text(element.history)
                            .padding()
                        Text(element.facts)
                            .padding()
                    },
                    label: {
                        HStack {
                            Text(element.symbol)
                            Text(element.name)
                        }
                    })
            }
            .navigationTitle("Periodic Elements")
        }
        .onAppear(perform: {
            queryAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    func queryAPI () {
        let apiKey = "?rapidapi-key=c3a03858eemsh44e25a59e7f8d85p1bd4f1jsn25e033ef83d0"
        let query = "https://periodictable.p.rapidapi.com\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                    let contents = json.arrayValue
                    for item in contents {
                        let name = item["name"].stringValue
                        let symbol = item["symbol"].stringValue
                        let facts = item["facts"].stringValue
                        let history = item["history"].stringValue
                        let element = Element(symbol: symbol, name: name, history: history, facts: facts)
                        elements.append(element)
                    }
                    return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Element: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let history: String
    let facts: String
}
