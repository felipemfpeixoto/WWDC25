import SwiftUI

@main
struct MyApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                print("Mengo")
                // MARK: Testar no device com e sem essa análise do scenePhase
                AudioManager.shared.stopAllAudio()
            case .inactive:
                break
            case .active:
                AudioManager.shared.restartAudio()
            @unknown default:
                break
            }
        }
    }
}
