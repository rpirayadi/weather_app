

let showFavoritesSortedMenu = Menu(title: "Sorted Favorite locaitons!", items:[])


func getTableFromNetworkUtils() -> String {
    var res: String = ""


    let utils = NetworkUtils()
    do{
        var forecasts: [cityInfo] = try utils.getFavoriteLocationsForecasts(favorites: Menu.favoriteLocations)
        if Menu.isTemp {
        if Menu.isAscen {
            forecasts = forecasts.sorted { $0.temp < $1.temp }
        } else {
            forecasts = forecasts.sorted { $0.temp > $1.temp }
        }
    } else {
        if Menu.isAscen {
            forecasts = forecasts.sorted { $0.name < $1.name }
        } else {
            forecasts = forecasts.sorted { $0.name > $1.name }
        }

        for forecast in forecasts {
        res += forecast.toString()
        }
    }   
    }catch{
        print("error")
    }
    return res
}

let ascenOrDescenSortTypeMenu = Menu(title: "Sort in ascending or descending order!", items:[
    MenuItem(title:"ascen", action:{
        Menu.isAscen = true
        Menu.backwardDepth = 2
        showFavoritesSortedMenu.run(menuContent: getTableFromNetworkUtils())
    }),

    MenuItem(title:"descen", action:{
        Menu.isAscen = false
        Menu.backwardDepth = 2
        showFavoritesSortedMenu.run(menuContent: getTableFromNetworkUtils())
    }),
])

let nameOrTempSortTypeMenu = Menu(title: "Sort by name or tempreture!", items:[
    MenuItem(title:"name", action: {
        Menu.isTemp = false
        ascenOrDescenSortTypeMenu.run()
    }),

    MenuItem(title:"temp", action: {
        Menu.isTemp = true
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
        print("m")
        let name: String = readLine() ?? ""
        print("m", name)
        Menu.currentLocation = name
        
        let util = NetworkUtils()

        do{
            let possibleForecast = try util.apiForecastByName(name: name)
            if let forecast = possibleForecast{
                print(forecast, name)
                addOrRemoveFavMenu.run()

            }else{
                print("Invalid name!")
            }
        }catch{
            print("error")
        }

    }),

    MenuItem(title:"coords", action: {
        let coord: String = readLine() ?? ""
        let coordsList = coord.split(separator: " ")
        let coordination = (Double(coordsList[0])!, Double(coordsList[1])!)
        
        let util = NetworkUtils()

        do{
            let possibleName = try util.apiGetNameByGeolocationCoords(coords: coordination)
            if let name = possibleName{
                Menu.currentLocation = name
                addOrRemoveFavMenu.run()
            } else{
                print("Invalid Geolocation")
            }
        }
        catch {
            print("error")
        }

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
