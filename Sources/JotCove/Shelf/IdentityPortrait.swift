import SwiftUI

/// The supplied portrait stays local and ships with the app; no remote image loading.
struct IdentityPortrait: View {
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle().fill(Color.paperBlue)
            if let portrait = Theme.portrait {
                Image(nsImage: portrait).resizable().interpolation(.high).scaledToFit()
                    .scaleEffect(1.12).offset(y: size * 0.06)
            } else {
                Text("E").font(.script(size * 0.6)).foregroundStyle(Color.ink)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.paper.opacity(0.7), lineWidth: 1.5))
        .accessibilityHidden(true)
    }
}
