

class Menu {
    static var backwardDepth: Int = 0
    static var isAscen: Bool = false
    static var isTemp: Bool = false
    static var currentLocation: String = ""
    static var favoriteLocations: [String] = []
    public let title: String
    public var items: [MenuItem]

    public init(title: String, items: [MenuItem]) {
        self.title = title
        self.items = items
        self.items.append(MenuItem(title: "back",  action: {}))
        self.items.append(MenuItem(title: "help",  action: {
            for item in self.items{
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
            for item in items {
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

            if Menu.backwardDepth > 0 {
                Menu.backwardDepth -= 1
                break
            }

            print("Press any key to continue...", terminator: "")
            _ = readLine()
        }
    }
}

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




let showFavoritesSortedMenu = Menu(title: "Sorted Favorite locaitons!", items:[])



let ascenOrDescenSortTypeMenu = Menu(title: "Sort in ascending or descending order!", items:[
    MenuItem(title:"ascen", action:{
        // TODO
        showFavoritesSortedMenu.run()
    }),

    MenuItem(title:"descen", action:{
        // TODO
        showFavoritesSortedMenu.run()
    }),
])

let nameOrTempSortTypeMenu = Menu(title: "Sort by name or tempreture!", items:[
    MenuItem(title:"name", action: {
        // TODO
        ascenOrDescenSortTypeMenu.run()
    }),

    MenuItem(title:"temp", action: {
        // TODO
        ascenOrDescenSortTypeMenu.run()
    }),
])

let addOrRemoveFavMenu = Menu(title: "Add/delete this location to/from favorites!", items:[
    MenuItem(title:"add", action: {
        // TODO
        // Menu.backwardDepth
    }),

    MenuItem(title:"delete", action:{
        // TODO
    }),
]
)

let chooseLocationMenu = Menu(title: "Choose your location!", items: [
    MenuItem(title:"name", action: {
        // TODO
        addOrRemoveFavMenu.run()
    }),

    MenuItem(title:"coords", action: {
        // TODO
        addOrRemoveFavMenu.run()
    }),
])

let mainMenu = Menu(title: "Welcome to Weather Application!", items: [
    MenuItem(title: "add", action: {
        chooseLocationMenu.run()
    }),

    MenuItem(title: "show",  action: {
        nameOrTempSortTypeMenu.run()
    }),
])



mainMenu.run()


