import SwiftUI

@main
struct MasteryClockApp: App {
    @StateObject private var engine = TimerEngine()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(engine: engine)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: engine.isRunning ? "play.circle.fill" : "pause.circle")
                Text(formatMenuBarTime(engine.totalSeconds))
                    .font(.system(.body, design: .monospaced))
            }
        }
        .menuBarExtraStyle(.window)
    }
    
    private func formatMenuBarTime(_ secs: Double) -> String {
        let total = Int(secs)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%03d:%02d:%02d", h, m, s)
    }
}
