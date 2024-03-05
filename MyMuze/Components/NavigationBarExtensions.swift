//
//  NavigationBarExtensions.swift
//  MyMuze
//
//  Created by Pete Potipitak on 2/19/24.
//

import SwiftUI

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        // Used to set the color of the title text in the navigation bar
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

extension View {
    func navigationBarTitleFont(size: CGFloat) -> some View {
        self.modifier(NavigationBarTitleFontModifier(size: size))
    }
}

struct NavigationBarTitleFontModifier: ViewModifier {
    var size: CGFloat

    init(size: CGFloat) {
        self.size = size
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                // Use the appearance API to set the font size for this view only
                UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: self.size, weight: .bold)]
            }
    }
}
