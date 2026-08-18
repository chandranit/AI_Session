import SwiftUI

struct ContentView: View {
    @ObservedObject var engine: TimerEngine
    @State private var showingExportMenu = false
    @State private var showingQuoteAlert = false
    @State private var quoteMessage = "\"Consistency over intensity. 2 hours of daily deliberate practice beats 14 hours on Sunday.\""
    
    // Motivational quotes array
    private let quotes = [
        "\"We are what we repeatedly do. Excellence, then, is not an act, but a habit.\" — Aristotle",
        "\"Mastery is not a function of genius or talent, it is a function of time and intense focus.\" — Robert Greene",
        "\"Solve 1 problem deeply rather than 10 problems superficially.\"",
        "\"Consistency over intensity. 2 hours of daily deliberate practice beats 14 hours on Sunday.\"",
        "\"Every single problem you struggle with is expanding your neural problem-solving architecture.\"",
        "\"Embrace the grind. The first 250 hours build intuition, the next 750 build instinct.\""
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            // Header Info: Rank & Edit Skill
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(engine.currentRank.uppercased())
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                        .tracking(1)
                    
                    TextField("Enter skill...", text: $engine.currentSkill)
                        .textFieldStyle(.plain)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Settings & Actions Menu
                Menu {
                    Button(action: {
                        engine.soundEnabled.toggle()
                    }) {
                        Label(engine.soundEnabled ? "Mute Feedback" : "Enable Feedback", 
                              systemImage: engine.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    }
                    
                    Menu("Export Sessions") {
                        Button("Export as CSV...") {
                            exportData(format: .csv)
                        }
                        Button("Export as JSON...") {
                            exportData(format: .json)
                        }
                    }
                    
                    Divider()
                    
                    Button(role: .destructive, action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        Label("Quit Mastery Clock", systemImage: "power")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .menuStyle(.borderlessButton)
                .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            
            // Circular Radial Progress Indicator
            ZStack {
                // Background Track Circle
                Circle()
                    .stroke(Color.primary.opacity(0.06), lineWidth: 8)
                    .frame(width: 140, height: 140)
                
                // Dynamic Progress Ring
                Circle()
                    .trim(from: 0.0, to: CGFloat(engine.progressPercentage / 100.0))
                    .stroke(
                        LinearGradient(
                            colors: [.skyBlue, .indigo, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: engine.progressPercentage)
                
                // Clock Inner Readout
                VStack(spacing: 2) {
                    Text(engine.isRunning ? "PRACTICING" : "PAUSED")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(engine.isRunning ? .emerald : .secondary)
                        .tracking(1)
                    
                    // Live HHH:MM:SS Timer Readout
                    Text(formatHms(engine.totalSeconds))
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                    
                    Text("\(NSNumber(value: engine.progressPercentage), formatter: NumberFormatter.percentFormatter)%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.skyBlue)
                }
            }
            .padding(.vertical, 4)
            
            // Primary Play / Pause Button
            Button(action: {
                engine.togglePlayPause()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: engine.isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 12, weight: .bold))
                    Text(engine.isRunning ? "PAUSE DELIBERATE PRACTICE" : "START DELIBERATE PRACTICE")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(0.5)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(engine.isRunning ? Color.red : Color.emerald)
                )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 14)
            
            // Session logs / Motivational text Toggle
            VStack(spacing: 4) {
                Text(quoteMessage)
                    .font(.system(size: 10, weight: .medium))
                    .italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 32)
                    .onTapGesture {
                        rotateQuote()
                    }
                
                Divider()
                    .padding(.horizontal, 8)
                
                // Recent sessions list (compact scroll)
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        if engine.sessions.isEmpty {
                            Text("No recent focus sessions. Your deliberate practice hours will accumulate here.")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding(.top, 14)
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(engine.sessions.prefix(5)) { session in
                                HStack {
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(session.skillName)
                                            .font(.system(size: 10, weight: .semibold))
                                            .lineLimit(1)
                                        Text("\(session.date) • \(session.startTime)")
                                            .font(.system(size: 8))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("+\(formatHoursMinutes(session.durationSeconds))")
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                        .foregroundColor(.skyBlue)
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color.primary.opacity(0.02))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .frame(maxHeight: 110)
            }
            
            Spacer()
        }
        .frame(width: 320, height: 380)
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .withinWindow)
        )
        .onAppear {
            rotateQuote()
        }
    }
    
    private func rotateQuote() {
        quoteMessage = quotes.randomElement() ?? quotes[0]
    }
    
    private func formatHms(_ secs: Double) -> String {
        let total = Int(secs)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%03d:%02d:%02d", h, m, s)
    }
    
    private func formatHoursMinutes(_ secs: Double) -> String {
        let total = Int(secs)
        let h = total / 3600
        let m = (total % 3600) / 60
        return "\(h)h \(String(format: "%02d", m))m"
    }
    
    enum ExportFormat {
        case json, csv
    }
    
    private func exportData(format: ExportFormat) {
        let content: String
        let filename: String
        
        switch format {
        case .json:
            content = engine.exportSessionsAsJSON()
            filename = "MasteryClock_Backup.json"
        case .csv:
            content = engine.exportSessionsAsCSV()
            filename = "MasteryClock_Backup.csv"
        }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [format == .json ? .json : .commaSeparatedText]
        savePanel.nameFieldStringValue = filename
        savePanel.title = "Save Mastery Clock Data"
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                try? content.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
}

// Visual Effect View helper for macOS dark frosted window material
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// Colors & Formatter helpers
extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
    static let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)
}

extension NumberFormatter {
    static var percentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
