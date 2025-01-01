import SwiftUI

struct BackButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss() // Dismiss the view (Go back)
        }) {
            Image(systemName: "chevron.backward.circle.fill") // Back arrow icon
                .foregroundColor(.accentColor) // Customize back button color to black
        }
        .padding(.horizontal, 25)
    }
}

#Preview {
    BackButtonView()
}
