import SwiftUI
import DeltaCore

struct PlayView: View {
  @EnvironmentObject var appState: StateWrapper<AppState>
  
  @State var host: String = ""
  @State var port: UInt16? = nil
  
  @State var errorMessage: String? = nil
  @State var isAddressValid = false
  
  private func verify() -> Bool {
    if !isAddressValid {
      errorMessage = "Invalid IP"
    } else {
      return true
    }
    return false
  }

  var body: some View {
    VStack(alignment: .leading) {
      if let message = errorMessage {
        Text(message)
          .bold()
      }
      
      Text("Direct Connect")
        .font(.minecraftTitleRegular)

      AddressField("Server address", host: $host, port: $port, isValid: $isAddressValid)
      
      Button("Connect") {
        if verify() {
          let descriptor = ServerDescriptor(name: "Direct Connect", host: host, port: port)
          appState.update(to: .playServer(descriptor))
        }
      }
      .buttonStyle(PrimaryButtonStyle())
    }
  }
}
