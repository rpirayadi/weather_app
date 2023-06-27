class MenuItem {
    private let title: String 
    public let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public func getTitle() -> String{
        return title
    }
}