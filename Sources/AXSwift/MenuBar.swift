import AppKit

open class MenuBar: UIElement {
    open func menus() throws -> [Menu] {
        let children: [AXUIElement]? = try attribute(.children)
        return children?.map { Menu($0) } ?? []
    }
}
