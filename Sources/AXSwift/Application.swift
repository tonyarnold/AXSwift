import AppKit

/// A `UIElement` for an application.
public final class Application: UIElement {
    // Creates a UIElement for the given process ID.
    // Does NOT check if the given process actually exists, just checks for a valid ID.
    convenience init?(forKnownProcessID processID: pid_t) {
        let appElement = AXUIElementCreateApplication(processID)
        self.init(appElement)

        if processID < 0 {
            return nil
        }
    }

    /// Creates an `Application` from a `NSRunningApplication` instance.
    /// - returns: The `Application`, or `nil` if the given application is not running.
    public convenience init?(_ app: NSRunningApplication) {
        if app.isTerminated {
            return nil
        }
        self.init(forKnownProcessID: app.processIdentifier)
    }

    /// Create an `Application` from the process ID of a running application.
    /// - returns: The `Application`, or `nil` if the PID is invalid or the given application
    ///            is not running.
    public convenience init?(forProcessID processID: pid_t) {
        guard let app = NSRunningApplication(processIdentifier: processID) else {
            return nil
        }
        self.init(app)
    }

    /// Creates an `Application` for every running application with a UI.
    /// - returns: An array of `Application`s.
    public class func all() -> [Application] {
        let runningApps = NSWorkspace.shared.runningApplications
        return runningApps
            .filter { $0.activationPolicy != .prohibited }
            .compactMap { Application($0) }
    }

    /// Creates an `Application` for every running instance of the given `bundleID`.
    /// - returns: A (potentially empty) array of `Application`s.
    public class func allForBundleID(_ bundleID: String) -> [Application] {
        let runningApps = NSWorkspace.shared.runningApplications
        return runningApps
            .filter { $0.bundleIdentifier == bundleID }
            .compactMap { Application($0) }
    }

    /// Creates an `Observer` on this application, if it is still alive.
    public func createObserver(_ callback: @escaping Observer.Callback) -> Observer? {
        do {
            return try Observer(processID: try pid(), callback: callback)
        } catch AXError.invalidUIElement {
            return nil
        } catch {
            fatalError("Caught unexpected error creating observer: \(error)")
        }
    }

    /// Creates an `Observer` on this application, if it is still alive.
    public func createObserver(_ callback: @escaping Observer.CallbackWithInfo) -> Observer? {
        do {
            return try Observer(processID: try pid(), callback: callback)
        } catch AXError.invalidUIElement {
            return nil
        } catch {
            fatalError("Caught unexpected error creating observer: \(error)")
        }
    }

    /// Returns a list of the application's visible windows.
    /// - returns: An array of `UIElement`s, for visible windows.
    public func windows() throws -> [UIElement] {
        guard
            let elements: [AXUIElement]? = try attribute("AXWindows"),
            let unwrappedElements = elements
        else {
            return []
        }

        return unwrappedElements.map(UIElement.init(_:))
    }

    public func menuBar() throws -> MenuBar? {
        guard
            let element: AXUIElement? = try attribute("AXMenuBar"),
            let unwrappedElement = element
        else {
            return nil
        }

        return MenuBar(unwrappedElement)
    }

    /// Returns the element at the specified top-down coordinates, or nil if there is none.
    public override func elementAtPosition(_ x: Float, _ y: Float) throws -> UIElement? {
        return try super.elementAtPosition(x, y)
    }
}
