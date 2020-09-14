# Burial Records

This is a project to learn how to communicate with APIs in Swift. <br>
I'm using the a City of Winnipeg dataset called burial records, which give the cemetary, plot, date of death and name of about 119 000 people in Winnipeg. <br>
https://data.winnipeg.ca/Cemeteries/Burial-Records/iibp-28fx <br>
<br>
Since Find a Grave is already an established website that crowdsources grave information, some of which isn't included in this dataset (date of birth, headstone picture), I'd like to avoid replicating that functionality, and so a functional end goal for this project remains unclear. I may eventually try to use scrape their data instead. <br>
<br>

Current ideas:<br>
• Show data for first (exact) match of a full name. <br>
• Show data (list) for all (exact) matches of last names.<br>
• Show amount of burials per cemetery for all time as a bar plot.<br>
• Show amount of burials for a given cemetery per year as a line plot.<br>
• Attempt to pinpoint specific grave locations within a cemetary and show them on a map. <br>

## Progress Log
### Sept 14, 2020
After many unsuccessful attempts to understand why my API call is not working like it is in the video tutorial I watched, I take a step back and find that there is a SODAKit library for Swift which should allow me to call Socrata Open data APIs easily (like I have previously tested with Python, since Socrata provides python examples. Now I need to figure out how to import an external library into my project. Looks like least terminal-based way to do it is a feature of xcode 11 so I need to update xcode (I'm using 10.2).
<br>
3 hours later, I need to update macOS to 10.15. <br>
1 hour later, things are finally installed.


## References
### iOS / Swift tutorials
#### Basic button and label use refresher
https://www.youtube.com/watch?v=BM2o8LG5QkE

#### Swift guard keyword
https://stackoverflow.com/questions/30791488/swifts-guard-keyword


#### Using API's with Swift
https://www.youtube.com/watch?v=sqo844saoC4

#### Codable protocol for JSON data
https://www.credera.com/insights/using-codable-for-json-in-swift-4/

#### Adding an external library (soda-swift)
https://socrata.github.io/soda-swift/
https://www.youtube.com/watch?v=ZxHndSGmWcE



