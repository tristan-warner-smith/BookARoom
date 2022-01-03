# BookARoom

## Purpose
A test project for booking rooms
- Written in the `SwiftUI`, `Swift 5.5` for both `iPad` and `iPhone`
- Consuming an endpoint for room data
- Posting to a booking endpoint
- Porting an existing web design

## Planned Steps

1. Evaluate the design for requirements, design and behaviours
2. Evaluate the endpoint payload to determine requirements
3. Determine and decide on non functional requirements
4. Roadmap project (Chunk it up)
5. Implementation, evaluation loop
6. Ensure all requirements are met
7. Any documentation and delivery 

**NOTE:** Assume steps 1 and 2 are evaluated before the following notes are written, the design and endpoint feed into the ultimate requirements. 
 
### Evaluate design for requirements
#### Context

The app is a room booking system, however, unlike a standard calendar-based system that locks and unlocks rooms over time in this simplified example time isn't a factor where IRL 'seat' availability tends to be time-limited and batch booked.   
A whole room is most often booked for a meeting, where knowing the capacity is important as a prefilter.
Other factors that usually affect this kind of system are:
- Location (often rooms are shown across buildings in a campus, a city or even a whole company and travel-time is a key factor)
- Available time slots (meetings tend to be on regular cadences, 0, 15, 30, 45)
    - Slots tend to get booked up at the same kinds of times (multiple team standups at 9am for example) so data being as close to realtime with a multiple-booking resolution capability is important

In this simplified case it's closer to a find-your-own seat-booking app. A room has a spot or it doesn't.
Timeliness of data is still critical to reducing user friction and disappointment at failed bookings, if the data is infrequently fetched then there's a higher chance that a user will 'see' there are spaces available but when they go to book it's not available any more.
#### Data refresh considerations:
- User-led refresh mechanisms gives a sense of control e.g pull-to-refresh / dedicated refresh button but at the cost of a user having to 'do the work', there's a system benefit to this approach through reduced load on backend services
- Background refreshing with a visual display of how 'fresh' the data is and an indicator of state, this gives a user the context to make informed decisions but at the cost of control the downsides can be around the potential increased load of regular data fetches as well as to the user depending on the frequency (seeing the data is out of date and being unable to act).
- Push-based data sync - This approach is great for reducing load, data will only be fetched when it's actually changed at the cost of client and backend complexity 

In reality, many smaller companies don't have the resources to implement and manage push notifications so a sensible combination of both pull and user-refresh can be a good middle ground. Another risk exposed by both misconfiguration and user-behaviour is enabling a denial of service through excessive endpoint interaction, no-one likes an unintended DDOS, least of all devops / sys admins.

#### Design considerations:
- Meeting room imagery is unlikely to change frequently so this could be optimised with a longer-term disk-based cache.
- The web design makes good use of the available space with a flow layout, this will port reasonably well to iPad but not to phone where the reduced space makes it harder to get an overview of the rooms available and likewise to book in.
    - Initial thoughts here of a carousel-style approach or condensed card for phone vs a grid for iPad
- Accessibility - Can a sight or mobility-impaired user still easily navigate to and book a 
- App empty states, button states (visual differentiation between bookable, running low, fully booked, don't allow accidental repeat bookings).
- Sort order, it's assumption-based here as location is not a consideration and we don't have a booking policy preference to lean on, so we'll order by highest availability for highest chance of user success
- If rooms with no availability are returned, they're less valuable for the purposes of booking so either segment them, hide them or present them last
- Card rounding, spacing, relative fonts and colours is noted from the designs and will be considered during the port

### Evaluate endpoints for requirements
- Used Postman to see what headers from the APIs are returned for caching purposes, both APIs use Cache-Control which URLSession.dataTask respects out of the box.
- The `/rooms` endpoint has the `Cache-Control` header set with a `max age` of 600 seconds (10 minutes) which is counter to the desire of seeing real-time results.
- `/image` also uses `Cache-Control` with a long max age (10 years).
- Note that `URLSession.downloadTask` is a better choice for volume / larger downloads as with `dataTask` the bytes are held in memory. `URLSession.downloadTask` writes the bytes to a temporary file on disk and calls you back when it's finished, they're resumable and can continue to run in the background if needed. The downside is that it doesn't support caching by default, it's not that hard to create your own file / `NSCache` manager to do this but for time, I'll likely sidestep this and go with the cached version. If volume / image sizes become an issue this is a good optimisation step to embrace in the future.

### Non functional requirements
- Concurrency - There should be a single source of truth (to avoid concurrency issues)
- Accessibility - the app should be functional for the sight impaired 
- Configurability - The data refresh mechanism should have a configurable interval, to make it easy to scale traffic if needed.
- The app should be responsive at all times
- The app should adapt to different screen sizes
- The app should show available rooms when offline but not allow booking
- Unit Tests should at a minimum cover important inflection points (booking, data sync)
- Swiftlint should be configured to maintain code standards

### Roadmap:
- Initial project setup and configuration
- Booking screen design prototyping
- State management
- Networking

### Notes on design
- Button size increased for touch target, font as well
- Loading / empty states added
- Fonts and spacing approximated for time
- Accessibility-wise everything works well enough, I considered reordering the room name, book button and spaces count but left it as is.
- Dynamic type works but could be improved as described below.
- I considered disabling book functionality once you'd tapped it locally but then realised that it's an assumption that this isn't going to be used as a many-user kiosk rather than a single user app. 

### Cut for time
- Full image handling not using AsyncImage (doesn't support caching, reload etc, full state previews are impossible out of the box)
    - Previously I've made this work using an image-cache backed observable that updates the image on completion, using generics it conformed to an `ImageLoadable` protocol that meant it was possible to have a `PreviewImageLoader` that used local assets instead.
    - You can see this approach in my Spandex github project 
- Swap from live urls to handling of Preview asset images using development assets
- SwiftUI strings are localisable by default but the keys it generates are less than ideal, with more time I'd extract these to Localizable.strings
- "5 spots remaining" should use correct pluralisation through Localizable.dict rules not through custom code
- There's a gotcha with SwiftUI images in that they don't have the same aspect ratio clipping options as UIKit. In this case that means that some images that are portrait rather than landscape will fill vertically. Without knowing the sizes of the images up front to set an image-based maxHeight we're left in a dilemma of picking a 'reasonable' but flawed max height to ensure all cards look pretty much the same or instead to take manual control of image storage and understanding in order to know what dimensions to limit the UI to. An alternative at runtime could be to use the preference system to allow images to lay themselves out, collecting the sizes and then calculating a consistent max height, using GeometryReader in a background modifier. 
    - The patch I've applied _for time_ is to use the aspect ratio from the Figma design (328/220) to enforce the ratio it fills with. This means that the images are incorrectly stretched for portrait images. This would need rectifying as above.
- I haven't gone for a LazyVStack due to AsyncImage's lack of caching it shows a loading state excessively. This is another reason I tend to avoid AsyncImage in production, it negatively impacts both UI and UX.
- Dynamic type affordances - The design should change as the font gets above a usable size
- XCConfig - Normally I'd break out configs for the main differentiators, in this case separating UI Tests is the only real case I'd have for it.
- Test host - I tend to use a custom `@main` `AppLauncher` that reads commandline arguments and checks for `NSClassFromString("XCTestCase")` choosing to start the main app or a custom `UnitTestApp` with a UI that makes it clear that it's a separate test-only app. (I like to put a loading indicator on there too to see if there are any main thread UI hitches)     
- Codable type mapper / parser, I've just gone super basic with the RoomsDataProvider doing the conversion, as the requirements grow this is a good point to split things apart.
- /book I felt like you'd need an identifier for which room you're trying to book, roomName isn't a reliable unique id but I passed it through and `debugPrint`ed to scratch an itch.
- For booking I went with a fire and forget model rather than modelling progress and error state throughout.
- I didn't write tests for the booking coordinator for time and lack of an obvious case for error management (the response is only success / fail) 
- For rooms data I just captured the localised error for display rather than mapping them to user-friendly messages.  
- I didn't write UI tests for time, but I tend to create a caseless enum to map screen elements to string Automation Identifiers that can be used for UI tests


