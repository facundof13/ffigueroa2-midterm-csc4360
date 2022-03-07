//
//  LogoutView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import SwiftUI

struct LogoutView: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.left.circle.fill")
            Text("Logout")
        }
    }
}

struct LogoutView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutView()
    }
}
