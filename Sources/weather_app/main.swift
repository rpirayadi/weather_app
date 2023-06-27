let mainMenu = Menu(title: "Welcome to Cryptocurrency Swift!", items: [
    MenuItem(title: "View Cryptocurrencies", action: {
        print("view")
    }),

    MenuItem(title: "View Profile",  action: {
        print("profile")
    }),
])


mainMenu.run()
