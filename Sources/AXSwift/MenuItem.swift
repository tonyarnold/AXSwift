import AppKit

open class MenuItem: UIElement {
    open func commandCharacter() throws -> String? {
        return try attribute("AXMenuItemCmdChar")
    }

    open func commandGlyph() throws -> String? {
        return try attribute("AXMenuItemCmdGlyph")
    }

    open func commandModifiers() throws -> Int? {
        return try attribute("AXMenuItemCmdModifiers")
    }

    open func commandVirtualKey() throws -> String? {
        return try attribute("AXMenuItemCmdVirtualKey")
    }

    open func markCharacter() throws -> String? {
        return try attribute("AXMenuItemMarkChar")
    }
}
