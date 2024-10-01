import SwiftUI

struct TVConnectionView: View {
    @State private var connectionState: ConnectionState = .discovering
    @State private var selectedDevice: String?
    
    enum ConnectionState {
        case discovering, noDevices, ready, connecting, selectingDevice
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                stateView
                
                Spacer()
                
                Button(action: cycleState) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
    }
    
    var stateView: some View {
        Group {
            switch connectionState {
            case .discovering:
                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                        .padding(20)
                    Text("Discovering Devices...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            case .noDevices:
                VStack {
                    Image(systemName: "tv.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Text("No Devices Available")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            case .ready:
                Button(action: {
                    withAnimation { self.connectionState = .connecting }
                }) {
                    Text("Connect to TV")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            case .connecting:
                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    Text("Connecting to TV...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            case .selectingDevice:
                VStack {
                    Text("Select Device To Connect")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(["Fire TV 1", "Samsung TV", "Roku", "Android TV", "LG"], id: \.self) { device in
                        Button(action: {
                            self.selectedDevice = device
                            withAnimation { self.connectionState = .connecting }
                        }) {
                            Text(device)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color.black.opacity(0.6))
                .cornerRadius(15)
                .padding()
            }
        }
    }
    
    func cycleState() {
        withAnimation {
            switch connectionState {
            case .discovering:
                connectionState = .noDevices
            case .noDevices:
                connectionState = .ready
            case .ready:
                connectionState = .selectingDevice
            case .connecting:
                connectionState = .discovering
            case .selectingDevice:
                connectionState = .discovering
            }
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct TVConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        TVConnectionView()
    }
}
