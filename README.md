# CrazyConquest

A real-time multiplayer grid conquest game on UNIX. Developed as a university project for the Operating Systems Lab course (Prof. Finzi), featuring C TCP sockets, non-blocking I/O, and dynamic fog-of-war.

---

## 📝 Project Description

**CrazyConquest** is a university project developed for the Operating Systems Laboratory course.

### Main Features

- **Client-Server Architecture**: Real-time communication managed via TCP sockets.
- **Territory Conquest**: Players explore the game grid and conquer cells by claiming ownership as they move across them.
- **Fog of War**: Map obstacles are discovered individually by each player during exploration.
- **Periodic Updates**: The server periodically sends the global map state and current player positions to all connected clients.

---

## 🚀 Quick Start & Developer Guide

### 📦 Prerequisites

Before starting development, ensure you have the required compiler, build tools, code formatter, and terminal emulator installed:

- **C Compiler & Build Tools** (C99 standard):
  - **macOS**: Installed via Xcode Command Line Tools (`xcode-select --install`)
  - **Linux**: `sudo apt-get install build-essential`
- **Code Formatter & Static Analyzer**:
  - **macOS**: `brew install clang-format cppcheck`
  - **Linux**: `sudo apt-get install build-essential clang clang-format cppcheck`

---

### 🛠️ Build & Run Commands

You can manage compilation, code formatting, and local testing entirely through `make`:

| Command | Action |
| :--- | :--- |
| **`make`** | **Do everything**: Formats C code, compiles binaries, and launches Server + 2 Clients. |
| **`make CLIENTS=N`** | Formats, compiles, and launches **Server + N Clients**. |
| **`make server`** | Formats C code, compiles, and launches **Server only**. |
| **`make server-sanitize`** | Compiles **Server only** with AddressSanitizer & UBSan and launches it. |
| **`make client`** | Formats C code, compiles, and launches **Clients only** (default: 2). |
| **`make client-sanitize`** | Compiles **Clients only** with AddressSanitizer & UBSan and launches them. |
| **`make run-sanitize`** | Compiles Server + Clients with **AddressSanitizer & UBSan** (detects memory leaks & out-of-bounds access) and launches both. |
| **`make build`** | Formats C code and compiles binaries (`bin/server` & `bin/client`) **without opening terminals**. |
| **`make format`** | Formats all `.c` and `.h` files using `clang-format`. |
| **`make check`** | Runs the local equivalent of GitHub Actions: formatting validation, GCC and Clang compilation, and `cppcheck`. |
| **`make clean`** | Removes all compiled binaries from `bin/`. |

---

### ✅ Validate Before Pushing

Before opening a pull request or pushing a change, run:

```bash
make check
```

This command does not modify source files. It verifies that formatting matches `clang-format`, compiles the project with both GCC and Clang, and runs the same `cppcheck` options used by GitHub Actions. If the command succeeds, the local checks match the GitHub Actions CI workflow.

---

### 🌿 Git & Feature Branching Workflow

To keep the repository clean and avoid code conflicts:

1. **Keep `main` stable**: The `main` branch must always compile and be runnable.
2. **Work in Feature Branches**: For new features, bug fixes, or maintenance, create a short-lived branch from `main`:
   ```bash
   git checkout main
   git pull
   git checkout -b feature/your-feature-name
   ```
   *(Use standard branch prefixes: `feature/` for new functionality, `fix/` for bug fixes, or `chore/` for maintenance and tooling such as updating `Makefile`, documentation, CI workflows, or formatting rules).*
3. **Format & Test before commit**: Run `make check` before pushing. If it reports formatting issues, run `make format` and then repeat `make check`.
4. **Sync with `main` before merging**: Before merging your PR, merge the latest `main` into your feature branch to prevent regressions and catch logical conflicts:
   ```bash
   git fetch origin
   git merge main
   make build  # Verify compilation after sync
   ```
5. **Open a Pull Request**: Push your branch to GitHub (`git push -u origin feature/your-feature-name`) and open a PR to merge into `main`.
6. **Automated CI & Peer Approval**:
   - Every PR triggers **GitHub Actions** to automatically verify code formatting, compilation (GCC & Clang), and static code analysis (`cppcheck`).
   - The PR **must be reviewed and approved by the other team member** before merging.

---

## 📁 Project Structure

```text
CrazyConquest/
├── .github/workflows/       # GitHub Actions CI workflows
│   └── ci.yml               # Automated build & code quality checks
├── bin/                      # Compiled binary executables
├── docs/                     # Documentation and project requirements
│   ├── ProjectRequirements.pdf # Assignment specification document
│   └── relazione.md          # Project report outline
├── scripts/                  # Helper scripts
│   └── run_local.sh          # Terminal launcher for Server and Clients
├── src/                      # Modular C source code
│   ├── client/               # Client implementation & headers
│   ├── server/               # Server implementation & headers
│   └── common/               # Shared protocols, types, and utility modules
├── .clang-format             # C code formatting rules
├── .gitignore                # Git ignore rules
├── Makefile                  # Main build script
└── README.md                 # Project documentation
```

---

## 👥 Authors

The project was developed by:

- [**Mario Penna**](https://github.com/bickpenna) (Matricola: `N86003308`)
- [**Emmanuele Laurini**](https://github.com/laurokh) (Matricola: `N86004040`)
