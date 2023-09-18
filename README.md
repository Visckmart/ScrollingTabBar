# Scrolling Tab Bar
### A SwiftUI implementation of a tab bar that can scroll and have fixed tabs.

This is a Swift Package that implements a SwiftUI view that shows tabs which can be used to navigate through your app.

This tab bar that has a scrolling behavior for when the tabs overflow, and fixed tabs on the left and on the right side that are always visible to the user.

## Usage
The main view is called `ScrollingTabBar`. An alternative means of using it is by making use of the `withScrollingTabBar` View modifier. With the modifier, the scrolling tab bar is shown as a sheet.

To use it you need to follow two steps.
1. Implement a type that conforms to the `Tab` protocol.
```Swift
class PageTab: Tab {
    var id: String        /* Required */
    var iconName: String  /* Required */
    var color: Color      /* Required */
    var name: String      /* Required */

    var history: [URL]
}
```

2. Show a Scrolling Tab Bar on screen using the usual initializer or the View modifier.

Start by declaring a `@State` variable with the tabs and one of the type `TabSelection`.
```Swift
@State var tabs: [PageTab] = [...]
@State var selectedTab: TabSelection = .fixedLeft
```

A. Initializer

Call the `ScrollingTabBar` initializer, pass an array of a type that conforms to the `Tab` protocol, and a binding to the variable created previously.
```Swift
ScrollingTabBar(tabs: tabs, selectedTab: $selectedTab)
```

B. View modifier

Attach the view modifier to a view, pass an array of a type that conforms to the `Tab` protocol, and a binding to the variable created previously.

```Swift
var body: some View {
  ...
      .withScrollingTabBar(tabs: tabs, selectedTab: $selectedTab)
}
```

### User Interface Design Disclaimer

The intent of this component is not to be used in the same way a native tab bar would be used – with static tabs. Apple's Human Interface Guidelines recommends the number of tabs on the native Tab Bar navigation to be low, such that all of them are visible.

This component is intended to provide a different kind of navigation. A more dynamic one, where the user can add and remove tabs, such as the navigation we see on the Safari app, and even on the Weather app in a way.
