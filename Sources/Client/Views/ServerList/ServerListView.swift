import SwiftUI
import DeltaCore

class ServerListViewModel: ObservableObject {
  @Published var updateAvailable = false
}

struct ServerListView: View {
  @EnvironmentObject var appState: StateWrapper<AppState>

  @State var pingers: [Pinger]
  @ObservedObject var model = ServerListViewModel()

  @State public var buttonSelected: String?

  var lanServerEnumerator: LANServerEnumerator?

  init() {
    // Create server pingers
    let servers = ConfigManager.default.config.servers
    _pingers = State(initialValue: servers.map { server in
      Pinger(server)
    })

    // Attempt to create LAN server enumerator
    let eventBus = EventBus()
    do {
      lanServerEnumerator = LANServerEnumerator(eventBus: eventBus)
      eventBus.registerHandler { event in
        switch event {
        case let event as ErrorEvent:
          log.warning("\(event.message ?? "Error"): \(event.error)")
        default:
          break
        }
      }

      // Start pinging and enumerating
      refresh()
      try lanServerEnumerator?.start()
    } catch {
      log.warning("Failed to start LAN server enumerator: \(error)")
    }

    checkForUpdatesAsync()
  }

  func checkForUpdatesAsync() {
    DispatchQueue(label: "Server list update checker").async {
      let result = Updater.isUpdateAvailable()
      DispatchQueue.main.sync {
        self.model.updateAvailable = result
      }
    }
  }

  /// Ping all servers again and clear discovered LAN servers.
  func refresh() {
    for pinger in pingers {
      try? pinger.ping()
    }

    lanServerEnumerator?.clear()
  }

  // Navigate to update settings view
  func update() {
    appState.update(to: .settings(.update))
  }

  struct MenuButton: View {

    @State var buttonTitle: String
    @Binding var buttonSelected: String?

    var body: some View {
      Button(action: {
        buttonSelected = buttonTitle
        print("\(buttonTitle) button pressed")
      }) {
        HStack {
          Image(packageResource: buttonTitle, ofType: "svg")
            .resizable()
            .frame(width: 16.0, height: 16.0)
          Text(buttonTitle)
            .font(.minecraftHeadlineRegular)
        }
          .frame(minWidth: 100, maxWidth: .infinity, minHeight: 16, maxHeight: 50, alignment: .leading)
          .contentShape(RoundedRectangle(cornerSize: CGSize(width: 6, height: 6)))
      }
        .padding(8)
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(buttonSelected == buttonTitle ? Color(red: 0.168, green: 0.168, blue: 0.168) : Color.clear)
        .cornerRadius(6)
    }
  }


  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      NavigationView {
        ZStack {
          Color(red: 0.112, green: 0.112, blue: 0.112).ignoresSafeArea()
          List {
            VStack(alignment: .leading, spacing: 14) {
              MenuButton(buttonTitle: "Play", buttonSelected: $buttonSelected)
                .background(
                  NavigationLink(destination: PlayView(), isActive: Binding<Bool>(get: { buttonSelected == "Play" }, set: { _ in })) {
                    EmptyView()
                  }
                    .hidden()
                )

              MenuButton(buttonTitle: "Settings", buttonSelected: $buttonSelected)
              MenuButton(buttonTitle: "Update", buttonSelected: $buttonSelected)

            }

            if !pingers.isEmpty {
              ForEach(pingers, id: \.self) { pinger in
                NavigationLink(destination: ServerDetail(pinger: pinger)) {
                  ServerListItem(pinger: pinger)
                }
              }
            } else {
              Text("no servers").italic()
            }

            Divider()

            if let lanServerEnumerator = lanServerEnumerator {
              LANServerList(lanServerEnumerator: lanServerEnumerator)
            } else {
              Text("LAN scan failed").italic()
            }

            HStack {
              // Edit
              IconButton("square.and.pencil") {
                appState.update(to: .editServerList)
              }

              // Refresh servers
              IconButton("arrow.clockwise") {
                refresh()
              }

              // Direct connect
              IconButton("personalhotspot") {
                appState.update(to: .directConnect)
              }
            }

            if (model.updateAvailable) {
              Button("Update", action: update).padding(.top, 5)
            }
          }
            .toolbar {
              Button(action: {}) {
              }
            }
            .presentedWindowToolbarStyle(UnifiedWindowToolbarStyle())
            .listStyle(SidebarListStyle())
        }
      }
        .onDisappear {
          lanServerEnumerator?.stop()
        }
    }
  }
}
