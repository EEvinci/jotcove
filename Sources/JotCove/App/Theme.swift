import AppKit

/// One place for the look: brown desk, cream paper, light-blue accent, ink type.
enum Theme {

    // Evinci's stationery: cocoa, mist blue and warm greige; small pastel accents.
    private static func rgb(_ hex: UInt32) -> NSColor {
        NSColor(srgbRed: CGFloat((hex >> 16) & 255) / 255,
                green: CGFloat((hex >> 8) & 255) / 255,
                blue: CGFloat(hex & 255) / 255, alpha: 1)
    }
    static let purple = rgb(0xB8A8C4)
    static let brown = rgb(0x4B382F)
    static let brownDeep = rgb(0x352A25)
    static let paper = rgb(0xF0ECE4)
    static let paperDim = rgb(0xE2DAD0)
    static let paperBlue = rgb(0xBDCDD5)
    static let paperBlueDeep = rgb(0x4A687A)
    static let ink = rgb(0x3E3029)
    static let inkMuted = rgb(0x716257)
    static let onBrown = rgb(0xF3EDE3)
    static let onBrownMuted = rgb(0xC9BAAD)
    static let lavender = rgb(0xC8B9D4)
    static let butter = rgb(0xE7CA7F)
    static let mint = rgb(0xB9CDBB)
    static let sage = rgb(0xCED5B3)
    static let portrait = resource("Identity/EvinciPortrait.png")
    static let character = resource("Identity/EvinciCharacter.png")

    /// Serif for the paper theme (Songti SC covers CJK and Latin).
    nonisolated(unsafe) private static var fontCache: [String: NSFont] = [:]
    private static func cachedFont(_ key: String, _ make: () -> NSFont) -> NSFont {
        if let f = fontCache[key] { return f }
        let f = make(); fontCache[key] = f; return f
    }
    static func serif(size: CGFloat, bold: Bool = false) -> NSFont {
        cachedFont("serif\(bold ? "b" : "")\(size)") {
            NSFont(name: bold ? "STSongti-SC-Bold" : "STSongti-SC-Regular", size: size) ?? .systemFont(ofSize: size, weight: bold ? .bold : .regular)
        }
    }
    /// Handwritten script: Caveat for Latin, falling back to 翩翩体 for CJK.
    static func script(size: CGFloat) -> NSFont {
        _ = brandRegistered
        return cachedFont("script\(size)") {
            let cjk = NSFontDescriptor(fontAttributes: [.name: "HanziPenSC-W5"])
            let d = NSFontDescriptor(fontAttributes: [.name: "Caveat-Regular", .cascadeList: [cjk]])
            return NSFont(descriptor: d, size: size) ?? HandFont.font(size: size)
        }
    }

    /// Faint grain, tiled over paper and ground so nothing looks flat.
    static let noiseTile: NSImage = {
        let n = 96
        var bytes = [UInt8](repeating: 0, count: n * n * 4)
        var g = Seeded(20260912)
        for i in stride(from: 0, to: bytes.count, by: 4) {
            let v = UInt8(truncatingIfNeeded: g.next() % 256)
            bytes[i] = v; bytes[i + 1] = v; bytes[i + 2] = v; bytes[i + 3] = 255
        }
        let provider = CGDataProvider(data: Data(bytes) as CFData)!
        let cg = CGImage(width: n, height: n, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: n * 4,
                         space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
                         provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
        return NSImage(cgImage: cg, size: CGSize(width: n, height: n))
    }()

    /// Paper / desk with the grain already multiplied in. SwiftUI tiles these as `ImagePaint`;
    /// a live `blendMode(.multiply)` per card forced an offscreen pass for every card on every frame.
    static let paperTile = bakedTile(paper, grain: 0.035)
    static let paperBlueTile = bakedTile(paperBlue, grain: 0.035)
    static let deskTile = bakedTile(brown, grain: 0.07)
    private static func bakedTile(_ color: NSColor, grain: CGFloat) -> NSImage {
        let n = noiseTile.size
        return NSImage(size: n, flipped: false) { r in
            color.setFill(); r.fill()
            drawGrain(in: r, opacity: grain)
            return true
        }
    }

    /// App icons for the cards, desaturated once and cached per bundle id; a Launch Services lookup per body was the lag.
    private static var iconCache: [String: NSImage?] = [:]
    static func cardIcon(bundleID: String?) -> NSImage? {
        guard let bundleID else { return nil }
        if bundleID == AppIdentity.bundleIdentifier { return logo }
        if let hit = iconCache[bundleID] { return hit }
        var made: NSImage?
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
            let src = NSWorkspace.shared.icon(forFile: url.path)
            src.size = CGSize(width: 44, height: 44)
            made = NSImage(size: src.size, flipped: false) { r in
                src.draw(in: r)
                // Grey it down so the paper stays quiet, keep the alpha.
                NSColor(calibratedWhite: 0.45, alpha: 1).set()
                r.fill(using: .color)
                src.draw(in: r, from: .zero, operation: .destinationIn, fraction: 1)
                return true
            }
        }
        iconCache[bundleID] = made
        return made
    }



    /// Product logo (Resources/Logo.png). Falls back to the source tree so self-tests find it too.
    static let logo: NSImage? = resource("Logo.png")
    /// The one piece of stationery: a pink pushpin on the card that is currently on the clipboard.
    static let pushpin: NSImage? = resource("Pushpin.png")
    /// Brand typeface (Ysabeau Office, OFL) bundled in Resources/Fonts; registered for this process on first use.
    /// `swift run` / self-tests: the executable sits in .build/<config>/, three levels under the package root.
    /// Derived at run time so no build-machine path is compiled into the binary.
    private static let devResources: URL = Bundle.main.executableURL!.deletingLastPathComponent().deletingLastPathComponent()
        .deletingLastPathComponent().appendingPathComponent("Resources", isDirectory: true)
    private static let brandRegistered: Bool = {
        let dev = devResources.appendingPathComponent("Fonts")
        var any = false
        for name in ["YsabeauOffice.ttf", "Caveat.ttf"] {
            for dir in [Bundle.main.resourceURL?.appendingPathComponent("Fonts"), dev].compactMap({ $0 }) {
                let url = dir.appendingPathComponent(name)
                if FileManager.default.fileExists(atPath: url.path), CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) { any = true; break }
            }
        }
        return any
    }()
    /// Brand wordmark: the handwritten script.
    static func brandFont(size: CGFloat) -> NSFont { script(size: size) }

    /// Menu bar glyph (JotCove paper-and-cove emblem, 1x + 2x). Template: macOS tints it for light / dark menu bars.
    static let menuIcon: NSImage? = {
        guard let base = resource("MenuIcon.png") else { return nil }
        let img = NSImage(size: CGSize(width: 20, height: 20))
        for rep in base.representations { img.addRepresentation(rep) }
        if let hi = resource("MenuIcon@2x.png") {
            for rep in hi.representations { rep.size = CGSize(width: 20, height: 20); img.addRepresentation(rep) }
        }
        img.isTemplate = true
        return img
    }()

    private static func resource(_ name: String) -> NSImage? {
        if let url = Bundle.main.resourceURL?.appendingPathComponent(name), let img = NSImage(contentsOf: url) { return img }
        return NSImage(contentsOf: devResources.appendingPathComponent(name))
    }

    // MARK: Paper (AppKit side). The SwiftUI shelf paints the same tokens; these are for the capture bars and windows.

    static let paperRadius: CGFloat = 6
    static let paperLine = NSColor(srgbRed: 0.16, green: 0.14, blue: 0.13, alpha: 0.28)   // faint ink outline on paper

    /// Grain: multiply the noise tile over whatever was just painted.
    static func drawGrain(in r: CGRect, opacity: CGFloat) {
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current?.compositingOperation = .multiply
        NSGraphicsContext.current?.cgContext.setAlpha(opacity)
        NSColor(patternImage: noiseTile).setFill()
        NSBezierPath(rect: r).fill()
        NSGraphicsContext.restoreGraphicsState()
    }

    /// A sheet of paper: fill, grain, hairline ink edge — clipped to `path`.
    static func drawPaper(_ path: NSBezierPath, fill: NSColor = paper) {
        NSGraphicsContext.saveGraphicsState()
        path.addClip()
        fill.setFill()
        path.bounds.fill()
        drawGrain(in: path.bounds, opacity: 0.045)
        NSGraphicsContext.restoreGraphicsState()
        paperLine.setStroke()
        path.lineWidth = 1
        path.stroke()
    }

    /// Capture chrome: the same brown frosted ground as the shelf, cut into a strip, with a faint light edge.
    static func drawDesk(_ path: NSBezierPath) {
        NSGraphicsContext.saveGraphicsState()
        path.addClip()
        brown.setFill()
        path.bounds.fill()
        drawGrain(in: path.bounds, opacity: 0.07)
        NSGraphicsContext.restoreGraphicsState()
        onBrown.withAlphaComponent(0.22).setStroke()
        path.lineWidth = 1
        path.stroke()
    }

    static func deskDivider(height: CGFloat = 24) -> NSView {
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = onBrown.withAlphaComponent(0.25).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 1).isActive = true
        v.heightAnchor.constraint(equalToConstant: height).isActive = true
        return v
    }

    /// The brown desk the paper sits on (window grounds).
    static func drawGround(in r: CGRect) {
        brown.setFill()
        r.fill()
        drawGrain(in: r, opacity: 0.07)
    }

    /// Paper card with a soft shadow on its layer; `drawPaper` paints the face.
    static func paperSheet(_ v: NSView, radius: CGFloat = paperRadius) {
        v.wantsLayer = true
        v.layer?.cornerRadius = radius
        let s = NSShadow()
        s.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.4)
        s.shadowBlurRadius = 8
        s.shadowOffset = CGSize(width: 1, height: -4)
        v.shadow = s
    }

    /// Buttons in the paper look. `primary`: blue paper chip with ink text. Otherwise an outlined pill;
    /// `onGround` decides whether the outline is ink (on paper) or cream (on the brown desk).
    static func paperButton(_ title: String, primary: Bool = false, onGround: Bool = false, target: AnyObject?, action: Selector) -> NSButton {
        let b = NSButton(title: title, target: target, action: action)
        b.isBordered = false
        let ink = primary ? Theme.ink : (onGround ? onBrown : Theme.ink)
        b.attributedTitle = NSAttributedString(string: title, attributes: [.foregroundColor: ink, .font: serif(size: 14, bold: true)])
        b.wantsLayer = true
        b.layer?.cornerRadius = 17
        b.layer?.backgroundColor = primary ? paperBlue.cgColor : nil
        b.layer?.borderWidth = primary ? 0 : 1
        b.layer?.borderColor = (onGround ? onBrown.withAlphaComponent(0.45) : Theme.ink.withAlphaComponent(0.55)).cgColor
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 34).isActive = true
        let w = b.attributedTitle.size().width + 40
        b.widthAnchor.constraint(equalToConstant: max(88, w.rounded(.up))).isActive = true
        return b
    }
}
