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
                .frame(minWidth: 800, minHeight: 700)  // GRÖSSERES Fenster: 800x700!
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
