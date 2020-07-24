# ios-Swift News+

##  General info
Building a simple iOS application that will ingest 'Swift News' JSON feed from Reddit, displaying the results in a table / collection view with the ability to tap into the full article.



## Technologies
Project is created with:
*Xcode (V. 11.0)
*supports ios 12..0 +



## Features
- Main View loads article List from "https://www.reddit.com/r/swift/.json"
- Tapping into an article navigates the user to Article View screen which displays the thumbnail image for the article (if it exists and is valid URL) and also displays the article description which is HTML rendered text.
- Main View also provides refresh button on the top right navigation bar to let user refresh the article list.
-  Appropriate error handling for missing data, no internet connection, server error, etc (Displays specific error message in the tableview body)
- Followed MVC design pattern to seperate model layer from view and the controller. It also helps prevent too much scattering of the code.
- Used extensions to seperate out the delegate/protocol implementation. so in Future if the Controllers become massive we can easily seperate out the Extensions in a seperate file and thus maintain the code for readability.
- Added reusable extensions that helps us tweak the standard library to fit in the requirements. Example: used UIViewController+Extension to display ActivityViewIndicator. which can be further add to any controllers.



## Third-Party Library Used
### SDWebImage

-Added it to the project using cocoapods 
- Experience using this framework previously

    Why  SDWebImage ?
-since it provides hassle free  asynchronous image downloading with cache support
-it guarantee that the same URL won't be downloaded several times
-better cache management
-guarantee that main thread will never be blocked
-Performances!
