# NFSx86 - Need For Speed x86 🏎️

<div align="center">
A retro-style racing game written entirely in x86 Assembly for DOS

Dodge traffic, collect coins, manage fuel, and race to the finish!

**Features • Installation • Controls • Screenshots • Development**
</div>

---

## 📖 About

NFSx86 is a passion project that brings back the nostalgia of classic DOS racing games. Built from scratch using pure x86 assembly language, this game demonstrates low-level programming mastery and the power of working close to the hardware.

## 🎮 Game Concept

Race down a procedurally scrolling highway, avoiding NPC vehicles while collecting coins and fuel pickups. With dynamic difficulty settings, animated environments, and real-time collision detection, NFSx86 captures the essence of arcade racing in less than 64KB.

---

## ✨ Features

### Core Gameplay

- 🚗 Smooth player car movement with lane-based physics
- 🚙 Dynamic NPC traffic with intelligent spawning system
- 💰 Coin collection system with score tracking
- ⛽ Fuel management with depletion and refill mechanics
- 💥 Collision detection with visual spark effects
- 🌳 Animated scenery including trees and road markings
- 📊 Real-time HUD displaying score, fuel, and game name

### Game Modes

- 🎚️ Three difficulty levels: Easy, Medium, Hard
- 🔊 PC Speaker music and sound effects
- ⏸️ Pause functionality with in-game menu
- 🏁 Game over screens with restart option

### Visual Effects

- 🎨 Custom ASCII art car designs with color customization
- 🌲 Parallax scrolling road and environment
- ⚡ Particle effects for collisions
- 🎬 Animated intro sequence with loading bar
- 📺 50-line display mode for enhanced visuals

### Technical Features

- 🎹 Custom keyboard interrupt handler for responsive controls
- 🔄 Game state management with restart capability
- 📝 Player name and roll number input
- 🎵 Built-in PC Speaker music (composed via Python scripting)

---

## 🛠️ Technical Specifications

| Category | Details |
|----------|---------|
| **Language** | x86 Assembly (NASM syntax) |
| **Architecture** | 16-bit Real Mode DOS |
| **File Format** | COM executable (< 64KB) |
| **Target Platform** | MS-DOS / DOSBox |
| **Display Mode** | Text Mode 80x25/50 (VGA) |
| **Memory Model** | Tiny (CS=DS=ES=SS) |
| **Audio** | PC Speaker (internal music/SFX) |

### System Requirements

**Minimum:**
- Intel 80486 DX4-100 or equivalent
- 4 MB RAM
- VGA compatible display
- DOSBox 0.74-3 or later

**Recommended:**
- Intel Pentium or better
- 8 MB RAM
- DOSBox with integrated development environment

---

## 📥 Installation

### Prerequisites

1. **DOSBox** (version 0.74-3 or later)
   - Download from: [dosbox.com](https://www.dosbox.com)

2. **Notepad++** with NppExec plugin (for development)
   - Download from: [notepad-plus-plus.org](https://notepad-plus-plus.org)
   - Install NppExec plugin for DOSBox integration

3. **NASM Assembler** (version 2.14 or later)
   - Download from: [nasm.us](https://www.nasm.us)

---

### Quick Start

#### Option 1: Run Pre-compiled Game

```bash
# 1. Extract the release package
unzip NFSx86-v1.0.zip

# 2. Navigate to game directory
cd NFSx86

# 3. Run in DOSBox
dosbox game.com
```

#### Option 2: Build from Source

**Step 1: Clone the Repository**

```bash
git clone https://github.com/yourusername/NFSx86.git
cd NFSx86
```

**Step 2: Configure Notepad++ NppExec**

1. Open Notepad++ and install the NppExec plugin
2. Press `F6` to open NppExec console
3. Add this script:

```batch
NPP_SAVE
CD "$(CURRENT_DIRECTORY)"
nasm -f bin -o game.com game.asm
dosbox game.com -exit
```

4. Save as "Compile and Run"

**Step 3: Build and Run**

1. Open `game.asm` in Notepad++
2. Press `F6` and select "Compile and Run"
3. Game will compile and launch in DOSBox

#### Option 3: Manual Compilation

```bash
# Compile the game
nasm -f bin -o game.com game.asm

# Run in DOSBox
dosbox game.com
```

---

## 🎮 Controls

### Main Menu & Navigation

| Key | Action |
|-----|--------|
| `↑` `↓` | Navigate menu options |
| `Enter` | Select / Confirm |
| `ESC` | Pause / Exit |
| `M` / `=` | Toggle music on/off |

### Gameplay

| Key | Action |
|-----|--------|
| `←` `→` | Change lanes |
| `↑` `↓` | Move vertically |
| `ESC` | Pause game |
| `Space` | Start game (on start screen) |

### Pause Menu

| Key | Action |
|-----|--------|
| `Y` | Quit to menu |
| `N` / `ESC` | Resume game |

---

## 🎯 Gameplay Guide

### Objective

Survive as long as possible while collecting coins and managing fuel!

### Game Elements

#### 🚗 Player Car
- Your car (cyan with custom ASCII art)
- Can move between 3 lanes
- Limited vertical movement

#### 🚙 NPC Cars
- Red enemy vehicles
- Move down the screen
- Collision = Game Over

#### 💰 Coins ($)
- Yellow dollar signs
- +10 points per coin (varies by difficulty)
- Spawn randomly in lanes

#### ⛽ Fuel (+)
- Red plus symbols
- Refills fuel tank
- Essential for survival

#### 🌳 Trees
- Green decorative elements
- Scroll down for parallax effect
- No collision (scenery only)

### Difficulty Levels

| Difficulty | NPC Speed | Fuel Decay | Coin Value |
|------------|-----------|------------|------------|
| **Easy** | Slow | Low | +5 points |
| **Medium** | Normal | Medium | +10 points |
| **Hard** | Fast | High | +15 points |

### Tips & Strategies

1. **Fuel Management**: Always prioritize fuel pickups over coins
2. **Lane Positioning**: Stay in center lane for maximum reaction time
3. **Predict Movement**: Watch for NPC spawn patterns
4. **Score Combo**: Collect multiple coins in succession
5. **Vertical Movement**: Use up/down to dodge last-second threats

---

## 📸 Screenshots

<div align="center">

### Main Menu

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║              N E E D   F O R   S P E E D   x 8 6            ║
║                                                              ║
║                    [Loading...........]                      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

### Gameplay

```
F:[███████████████] Score: 0245  NFSx86

           m^^m
        ##/____\##        
        ##\____/##
          [____]
        ##/____\##        $
        ##\@%%@/##
          ||  ||
                          
║         │         │         ║
║         │    $    │         ║
║    m___m│         │         ║
║   #/___\│         │  m___m  ║
║   {___} │         │ #/___\#║
║   #!___!│    +    │  {___} ║
║         │         │ #!___!#║
```

### Game Over

```
╔══════════════════════════════════════════════════════════════╗
║                       GAME OVER                              ║
║                                                              ║
║                  Cause: Car Crash                            ║
║                                                              ║
║              Player: GoodRacer                               ║
║              Roll No: XXXXXXXX                               ║
║              Final Score: 0845                               ║
║                                                              ║
║         SPACE - Main Menu  |  ESC - Exit                     ║
╚══════════════════════════════════════════════════════════════╝
```

</div>

---

## 🏗️ Development

### Project Structure

```
COAL-Semester-Project/
│── NFSx86.asm        # Assembly Code
│── NFSx86.com        # Compiled executable(Dosbox)
├── BugReports/
│   └── README.md     # Instructions for reporting bugs
├── FeatureRequests/
│   └── README.md     # Instructions for requesting new features
├── README.md         # Main project README (links to phases and other folders)
├── LICENSE           # License information
├── .gitignore        # Ignore compiled files and temp files

```

### Code Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      MAIN GAME LOOP                         │
├─────────────────────────────────────────────────────────────┤
│  1. Check Keyboard Input (ISR Handler)                      │
│  2. Update Game State                                        │
│     ├─ Move Player                                          │
│     ├─ Move NPCs                                            │
│     ├─ Move Coins & Fuel                                    │
│     ├─ Scroll Road & Trees                                  │
│     └─ Update Fuel Decay                                    │
│  3. Collision Detection                                      │
│     ├─ Player vs NPCs                                       │
│     ├─ Player vs Coins                                      │
│     └─ Player vs Fuel                                       │
│  4. Render Frame                                             │
│     ├─ Draw Road & Scenery                                  │
│     ├─ Draw Entities                                        │
│     └─ Update HUD                                           │
│  5. Game Over Check                                          │
│  6. Delay (Frame Rate Control)                              │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

#### 1. **Rendering Engine** (`draw_*` subroutines)
- Direct video memory access (0xB800)
- Custom ASCII art car rendering
- Scrolling road animation
- Particle system for effects

#### 2. **Physics System** (`move_*` subroutines)
- Lane-based movement
- Vertical position control
- NPC spawning algorithm
- Collision detection (AABB)

#### 3. **Input Handler** (`keyboard_isr`)
- Custom interrupt service routine (INT 09h)
- Non-blocking input
- Key flag system for smooth controls

#### 4. **Game State Manager**
- Screen transitions
- Save/load functionality
- Difficulty settings
- Score tracking

#### 5. **Audio System** (PC Speaker)
- Built-in music tracks (composed via Python scripting)
- Track used [lastminute.xm](https://modarchive.org/index.php?request=view_player&query=160977) from [The Mod Archive](https://modarchive.org)
- Notes extracted via python scripting
- PC speaker beeps for effects
- Event-driven sound triggers
- Music toggle functionality (=/M key in menu/game)

---

## 🧪 Testing

### Test Scenarios

- [x] Player movement in all directions
- [x] Lane changing with boundary checks
- [x] Collision detection accuracy
- [x] Coin collection and scoring
- [x] Fuel depletion and refill
- [x] NPC spawning and movement
- [x] Game over conditions
- [x] Pause and resume functionality
- [x] Difficulty scaling
- [x] Screen transitions
- [x] Music playback via PC Speaker
- [x] Sound effects triggering
- [x] Music mute/unmute toggle

### Known Issues

- ⚠️ **PC Speaker Music**: Music quality limited by PC Speaker capabilities
- ⚠️ **DOSBox Compatibility**: Tested on DOSBox 0.74-3. Older versions may have timing issues.
- ⚠️ **Save System**: High scores reset on game restart (planned for v2.0).

### Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| DOSBox 0.74-3 | ✅ Fully Supported | Recommended |
| DOSBox 0.74-2 | ✅ Supported | Minor timing differences |
| Real DOS Hardware | ⚠️ Untested | Should work on 486+ |
| FreeDOS | ⚠️ Untested | Likely compatible |
| Windows DOS Prompt | ❌ Not Supported | Use DOSBox |

---

## 👥 Team

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/identicons/alijawad.png" width="100" alt="Ali Jawad"/><br />
      <sub><b>Ali Jawad</b></sub><br />
      <sub>xx---xx</sub><br />
      <a href="mailto:alijawad0047@gmail.com">📧 Email</a>
    </td>
    <td align="center">
      <img src="https://github.com/identicons/aneeqkamran.png" width="100" alt="Aneeq Kamran"/><br />
      <sub><b>Aneeq Kamran</b></sub><br />
      <sub>xx---xx</sub><br />
      <a href="mailto:your_correct_email@example.com">📧 Email</a>
    </td>
  </tr>
</table>


### Contributions

| Component | Primary Developer | Collaborator |
|-----------|------------------|--------------|
| Game Engine | Ali Jawad | Aneeq Kamran |
| Graphics & UI | Aneeq Kamran | Ali Jawad |
| Physics & Collision | Ali Jawad | Aneeq Kamran |
| Audio System (PC Speaker) | Both | - |
| Music Composition (Python) | Both | - |
| Testing & Debug | Both | - |

---

## 📚 Learning Resources

This project served as a deep dive into:
- x86 Assembly Language Programming
- DOS Interrupts and BIOS Calls
- Direct Hardware Access (Video, Keyboard, Speaker)
- Game Loop Architecture
- Collision Detection Algorithms
- Memory Management in Real Mode
- Interrupt Service Routines (ISR)
- PC Speaker Programming

### Recommended Reading

- **"Programming from the Ground Up"** by Jonathan Bartlett
- **"Art of Assembly Language"** by Randall Hyde
- **"PC Assembly Language"** by Paul A. Carter
- **NASM Documentation**: [nasm.us/docs.php](https://www.nasm.us/docs.php)
- **Ralf Brown's Interrupt List**: Comprehensive DOS/BIOS interrupt reference

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style Guidelines

- Use **4 spaces** for indentation (no tabs)
- Comment complex logic thoroughly
- Use meaningful label names
- Keep subroutines under 100 lines when possible
- Follow existing naming conventions

---

## 🙏 Acknowledgments

### Tools & Libraries

- **NASM** - The Netwide Assembler
- **DOSBox** - DOS Emulation
- **Notepad++** - Development environment
- **Python** - Music composition scripting

### Inspiration

- **Need For Speed (1994)** - Original inspiration
- **OutRun (1986)** - Arcade racing mechanics
- DOS Game Programming community

### Special Thanks

- Our instructor for guidance and support
- Open source community for tools and documentation
- Beta testers for valuable feedback
- Stack Overflow community for assembly language help

---

## 📞 Contact & Support

### Get in Touch

- **Issues**: [GitHub Issues](https://github.com/MrVorteX07/COAL-Semester-Project/issues/new?template=bug_report.md)
- **Discussions**: [GitHub Discussions](https://github.com/MrVorteX07/COAL-Semester-Project/issues/new?template=feature_request.md)
- **Email**: nfsx86@gmail.com

### FAQ

**Q: Why doesn't the game run?**  
A: Ensure you're using DOSBox 0.74-3+ and NASM is properly installed. Check the Installation section.

**Q: Can I run this on real DOS hardware?**  
A: Theoretically yes, but it's untested. You'll need a 486+ CPU with VGA display.

**Q: How do I add my own music?**  
A: Music is embedded in the assembly file. You would need to modify the music note arrays in `game.asm` and recompile. Music customization requires understanding of PC Speaker programming and Python scripting used for composition.

**Q: The game is too fast/slow!**  
A: Adjust DOSBox CPU cycles: `Ctrl+F11` (decrease) / `Ctrl+F12` (increase)

**Q: Can I modify the game?**  
A: Yes! It's open source under MIT License. Fork and customize away!

**Q: How do I turn off the music?**  
A: Press `M` key in game and `=` in menu to toggle music on/off.

---

## 📊 Project Stats

- **Total Lines**: ~10000 lines of assembly
- **Development Time**: 3 months
- **Compiled Size**: < 64 KB
- **Platforms Tested**: DOSBox (Windows, Linux, macOS)

---

<div align="center">

⭐ **Star this repository if you found it helpful!**

Made with ❤️ and ⚙️ by **Ali Jawad & Aneeq Kamran**

*A Computer Organization & Assembly Language Project*

[⬆ Back to Top](#nfsx86---need-for-speed-x86-️)

</div>

---

## 📜 Changelog

### v1.0.0 (December 2025) - Initial Release

- ✨ Complete racing game implementation
- 🎮 Three difficulty levels
- 🎵 PC Speaker music (composed via Python scripting)
- 🔊 PC Speaker sound effects
- 📊 Real-time score and fuel tracking
- 🎨 Custom ASCII art graphics
- ⚡ Particle collision effects
- 🌳 Parallax scrolling environment
- 🔇 Music mute/unmute toggle (= key in menu)

---

<div align="center">

[Download Latest Release](https://github.com/MrVorteX07/COAL-Semester-Project/tree/main) | [Report a Bug](https://github.com/MrVorteX07/COAL-Semester-Project/issues/new?template=bug_report.md)
| [Request Feature](https://github.com/MrVorteX07/COAL-Semester-Project/issues/new?template=feature_request.md)


</div>
