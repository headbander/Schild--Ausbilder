//
//  TXTtoCSVConverterApp.swift
//  TXTtoCSVConverter
//
//  macOS native App zum Konvertieren von TXT zu CSV mit Klassenfilter
//

import SwiftUI

@main
struct TXTtoCSVConverterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, idealWidth: 1000, maxWidth: .infinity,
                       minHeight: 700, idealHeight: 800, maxHeight: .infinity)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
