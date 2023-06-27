class Menu {
    public let title: String
    public var items: [MenuItem]

    public init(title: String, items: [MenuItem]) {
        self.title = title
        self.items = items
        self.items.append(MenuItem(title: "back",  action: {}))
        self.items.append(MenuItem(title: "help",  action: {
            for item in items{
                print(item.getTitle())
            }
        }))
    }

    public func run() {
        while true {
            print("\u{001B}[2J")
            print(title)

            print(">> ", terminator: "")
            let command: String = readLine() ?? ""

            var isValid = false
            for item in items{
                if item.getTitle() == command{
                    isValid = true
                    item.action()
                }
            }
            if command == "back"{
                isValid = true
                break
            }
            if !isValid {
                print("Invalid command! Please try again.")
            }
            print("Press any key to continue...", terminator: "")
            _ = readLine()
        }
    }
}