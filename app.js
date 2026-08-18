/**
 * 1000 Hours Clock - Mastery Tracker Engine
 * Deliberate Practice & Skill Mastery Tracker
 */

const TARGET_HOURS = 1000;
const TARGET_SECONDS = TARGET_HOURS * 3600; // 3,600,000 seconds
const CIRCLE_CIRCUMFERENCE = 942.48; // 2 * PI * 150

// Motivational Quotes for DSA / Engineering Problem Solving
const MOTIVATIONAL_QUOTES = [
  "\"We are what we repeatedly do. Excellence, then, is not an act, but a habit.\" — Aristotle",
  "\"The difference between ordinary and extraordinary is that little extra.\" — Jimmy Johnson",
  "\"Mastery is not a function of genius or talent, it is a function of time and intense focus.\" — Robert Greene",
  "\"Solve 1 problem deeply rather than 10 problems superficially.\" — Top 0.1% LeetCode Guide",
  "\"Consistency over intensity. 2 hours of daily deliberate practice beats 14 hours on Sunday.\"",
  "\"Every single problem you struggle with is expanding your neural problem-solving architecture.\"",
  "\"Embrace the grind. The first 250 hours build intuition, the next 750 build instinct.\""
];

// App State
let state = {
  isRunning: false,
  accumulatedSeconds: 0,
  sessionStartTimestamp: null,
  activeSessionDuration: 0,
  currentSkill: "Data Structures & Algorithms",
  soundEnabled: true,
  compactMode: false,
  sessions: [], // [{ id, skill, start, end, durationSeconds }]
  todaySeconds: 0,
  streakDays: 1,
};

// DOM Elements
const hoursValEl = document.getElementById("hoursVal");
const minutesValEl = document.getElementById("minutesVal");
const secondsValEl = document.getElementById("secondsVal");
const menubarTimeEl = document.getElementById("menubarTime");
const percentageValEl = document.getElementById("percentageVal");
const remainingValEl = document.getElementById("remainingVal");
const progressRingBarEl = document.getElementById("progressRingBar");
const milestoneRankBadgeEl = document.getElementById("milestoneRankBadge");

const mainPlayPauseBtn = document.getElementById("mainPlayPauseBtn");
const mainBtnTextEl = document.getElementById("mainBtnText");
const menubarPlayBtn = document.getElementById("menubarPlayBtn");
const stateTextEl = document.getElementById("stateText");

const skillNameInputEl = document.getElementById("skillNameInput");
const statusSkillTagEl = document.getElementById("statusSkillTag");
const motivationalQuoteEl = document.getElementById("motivationalQuote");

const todayMetricEl = document.getElementById("todayMetric");
const sessionsCountTextEl = document.getElementById("sessionsCountText");
const streakMetricEl = document.getElementById("streakMetric");
const etaMetricEl = document.getElementById("etaMetric");
const etaSubtextEl = document.getElementById("etaSubtext");
const logsListEl = document.getElementById("logsList");

const soundToggleBtn = document.getElementById("soundToggleBtn");
const compactModeBtn = document.getElementById("compactModeBtn");
const realTimeClockEl = document.getElementById("realTimeClock");

// Audio Synthesizer for tactile UI clicks
let audioCtx = null;
function playUiSound(type = "click") {
  if (!state.soundEnabled) return;
  try {
    if (!audioCtx) {
      audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    }
    if (audioCtx.state === "suspended") {
      audioCtx.resume();
    }
    const osc = audioCtx.createOscillator();
    const gain = audioCtx.createGain();
    osc.connect(gain);
    gain.connect(audioCtx.destination);

    if (type === "start") {
      osc.type = "sine";
      osc.frequency.setValueAtTime(587.33, audioCtx.currentTime); // D5
      osc.frequency.exponentialRampToValueAtTime(880, audioCtx.currentTime + 0.12); // A5
      gain.gain.setValueAtTime(0.08, audioCtx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.15);
      osc.start();
      osc.stop(audioCtx.currentTime + 0.16);
    } else if (type === "pause") {
      osc.type = "sine";
      osc.frequency.setValueAtTime(659.25, audioCtx.currentTime); // E5
      osc.frequency.exponentialRampToValueAtTime(440, audioCtx.currentTime + 0.12); // A4
      gain.gain.setValueAtTime(0.08, audioCtx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.15);
      osc.start();
      osc.stop(audioCtx.currentTime + 0.16);
    }
  } catch (e) {
    // Audio might fail if policy blocks before interaction
  }
}

// -------------------------------------------------------------
// Persistence & Local Storage
// -------------------------------------------------------------
function saveState() {
  const dataToSave = {
    accumulatedSeconds: state.accumulatedSeconds,
    isRunning: state.isRunning,
    sessionStartTimestamp: state.sessionStartTimestamp,
    currentSkill: state.currentSkill,
    soundEnabled: state.soundEnabled,
    compactMode: state.compactMode,
    sessions: state.sessions.slice(-50), // keep latest 50
    lastActiveDate: new Date().toDateString()
  };
  localStorage.setItem("1000_hours_clock_data", JSON.stringify(dataToSave));
}

function loadState() {
  const saved = localStorage.getItem("1000_hours_clock_data");
  if (saved) {
    try {
      const parsed = JSON.parse(saved);
      state.accumulatedSeconds = parsed.accumulatedSeconds || 0;
      state.currentSkill = parsed.currentSkill || "Data Structures & Algorithms";
      state.soundEnabled = parsed.soundEnabled !== undefined ? parsed.soundEnabled : true;
      state.compactMode = parsed.compactMode || false;
      state.sessions = parsed.sessions || [];

      // If user left timer running and closed/refreshed the tab, compute exact elapsed delta
      if (parsed.isRunning && parsed.sessionStartTimestamp) {
        const delta = Math.floor((Date.now() - parsed.sessionStartTimestamp) / 1000);
        if (delta > 0) {
          state.accumulatedSeconds += delta;
          // Record the past session
          state.sessions.unshift({
            id: Date.now(),
            skill: state.currentSkill,
            start: new Date(parsed.sessionStartTimestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
            date: new Date(parsed.sessionStartTimestamp).toLocaleDateString(),
            durationSeconds: delta
          });
        }
      }
      state.isRunning = false;
      state.sessionStartTimestamp = null;
    } catch (e) {
      console.error("Error parsing saved state:", e);
    }
  }
}

// -------------------------------------------------------------
// Formatters
// -------------------------------------------------------------
function formatDigits(num, digits = 2) {
  return String(Math.floor(num)).padStart(digits, '0');
}

function formatDurationHms(totalSecs) {
  const h = Math.floor(totalSecs / 3600);
  const m = Math.floor((totalSecs % 3600) / 60);
  const s = Math.floor(totalSecs % 60);
  return {
    h: formatDigits(h, 3),
    m: formatDigits(m, 2),
    s: formatDigits(s, 2),
    formatted: `${formatDigits(h, 3)}:${formatDigits(m, 2)}:${formatDigits(s, 2)}`
  };
}

function formatHoursMinutes(totalSecs) {
  const h = Math.floor(totalSecs / 3600);
  const m = Math.floor((totalSecs % 3600) / 60);
  return `${h}h ${formatDigits(m, 2)}m`;
}

// -------------------------------------------------------------
// UI Rendering
// -------------------------------------------------------------
function render() {
  const totalSeconds = state.accumulatedSeconds + state.activeSessionDuration;
  const time = formatDurationHms(totalSeconds);

  // Big Clock Digits
  hoursValEl.textContent = time.h;
  minutesValEl.textContent = time.m;
  secondsValEl.textContent = time.s;

  // Menubar Display
  menubarTimeEl.textContent = time.formatted;

  // Percentage & Remaining
  const percent = Math.min(100, (totalSeconds / TARGET_SECONDS) * 100);
  percentageValEl.textContent = `${percent.toFixed(2)}%`;

  const remainingSeconds = Math.max(0, TARGET_SECONDS - totalSeconds);
  const remH = Math.floor(remainingSeconds / 3600);
  const remM = Math.floor((remainingSeconds % 3600) / 60);
  remainingValEl.textContent = `${remH}h ${formatDigits(remM, 2)}m remaining`;

  // SVG Radial Progress Fill
  const offset = CIRCLE_CIRCUMFERENCE - (percent / 100) * CIRCLE_CIRCUMFERENCE;
  progressRingBarEl.style.strokeDashoffset = offset;

  // Rank / Milestone Badge
  let rank = "Apprentice";
  let rankColor = "#38bdf8";
  const hours = totalSeconds / 3600;

  if (hours >= 1000) {
    rank = "Grandmaster 🏆";
    rankColor = "#10b981";
  } else if (hours >= 750) {
    rank = "Expert";
    rankColor = "#a855f7";
  } else if (hours >= 500) {
    rank = "Practitioner";
    rankColor = "#6366f1";
  } else if (hours >= 250) {
    rank = "Journeyman";
    rankColor = "#38bdf8";
  }

  milestoneRankBadgeEl.textContent = `${rank} • ${percent.toFixed(1)}% Complete`;

  // Milestone Step Cards
  updateMilestoneSteps(hours);

  // Play / Pause State Classes
  if (state.isRunning) {
    document.body.classList.add("timing-active");
    stateTextEl.textContent = "PRACTICING";
    mainBtnTextEl.textContent = "PAUSE PRACTICE";
  } else {
    document.body.classList.remove("timing-active");
    stateTextEl.textContent = "PAUSED";
    mainBtnTextEl.textContent = totalSeconds > 0 ? "RESUME PRACTICE" : "START PRACTICE";
  }

  // Active Skill
  skillNameInputEl.value = state.currentSkill;
  statusSkillTagEl.textContent = state.currentSkill;

  // Document Title Live Updating (Visible on browser tab)
  const icon = state.isRunning ? "▶" : "⏸";
  document.title = `${icon} ${time.formatted} / 1000h | ${state.currentSkill}`;

  // Metrics
  updateStats(totalSeconds);
}

function updateMilestoneSteps(hours) {
  const steps = [
    { el: document.getElementById("step250"), badge: document.getElementById("badge250"), target: 250, label: "250h Achieved" },
    { el: document.getElementById("step500"), badge: document.getElementById("badge500"), target: 500, label: "500h Achieved" },
    { el: document.getElementById("step750"), badge: document.getElementById("badge750"), target: 750, label: "750h Achieved" },
    { el: document.getElementById("step1000"), badge: document.getElementById("badge1000"), target: 1000, label: "Mastery Complete!" }
  ];

  steps.forEach(step => {
    if (hours >= step.target) {
      step.el.classList.add("unlocked");
      step.badge.textContent = step.label;
    } else {
      step.el.classList.remove("unlocked");
      const hrsLeft = Math.ceil(step.target - hours);
      step.badge.textContent = `${hrsLeft}h left`;
    }
  });
}

function updateStats(totalSeconds) {
  // Today's total
  const todayDateStr = new Date().toLocaleDateString();
  const todaySessions = state.sessions.filter(s => s.date === todayDateStr);
  let todaySec = todaySessions.reduce((acc, s) => acc + s.durationSeconds, 0);
  if (state.isRunning) {
    todaySec += state.activeSessionDuration;
  }
  todayMetricEl.textContent = formatHoursMinutes(todaySec);
  sessionsCountTextEl.textContent = `${todaySessions.length + (state.isRunning ? 1 : 0)} session(s) today`;

  // Estimate completion date based on 2 hours/day default pace
  const remainingHours = Math.max(0, TARGET_HOURS - (totalSeconds / 3600));
  const avgDailyHours = 2; // benchmark pace
  const daysRemaining = Math.ceil(remainingHours / avgDailyHours);
  const targetDate = new Date();
  targetDate.setDate(targetDate.getDate() + daysRemaining);
  
  if (remainingHours <= 0) {
    etaMetricEl.textContent = "Complete!";
    etaSubtextEl.textContent = "1,000 Hours Achieved 🎉";
  } else {
    etaMetricEl.textContent = targetDate.toLocaleDateString([], { month: 'short', day: 'numeric', year: 'numeric' });
    etaSubtextEl.textContent = `At 2h/day: ~${daysRemaining} days`;
  }

  // Render recent sessions list
  renderLogs();
}

function renderLogs() {
  if (!state.sessions || state.sessions.length === 0) {
    logsListEl.innerHTML = `<div class="empty-logs">No previous sessions yet. Click Start Practice to log your first hour!</div>`;
    return;
  }

  logsListEl.innerHTML = state.sessions.slice(0, 8).map(s => {
    return `
      <div class="log-entry">
        <div>
          <span class="log-skill">${escapeHtml(s.skill || "Practice")}</span>
          <span class="log-date">${s.date || ""} ${s.start || ""}</span>
        </div>
        <span class="log-duration">+${formatHoursMinutes(s.durationSeconds)}</span>
      </div>
    `;
  }).join("");
}

function escapeHtml(text) {
  const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
  return text.replace(/[&<>"']/g, m => map[m]);
}

// -------------------------------------------------------------
// Timer Logic (High Precision Delta)
// -------------------------------------------------------------
let animationFrameId = null;
let lastTickSecond = 0;

function tick() {
  if (!state.isRunning) return;

  const now = Date.now();
  state.activeSessionDuration = Math.floor((now - state.sessionStartTimestamp) / 1000);

  // Update UI and save state every second
  const currentSec = state.activeSessionDuration;
  if (currentSec !== lastTickSecond) {
    lastTickSecond = currentSec;
    render();
    saveState();
  }

  animationFrameId = requestAnimationFrame(tick);
}

function togglePlayPause() {
  if (state.isRunning) {
    // PAUSE ACTION
    pauseTimer();
    playUiSound("pause");
  } else {
    // START / RESUME ACTION
    startTimer();
    playUiSound("start");
  }
}

function startTimer() {
  state.isRunning = true;
  state.sessionStartTimestamp = Date.now();
  state.activeSessionDuration = 0;
  lastTickSecond = 0;
  render();
  saveState();
  animationFrameId = requestAnimationFrame(tick);
}

function pauseTimer() {
  if (!state.isRunning) return;
  state.isRunning = false;

  const elapsed = state.activeSessionDuration;
  if (elapsed > 0) {
    state.accumulatedSeconds += elapsed;

    // Log this session
    state.sessions.unshift({
      id: Date.now(),
      skill: state.currentSkill,
      start: new Date(state.sessionStartTimestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      date: new Date(state.sessionStartTimestamp).toLocaleDateString(),
      durationSeconds: elapsed
    });
  }

  state.activeSessionDuration = 0;
  state.sessionStartTimestamp = null;

  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId);
  }

  render();
  saveState();
}

// -------------------------------------------------------------
// Real-time macOS Status Bar Clock
// -------------------------------------------------------------
function updateRealTimeClock() {
  const now = new Date();
  realTimeClockEl.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}
setInterval(updateRealTimeClock, 1000);
updateRealTimeClock();

// -------------------------------------------------------------
// Motivational Quote Rotator
// -------------------------------------------------------------
function rotateQuote() {
  const quote = MOTIVATIONAL_QUOTES[Math.floor(Math.random() * MOTIVATIONAL_QUOTES.length)];
  motivationalQuoteEl.style.opacity = '0';
  setTimeout(() => {
    motivationalQuoteEl.textContent = quote;
    motivationalQuoteEl.style.opacity = '1';
  }, 400);
}
setInterval(rotateQuote, 30000);

// -------------------------------------------------------------
// Event Listeners
// -------------------------------------------------------------
mainPlayPauseBtn.addEventListener("click", togglePlayPause);
menubarPlayBtn.addEventListener("click", togglePlayPause);

// Keyboard Shortcut: Spacebar for Play/Pause
document.addEventListener("keydown", (e) => {
  // Ignore if user is currently typing inside the skill input
  if (e.target === skillNameInputEl) return;

  if (e.code === "Space") {
    e.preventDefault();
    togglePlayPause();
  } else if (e.key === "m" || e.key === "M") {
    toggleCompactMode();
  }
});

// Skill Name Editing
skillNameInputEl.addEventListener("input", (e) => {
  state.currentSkill = e.target.value || "Data Structures & Algorithms";
  statusSkillTagEl.textContent = state.currentSkill;
  saveState();
});

// Compact Mode Switcher
function toggleCompactMode() {
  state.compactMode = !state.compactMode;
  if (state.compactMode) {
    document.body.classList.add("compact-mode");
  } else {
    document.body.classList.remove("compact-mode");
  }
  saveState();
}
compactModeBtn.addEventListener("click", toggleCompactMode);

// Sound Toggle
soundToggleBtn.addEventListener("click", () => {
  state.soundEnabled = !state.soundEnabled;
  soundToggleBtn.style.opacity = state.soundEnabled ? "1" : "0.4";
  saveState();
});

// Window Visibility Change (Ensure exact delta when tab returns to focus)
document.addEventListener("visibilitychange", () => {
  if (state.isRunning) {
    const now = Date.now();
    state.activeSessionDuration = Math.floor((now - state.sessionStartTimestamp) / 1000);
    render();
  }
});

// Initialize on Load
window.addEventListener("DOMContentLoaded", () => {
  loadState();
  if (state.compactMode) {
    document.body.classList.add("compact-mode");
  }
  if (!state.soundEnabled) {
    soundToggleBtn.style.opacity = "0.4";
  }
  render();
});
