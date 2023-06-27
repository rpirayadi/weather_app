


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
        if !Menu.favoriteLocations.contains(Menu.currentLocation){
            Menu.favoriteLocations.append(Menu.currentLocation)
            Menu.backwardDepth = 1

            print("location successfully added!")
        } else{
            print("location already in favourites!")
        }

    }),

    MenuItem(title:"delete", action:{
        if let index = Menu.favoriteLocations.firstIndex(of: Menu.currentLocation) {
            Menu.favoriteLocations.remove(at: index)
            Menu.backwardDepth = 1

            print("location successfully removed!")
        } else{
            print("location is not in favourites")
        }
    }),
]
)

let chooseLocationMenu = Menu(title: "Choose your location!", items: [
    MenuItem(title:"name", action: {
        let name: String = readLine() ?? ""
        Menu.currentLocation = name

        addOrRemoveFavMenu.run()
    }),

    MenuItem(title:"coords", action: {
        let coord: String = readLine() ?? ""
        let coordsList = coord.split(separator: " ")
        let coordination = (Double(coordsList[0])!, Double(coordsList[1])!)
        
        let util = NetworkUtils()
        Menu.currentLocation = util.apiGetNameByGeolocationCoords(coordination)

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
