import SwiftUI

extension Font {
    public static let minecraftLargeTitleRegular = Font.custom("Minecraft-Regular", size: 22, relativeTo: .largeTitle)
    public static let minecraftTitleRegular = Font.custom("Minecraft-Regular", size: 18, relativeTo: .title)
    public static let minecraftHeadlineRegular = Font.custom("Minecraft-Regular", size: 14, relativeTo: .headline)
    public static let minecraftSubheadlineRegular = Font.custom("Minecraft-Regular", size: 10, relativeTo: .subheadline)
    public static let minecraftBodyRegular = Font.custom("Minecraft-Regular", size: 8, relativeTo: .body)

    public static let minecraftLargeTitleBold = Font.custom("Minecraft-Bold", size: 22, relativeTo: .largeTitle)
    public static let minecraftTitleBold = Font.custom("Minecraft-Bold", size: 18, relativeTo: .title)
    public static let minecraftHeadlineBold = Font.custom("Minecraft-Bold", size: 14, relativeTo: .headline)
    public static let minecraftSubheadlineBold = Font.custom("Minecraft-Bold", size: 10, relativeTo: .subheadline)
    public static let minecraftBodyBold = Font.custom("Minecraft-Bold", size: 8, relativeTo: .body)

    public static let minecraftLargeTitleItalic = Font.custom("Minecraft-Italic", size: 22, relativeTo: .largeTitle)
    public static let minecraftTitleItalic = Font.custom("Minecraft-Italic", size: 18, relativeTo: .title)
    public static let minecraftHeadlineItalic = Font.custom("Minecraft-Italic", size: 18, relativeTo: .headline)
    public static let minecraftSubheadlineItalic = Font.custom("Minecraft-Italic", size: 10, relativeTo: .subheadline)
    public static let minecraftBodyItalic = Font.custom("Minecraft-Italic", size: 8, relativeTo: .body)

    public static let minecraftLargeTitleBoldItalic = Font.custom("Minecraft-BoldItalic", size: 22, relativeTo: .largeTitle)
    public static let minecraftTitleBoldItalic = Font.custom("Minecraft-BoldItalic", size: 18, relativeTo: .title)
    public static let minecraftHeadlineBoldItalic = Font.custom("Minecraft-BoldItalic", size: 18, relativeTo: .headline)
    public static let minecraftSubheadlineBoldItalic = Font.custom("Minecraft-BoldItalic", size: 10, relativeTo: .subheadline)
    public static let minecraftBodyBoldItalic = Font.custom("Minecraft-BoldItalic", size: 8, relativeTo: .body)
}

public enum CustomFonts {
    public static func registerCustomFonts() {
        for font in ["MinecraftBold.otf", "MinecraftBoldItalic.otf", "MinecraftItalic.otf", "MinecraftRegular.otf"] {
            guard let url = Bundle.module.url(forResource: font, withExtension: nil) else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

extension View {
    /// Attach this to any Xcode Preview's view to have custom fonts displayed
    /// Note: Not needed for the actual app
    public func loadCustomFonts() -> some View {
        CustomFonts.registerCustomFonts()
        return self
    }
}
