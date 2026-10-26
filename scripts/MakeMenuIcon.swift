import AppKit

// Monochrome companion to the JotCove paper-and-cove emblem, drawn for the menu bar.
// Run from the repository root: swift scripts/MakeMenuIcon.swift
func drawGlyph() {
    NSColor.black.setStroke()
    let back = NSBezierPath()
    back.move(to: NSPoint(x: 4.2, y: 7.2))
    back.line(to: NSPoint(x: 3.4, y: 14.0))
    back.curve(to: NSPoint(x: 4.6, y: 15.5), controlPoint1: NSPoint(x: 3.3, y: 14.8), controlPoint2: NSPoint(x: 3.7, y: 15.4))
    back.line(to: NSPoint(x: 7.0, y: 15.8))
    back.lineWidth = 1.4; back.lineCapStyle = .round; back.lineJoinStyle = .round
    back.stroke()

    let note = NSBezierPath()
    note.move(to: NSPoint(x: 7.2, y: 6.5))
    note.line(to: NSPoint(x: 7.2, y: 16.3))
    note.curve(to: NSPoint(x: 8.3, y: 17.4), controlPoint1: NSPoint(x: 7.2, y: 17.0), controlPoint2: NSPoint(x: 7.6, y: 17.4))
    note.line(to: NSPoint(x: 12.1, y: 17.4))
    note.line(to: NSPoint(x: 15.5, y: 14.0))
    note.line(to: NSPoint(x: 15.5, y: 7.2))
    note.lineWidth = 1.4; note.lineCapStyle = .round; note.lineJoinStyle = .round
    note.stroke()
    let fold = NSBezierPath()
    fold.move(to: NSPoint(x: 12.0, y: 17.0)); fold.line(to: NSPoint(x: 12.0, y: 14.1)); fold.line(to: NSPoint(x: 15.0, y: 14.1))
    fold.lineWidth = 1.1; fold.lineCapStyle = .round; fold.lineJoinStyle = .round
    fold.stroke()

    let cove = NSBezierPath()
    cove.move(to: NSPoint(x: 2.0, y: 8.1))
    cove.curve(to: NSPoint(x: 18.0, y: 8.1), controlPoint1: NSPoint(x: 7.0, y: 5.3), controlPoint2: NSPoint(x: 13.0, y: 5.3))
    cove.line(to: NSPoint(x: 16.9, y: 3.8))
    cove.curve(to: NSPoint(x: 3.1, y: 3.8), controlPoint1: NSPoint(x: 15.0, y: 1.6), controlPoint2: NSPoint(x: 5.0, y: 1.6))
    cove.close()
    cove.lineWidth = 1.6; cove.lineCapStyle = .round; cove.lineJoinStyle = .round
    cove.stroke()
}
for scale in [1, 2] {
    let pixels = 20 * scale
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
                              bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
                              isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSColor.clear.setFill(); NSRect(x: 0, y: 0, width: pixels, height: pixels).fill()
    NSGraphicsContext.current!.cgContext.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
    drawGlyph()
    NSGraphicsContext.restoreGraphicsState()
    let suffix = scale == 1 ? "" : "@2x"
    try rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "Resources/MenuIcon\(suffix).png"))
}
