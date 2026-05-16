import { useEffect, useMemo, useState } from 'react'
import './App.css'

const focusRanks = ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Mythic']
const widgetData = [
  { label: 'Study Hours', value: '6.8h', trend: '+0.9h' },
  { label: 'Water Intake', value: '2.1L', trend: '84%' },
  { label: 'AI Focus Score', value: '92', trend: '+4' },
  { label: 'Daily XP', value: '480', trend: '+120' },
  { label: 'Goal Completion', value: '78%', trend: '+11%' },
  { label: 'JEE Countdown', value: '196 days', trend: 'steady' },
  { label: 'Music Sync', value: 'Lo-fi Drift', trend: 'ambient' },
  { label: 'Sleep Tracker', value: '7h 24m', trend: 'optimal' },
  { label: 'Consistency', value: '89%', trend: '+6%' },
]

const initialMissions = [
  { id: 1, text: 'Complete 3 pomodoro sessions', xp: 120, done: false },
  { id: 2, text: 'Finish calculus revision sprint', xp: 90, done: false },
  { id: 3, text: 'Hydrate 2L + stretch break', xp: 60, done: false },
]

const heatmap = [
  [1, 2, 3, 2, 4, 3, 2],
  [2, 3, 1, 4, 3, 2, 3],
  [3, 4, 2, 3, 4, 4, 2],
  [2, 2, 3, 4, 3, 2, 1],
]

const clamp = (value, min, max) => Math.min(max, Math.max(min, value))

function useLocalState(key, fallback) {
  const [state, setState] = useState(() => {
    const stored = localStorage.getItem(key)
    return stored ? JSON.parse(stored) : fallback
  })

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(state))
  }, [key, state])

  return [state, setState]
}

function App() {
  const [xp, setXp] = useLocalState('grindos-xp', 980)
  const [streak, setStreak] = useLocalState('grindos-streak', 16)
  const [focusMode, setFocusMode] = useLocalState('grindos-focus', false)
  const [allowedApps, setAllowedApps] = useLocalState('grindos-allowed-apps', true)
  const [ambient, setAmbient] = useLocalState('grindos-ambient', true)
  const [timer, setTimer] = useLocalState('grindos-timer', 25 * 60)
  const [running, setRunning] = useState(false)
  const [missions, setMissions] = useLocalState('grindos-missions', initialMissions)
  const [panel, setPanel] = useState('home')
  const [islandMessage, setIslandMessage] = useState('')
  const [timeNow, setTimeNow] = useState(new Date())
  const [touchX, setTouchX] = useState(0)

  const level = Math.floor(xp / 500) + 1
  const levelXp = xp % 500
  const xpProgress = (levelXp / 500) * 100
  const completedMissions = missions.filter((mission) => mission.done).length
  const rankIndex = clamp(Math.floor(level / 3), 0, focusRanks.length - 1)

  const productivityGraph = useMemo(
    () => [62, 70, 67, 78, 81, 75, 89].map((value, i) => ({ id: i, value })),
    [],
  )

  const badges = useMemo(
    () => [
      'Pomodoro Pilot',
      streak >= 14 ? 'Streak Titan' : 'Streak Rising',
      xp >= 1500 ? 'Deep Work Elite' : 'Deep Work Rookie',
      focusMode ? 'Focus Shield Active' : 'Shield Standby',
    ],
    [focusMode, streak, xp],
  )

  useEffect(() => {
    const timerId = setInterval(() => setTimeNow(new Date()), 1000)
    return () => clearInterval(timerId)
  }, [])

  useEffect(() => {
    if (!running) {
      return undefined
    }

    const interval = setInterval(() => {
      setTimer((seconds) => {
        if (seconds <= 1) {
          clearInterval(interval)
          setRunning(false)
          setXp((current) => current + 50)
          setIslandMessage('Pomodoro complete +50 XP')
          return 25 * 60
        }
        return seconds - 1
      })
    }, 1000)

    return () => clearInterval(interval)
  }, [running, setXp, setTimer])

  useEffect(() => {
    if (!islandMessage) {
      return undefined
    }

    const timeout = setTimeout(() => setIslandMessage(''), 2200)
    return () => clearTimeout(timeout)
  }, [islandMessage])

  useEffect(() => {
    const dynamicHue = (timeNow.getHours() * 15 + timeNow.getMinutes()) % 360
    document.documentElement.style.setProperty('--accent-hue', String(dynamicHue))
  }, [timeNow])

  const addXp = (amount, message) => {
    setXp((current) => current + amount)
    setIslandMessage(message)
  }

  const toggleMission = (missionId) => {
    setMissions((currentMissions) =>
      currentMissions.map((mission) => {
        if (mission.id !== missionId) {
          return mission
        }
        if (!mission.done) {
          addXp(mission.xp, `${mission.text} +${mission.xp} XP`)
        }
        return { ...mission, done: !mission.done }
      }),
    )
  }

  const toggleFocus = () => {
    setFocusMode((value) => !value)
    setIslandMessage(focusMode ? 'Focus mode disabled' : 'Focus mode enabled')
    if (!focusMode) {
      setAmbient(true)
    }
  }

  const onSwipeStart = (event) => setTouchX(event.changedTouches[0].clientX)

  const onSwipeEnd = (event) => {
    const panels = ['home', 'widgets', 'missions']
    const delta = event.changedTouches[0].clientX - touchX
    if (Math.abs(delta) < 50) {
      return
    }

    const index = panels.indexOf(panel)
    const next = delta < 0 ? clamp(index + 1, 0, 2) : clamp(index - 1, 0, 2)
    setPanel(panels[next])
  }

  return (
    <main
      className={`grindos ${focusMode ? 'focus' : ''}`}
      onTouchStart={onSwipeStart}
      onTouchEnd={onSwipeEnd}
    >
      <div className={`dynamic-island ${islandMessage ? 'show' : ''}`}>{islandMessage}</div>

      <header className="top-panel glass">
        <div>
          <p className="label">GrindOS // Device Transformation Mode</p>
          <h1>{timeNow.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</h1>
          <p className="subtle">AI Planner: Deep study block suggested at 19:30</p>
        </div>
        <div className="quick-actions">
          <button type="button" onClick={() => addXp(25, 'Quick task complete +25 XP')}>
            +XP Burst
          </button>
          <button
            type="button"
            onClick={() => {
              setStreak((value) => value + 1)
              setIslandMessage('Daily streak extended')
            }}
          >
            Claim Streak
          </button>
          <button type="button" onClick={toggleFocus}>
            {focusMode ? 'Disable Focus' : 'Enable Focus'}
          </button>
          <button
            type="button"
            onClick={() => {
              setFocusMode(true)
              setAllowedApps(true)
              setAmbient(true)
              setIslandMessage('Transformation mode activated')
            }}
          >
            Transform
          </button>
        </div>
      </header>

      <section className="dock glass">
        {['home', 'widgets', 'missions'].map((item) => (
          <button
            key={item}
            type="button"
            className={panel === item ? 'active' : ''}
            onClick={() => setPanel(item)}
          >
            {item}
          </button>
        ))}
      </section>

      {panel === 'home' && (
        <section className="panel-grid">
          <article className="glass card xp">
            <p className="label">XP Progress</p>
            <div className="level-row">
              <h2>Level {level}</h2>
              <span className="rank">{focusRanks[rankIndex]}</span>
            </div>
            <div className="progress">
              <span style={{ width: `${xpProgress}%` }} />
            </div>
            <p>{levelXp}/500 XP to next level</p>
          </article>

          <article className="glass card">
            <p className="label">Daily Streak</p>
            <h2>🔥 {streak} days</h2>
            <p>Combo multiplier x{(1 + streak / 20).toFixed(1)}</p>
          </article>

          <article className="glass card timer">
            <p className="label">Focus Timer • Pomodoro</p>
            <h2>
              {String(Math.floor(timer / 60)).padStart(2, '0')}:{String(timer % 60).padStart(2, '0')}
            </h2>
            <div className="button-row">
              <button type="button" onClick={() => setRunning((value) => !value)}>
                {running ? 'Pause' : 'Start'}
              </button>
              <button
                type="button"
                onClick={() => {
                  setRunning(false)
                  setTimer(25 * 60)
                }}
              >
                Reset
              </button>
            </div>
          </article>

          <article className="glass card goals">
            <p className="label">Today&apos;s Goals / Daily Missions</p>
            <ul>
              {missions.map((mission) => (
                <li key={mission.id}>
                  <button type="button" onClick={() => toggleMission(mission.id)}>
                    {mission.done ? '●' : '○'}
                  </button>
                  <span>{mission.text}</span>
                </li>
              ))}
            </ul>
            <p>
              Completion {Math.round((completedMissions / missions.length) * 100)}% • Weekly boss challenge
              unlocked at 85%
            </p>
          </article>

          <article className="glass card graph">
            <p className="label">Study Analytics / Rank Prediction</p>
            <div className="bars">
              {productivityGraph.map((day) => (
                <span key={day.id} style={{ height: `${day.value}%` }} />
              ))}
            </div>
            <p>Projected rank: AIR 3,4xx if consistency remains above 82%</p>
          </article>

          <article className="glass card quote">
            <p className="label">Motivational Widget</p>
            <blockquote>
              Discipline compounds faster than motivation. Stack one deep-work session at a time.
            </blockquote>
            <p>Ambient: {ambient ? 'Enabled' : 'Muted'} • Allowed apps: {allowedApps ? 'On' : 'Off'}</p>
            <div className="button-row">
              <button type="button" onClick={() => setAmbient((value) => !value)}>
                Ambient Sounds
              </button>
              <button type="button" onClick={() => setAllowedApps((value) => !value)}>
                Allowed Apps Mode
              </button>
            </div>
          </article>

          <article className="glass card heatmap-card">
            <p className="label">Productivity Heatmap</p>
            <div className="heatmap">
              {heatmap.flat().map((cell, index) => (
                <span key={index} style={{ opacity: cell / 5 }} />
              ))}
            </div>
          </article>

          <article className="glass card">
            <p className="label">Achievements + Skill Tree</p>
            <ul className="badge-list">
              {badges.map((badge) => (
                <li key={badge}>{badge}</li>
              ))}
            </ul>
          </article>
        </section>
      )}

      {panel === 'widgets' && (
        <section className="panel-grid widgets">
          {widgetData.map((widget) => (
            <article key={widget.label} className="glass card widget-card">
              <p className="label">{widget.label}</p>
              <h2>{widget.value}</h2>
              <p>{widget.trend}</p>
            </article>
          ))}
        </section>
      )}

      {panel === 'missions' && (
        <section className="panel-grid">
          <article className="glass card full">
            <p className="label">Focus Mode State</p>
            <p>
              Distracting apps {focusMode ? 'hidden' : 'visible'} • Grayscale {focusMode ? 'enabled' : 'off'} •
              notifications {focusMode ? 'minimized' : 'normal'}
            </p>
          </article>
          <article className="glass card full">
            <p className="label">RPG Progression</p>
            <p>
              Rank: {focusRanks[rankIndex]} → {focusRanks[Math.min(rankIndex + 1, focusRanks.length - 1)]} •
              Unlockable themes: Neon Slate, Lunar Mono, Hyper Grid
            </p>
          </article>
          <article className="glass card full">
            <p className="label">Habit Engine + Smart Reminders</p>
            <p>
              Next reminders: Physics numericals in 38m, hydration in 22m, sleep wind-down at 23:00.
            </p>
          </article>
        </section>
      )}
    </main>
  )
}

export default App
