import SwiftUI

#if DEBUG
@_exported import Inject
#endif

@main
struct HeyAltApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
