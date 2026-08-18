import Foundation
import Combine

struct Session: Codable, Identifiable {
    let id: UUID
    let skillName: String
    let date: String
    let startTime: String
    let durationSeconds: Double
}

class TimerEngine: ObservableObject {
    // Persistent Properties
    @Published var accumulatedSeconds: Double = 0 {
        didSet { saveToUserDefaults() }
    }
    @Published var currentSkill: String = "Data Structures & Algorithms" {
        didSet { saveToUserDefaults() }
    }
    @Published var soundEnabled: Bool = true {
        didSet { saveToUserDefaults() }
    }
    @Published var sessions: [Session] = [] {
        didSet { saveToUserDefaults() }
    }
    
    // Runtime Timer State
    @Published var isRunning: Bool = false
    @Published var activeSessionDuration: Double = 0
    
    private var timer: Timer?
    private var sessionStartTimestamp: Date?
    
    // Goal Definitions
    let targetHours: Double = 1000.0
    var targetSeconds: Double { targetHours * 3600.0 }
    
    // User Defaults Keys
    private let kAccumulatedSeconds = "1000h_accumulated_seconds"
    private let kCurrentSkill = "1000h_current_skill"
    private let kSoundEnabled = "1000h_sound_enabled"
    private let kSessions = "1000h_sessions"
    
    init() {
        loadFromUserDefaults()
    }
    
    // Total practice time combined
    var totalSeconds: Double {
        accumulatedSeconds + activeSessionDuration
    }
    
    var progressPercentage: Double {
        min(100.0, (totalSeconds / targetSeconds) * 100.0)
    }
    
    var remainingSeconds: Double {
        max(0.0, targetSeconds - totalSeconds)
    }
    
    var currentRank: String {
        let hours = totalSeconds / 3600.0
        if hours >= 1000.0 { return "Grandmaster 🏆" }
        if hours >= 750.0 { return "Expert" }
        if hours >= 500.0 { return "Practitioner" }
        if hours >= 250.0 { return "Journeyman" }
        return "Apprentice"
    }
    
    // -------------------------------------------------------------
    // Controls
    // -------------------------------------------------------------
    func togglePlayPause() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }
    
    private func start() {
        guard !isRunning else { return }
        isRunning = true
        sessionStartTimestamp = Date()
        activeSessionDuration = 0
        
        // Timer configuration using `.common` mode to prevent UI interaction freezes
        let newTimer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.sessionStartTimestamp else { return }
            DispatchQueue.main.async {
                self.activeSessionDuration = Date().timeIntervalSince(start)
            }
        }
        
        RunLoop.main.add(newTimer, forMode: .common)
        self.timer = newTimer
        
        if soundEnabled {
            playBeep(frequency: 587.33, duration: 0.1) // D5
        }
    }
    
    private func pause() {
        guard isRunning else { return }
        isRunning = false
        
        let elapsed = activeSessionDuration
        if elapsed > 0 {
            accumulatedSeconds += elapsed
            
            // Add session log entry
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            let dateString = formatter.string(from: sessionStartTimestamp ?? Date())
            
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let timeString = formatter.string(from: sessionStartTimestamp ?? Date())
            
            let newSession = Session(
                id: UUID(),
                skillName: currentSkill,
                date: dateString,
                startTime: timeString,
                durationSeconds: elapsed
            )
            sessions.insert(newSession, at: 0)
        }
        
        timer?.invalidate()
        timer = nil
        sessionStartTimestamp = nil
        activeSessionDuration = 0
        
        if soundEnabled {
            playBeep(frequency: 440.0, duration: 0.1) // A4
        }
    }
    
    // -------------------------------------------------------------
    // Utility and Sound synthesis
    // -------------------------------------------------------------
    private func playBeep(frequency: Double, duration: Double) {
        // Synthesizing a simple square/sine beep natively in macOS
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        // Run a simple applescript to beep or produce a sound
        task.arguments = ["-e", "beep"]
        try? task.run()
    }
    
    // -------------------------------------------------------------
    // Export Data Utility
    // -------------------------------------------------------------
    func exportSessionsAsJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(sessions),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "[]"
    }
    
    func exportSessionsAsCSV() -> String {
        var csvString = "ID,Skill,Date,StartTime,DurationSeconds,DurationFormatted\n"
        for session in sessions {
            let h = Int(session.durationSeconds) / 3600
            let m = (Int(session.durationSeconds) % 3600) / 60
            let s = Int(session.durationSeconds) % 60
            let formatted = String(format: "%02d:%02d:%02d", h, m, s)
            
            // Escape skill name just in case it contains commas
            let escapedSkill = session.skillName.replacingOccurrences(of: "\"", with: "\"\"")
            
            csvString += "\(session.id.uuidString),\"\(escapedSkill)\",\(session.date),\(session.startTime),\(session.durationSeconds),\(formatted)\n"
        }
        return csvString
    }
    
    // -------------------------------------------------------------
    // UserDefaults Serialization
    // -------------------------------------------------------------
    private func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(accumulatedSeconds, forKey: kAccumulatedSeconds)
        defaults.set(currentSkill, forKey: kCurrentSkill)
        defaults.set(soundEnabled, forKey: kSoundEnabled)
        
        if let encoded = try? JSONEncoder().encode(sessions) {
            defaults.set(encoded, forKey: kSessions)
        }
    }
    
    private func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        accumulatedSeconds = defaults.double(forKey: kAccumulatedSeconds)
        currentSkill = defaults.string(forKey: kCurrentSkill) ?? "Data Structures & Algorithms"
        soundEnabled = defaults.object(forKey: kSoundEnabled) as? Bool ?? true
        
        if let data = defaults.data(forKey: kSessions),
           let decoded = try? JSONDecoder().decode([Session].self, from: data) {
            sessions = decoded
        }
    }
}
