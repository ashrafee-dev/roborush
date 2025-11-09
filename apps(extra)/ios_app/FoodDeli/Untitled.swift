import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Here is Our App")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("A simple and beautiful SwiftUI project")
                .foregroundColor(.gray)
        }
        .padding()
    }
}
