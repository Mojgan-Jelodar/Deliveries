# DataReader
This is an application which shows a list of some deliveries as a list. In addition ,you can earn more detail about it with touching each of them.   

# DeliveryApp
This project shows a list of deliveries with receiver's photo and item description and also locates the delivery location on the map when clicked on delivery item.

# Requirement
- XCode 11.0
- macOS Mojava 10.14.6

# Installation
- To run the project :
- Open podfile from project repository 
- Open terminal and cd to the directory containing the Podfile
- Run the "pod install" command
- Open DeliveryApp.xcworkspace 

# Language used 
- Swift 5.0

# App Version
- 1.0.0 
# Design Pattern Used

## VIPER
Viper is a design pattern that implements ‘separation of concern’ paradigm. Mostly like MVP or MVC it follows a modular approach. One feature, one module. For each module VIPER has five (sometimes four) different classes with distinct roles. No class go beyond its sole purpose. These classes are following.
-  View: Class that has all the code to show the app interface to the user and get their responses. Upon receiving a response View alerts the Presenter.
-  Presenter: Nucleus of a module. It gets user response from the View and work accordingly. Only class to communicate with all the other components. Calls the router for wire-framing, Interactor to fetch data (network calls or local data calls), view to update the UI.
-  Interactor: Has the business logics of an app. Primarily make API calls to fetch data from a source. Responsible for making data calls but not necessarily from itself.
-  Router : Does the wire-framing. Listens from the presenter about which screen to present and executes that.
-  Entity: Contains plain model classes used by the interactor.

![Viper](https://miro.medium.com/max/2862/1*-Mfew6qvLQ-t-DSOkY23Aw.png)

# Features

## ListView
- Shows list of deliveries with receiver's photo and item description.
- If Network is available it fetches deliveries from API only,and if there is a problem on network or connection it shows deliveries fetched from local database if available.

## MapView
- Used Apple Mapkit framework to show  delivery on map and dismiss this with touch on empty spaces on the screen

## Data Caching
- Realm is used for data caching. Items fetched from server are displayed to UI and also saves/updates on database.

## Pull to Refresh
- If network available - fetches data from starting index from server, if data is available then it is displayed new data to UI and then save/update it into database.
- If network not available - Error alert shows "No internet connection".

## Pagination
- Fetching data from starting index and when a user goes to bottom of the table view, hits request for fetching next batch of deliveries by setting offset to count of current deliveries available, then displaying in the UI. Also continuesly saves/updates it into database.
- Pagination is also available in case when no network connectivity available and fetches from database in a batch of 20 items to avoid load on app.
- Pagination ends once we recieve empty list of deliveries with success code from server.



# Assumptions        
-   The app is designed for iPhones and iPad.        
-   App currently supports English and Persian languages.
-   Mobile and iPad platform supported: iOS (10.x,11.x, 12.x,13.x)        
-   Device support : iPhone , iPad  
-   Data caching is available.



# Frameworks/Libraries used
- Alamofire
- ObjectMapper
- SnapKit
- Kingfisher
- RealmSwift
- UIScrollView-InfiniteScroll


# Unit Test
- There is a part of uinit test for deliveryList



