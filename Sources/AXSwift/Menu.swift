import AppKit

open class Menu: UIElement {
    open func items() throws -> [MenuItem] {
        let children: [AXUIElement]? = try attribute(.children)
        return children?.map { MenuItem($0) } ?? []
    }
}
