


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
