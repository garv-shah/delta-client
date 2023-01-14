import SwiftUI

extension Font {
    public static let minecraftLargeTitleRegular = Font.custom("MinecraftRegular", size: 38, relativeTo: .largeTitle)
    public static let minecraftTitleRegular = Font.custom("MinecraftRegular", size: 34, relativeTo: .title)
    public static let minecraftHeadlineRegular = Font.custom("MinecraftRegular", size: 32, relativeTo: .headline)
    public static let minecraftSubheadlineRegular = Font.custom("MinecraftRegular", size: 22, relativeTo: .subheadline)
    public static let minecraftBodyRegular = Font.custom("MinecraftRegular", size: 18, relativeTo: .body)

    public static let minecraftLargeTitleBold = Font.custom("MinecraftBold", size: 38, relativeTo: .largeTitle)
    public static let minecraftTitleBold = Font.custom("MinecraftBold", size: 34, relativeTo: .title)
    public static let minecraftHeadlineBold = Font.custom("MinecraftBold", size: 32, relativeTo: .headline)
    public static let minecraftSubheadlineBold = Font.custom("MinecraftBold", size: 22, relativeTo: .subheadline)
    public static let minecraftBodyBold = Font.custom("MinecraftBold", size: 18, relativeTo: .body)

    public static let minecraftLargeTitleItalic = Font.custom("MinecraftItalic", size: 38, relativeTo: .largeTitle)
    public static let minecraftTitleItalic = Font.custom("MinecraftItalic", size: 34, relativeTo: .title)
    public static let minecraftHeadlineItalic = Font.custom("MinecraftItalic", size: 32, relativeTo: .headline)
    public static let minecraftSubheadlineItalic = Font.custom("MinecraftItalic", size: 22, relativeTo: .subheadline)
    public static let minecraftBodyItalic = Font.custom("MinecraftItalic", size: 18, relativeTo: .body)

    public static let minecraftLargeTitleBoldItalic = Font.custom("MinecraftBoldItalic", size: 38, relativeTo: .largeTitle)
    public static let minecraftTitleBoldItalic = Font.custom("MinecraftBoldItalic", size: 34, relativeTo: .title)
    public static let minecraftHeadlineBoldItalic = Font.custom("MinecraftBoldItalic", size: 32, relativeTo: .headline)
    public static let minecraftSubheadlineBoldItalic = Font.custom("MinecraftBoldItalic", size: 22, relativeTo: .subheadline)
    public static let minecraftBodyBoldItalic = Font.custom("MinecraftBoldItalic", size: 18, relativeTo: .body)
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
