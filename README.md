# Burial Records

This was a project to learn how to communicate with APIs in Swift, but has really turned into a deep dive with getting familiar and comfortable with iOS development. <br>
I'm using the a City of Winnipeg dataset called burial records, which give the cemetary, plot, date of death and name of about 119 000 people in Winnipeg. <br>
https://data.winnipeg.ca/Cemeteries/Burial-Records/iibp-28fx <br>
<br>
Since Find a Grave is already an established website that crowdsources grave information, with some fields that this dataset lacks (date of birth, headstone picture), I'd like to avoid replicating that functionality. One thing Find a Grave does not have is specific geographic coordinates for graves. If it's at all possible, I'd like to try to connect the burial plot information to geographic coordinates and pinpoint specific graves on a map. Other end goals with user value for this project remain unclear. It's mostly for my learning experience.  <br>
<br>

Current ideas:<br>
• Show data for first (exact) match of a full name. <br>
• Show data (list) for all (exact) matches of last names.<br>
• Show amount of burials per cemetery for all time as a bar plot.<br>
• Show amount of burials for a given cemetery per year as a line plot.<br>
• Attempt to pinpoint specific grave locations within a cemetary and show them on a map. <br>

## Progress Log
### Sept 13, 2020
Got caught up with the [basics of adding UI elements](https://www.youtube.com/watch?v=BM2o8LG5QkE) so that I can eventually get some feedback other than the standard output screen. <br>

### Sept 14, 2020
Lots of brushing up on Swift syntax, had to look up what "[guard](https://stackoverflow.com/questions/30791488/swifts-guard-keyword)" is.
Foud a first [API calling tutorial](https://www.youtube.com/watch?v=sqo844saoC4). Needed to lookup what the [Codable protocol](https://www.credera.com/insights/using-codable-for-json-in-swift-4/) is. Also just [protocols](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html) in general. They're basically like interfaces in Java. <br>
After many unsuccessful attempts to understand why my API call is not working like it is in the video tutorial I watched, I take a step back and find that there is a [SODAKit library for Swift](https://socrata.github.io/soda-swift/) which should allow me to call Socrata Open data APIs easily (like I have previously tested with Python, since Socrata provides python examples. Now I need to figure out [how to import an external library into my xcode project](https://www.youtube.com/watch?v=ZxHndSGmWcE). Looks like least terminal-based way to do it is a feature of xcode 11 so I need to update xcode (I'm using 10.2).
<br>
3 hours later, I need to update macOS to 10.15. <br>
1 hour later, things are finally installed. <br>
Still having problems with the API call, SODAKit is still not fully intuitive, missing some basics - [looked up completion handlers](https://programmingwithswift.com/understanding-completion-handlers-in-swift/). <br>
Additionally, needed to look up [enums in Swift](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html). The ".name" notation is confusing me - I'm very used to C++. <br>
The documentation on for the swift soda sdk is also slightly outdated. Couldn't just copy paste the example code. Had to rename a method and get rid of the capitalization on the enums. <br>
`8:03 PM` - first successful call. Gonna push code now, but first better [read my API token from a txt file](https://www.youtube.com/watch?v=e2N0kV5YQ18) that I don't upload here. <br>
`8:44 PM` - managed to get the text to read properly, that tutorial needed modification. Tried to use git in the Terminal but xcode command line tools needed an update because I installed Catalina. Jesus Christ Apple! I'm not buying a mac next time. <br>

### Sept 15, 2020
`10:46 AM` Need to learn to use a tableview to see the results of the query better. <br>
Had to look up the [meaning of the underscore character](https://stackoverflow.com/questions/39627106/why-do-i-need-underscores-in-swift) in Swift. <br>
Spent a considerable amount of time playing around with UI constraints to get a bit more familiar with them. <br>
Added stack views to the UI. <br>
Had to look up Swift for loops, dictionaries, casting, arrays, range operators...etc. <br>
`4:15 PM` Finally got relatively comfortable with queries and having my data formatted nicely in standard output. <br>
`11:30 PM` After supper/jog/break/etc, did some reorganizing of the code. I learned that I have created what is reffered to as a Massive View Controller, but you can now make names appear in the table view by searching an attribute and a specific value, and pressing Generate. The key to this working was finding out about the reloadData() function for a TableView <br>
Tomorrow will focus more on reorganizing the UI and layout so that user experience is more pleasant and info is fully accessible after search. This'll probably involve breaking down the ViewController into smaller parts. <br>

### Sept 16, 2020
`1:00 PM` Followed [a very good bunch of tutorials about UITableViews](https://www.youtube.com/watch?v=VFtsSEYDNRU&list=TLPQMTYwOTIwMjBQe6XonpM70A&index=1) to reorganize my code. <br>
Learned about [Target-Action](https://learnappmaking.com/target-action-swift/), which is very much like signals and slots in Qt. <br>
`5:30 PM` Cleaned up the table view code. I'm now much clearer and more organized on how to add functionality. However, I had to removed the API code for now, so I'll have to add this back in, and since I scrapped my previous UI, I need to think of a better way to get user input for searches. That will likely involve learning how to switch between two different views. <br>

Here's a pic of what things currently look like(with some real fake names):<br>
![sept16_prog](https://user-images.githubusercontent.com/16982565/93399862-02ffbb00-f844-11ea-9af8-912b934a48d8.png)

### Sept 17, 2020
`12:41 PM` Added the API data back, but there is clearly a problem concerning how to present it. <br>
Currently I only have one view for the list of whatever the query returns. <br>
I think I will copy the format that FireFox Focus uses. <br>
That said, before I dive into having a search bar, I want to add a logo, splashscreen, and some original background music. <br>
`5:00` I added the music. I'm going to try a lame logo, now.

