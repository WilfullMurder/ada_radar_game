# Radar Game - Ada Project

This workspace contains an Ada project for developing a radar game application with OpenGL graphics, managed with Alire.

## Project Information

- **Language**: Ada
- **Graphics**: OpenGL via OpenGLAda
- **Windowing**: GLFW
- **Build System**: Alire / GNAT Project Manager (GPR)
- **Main File**: `src/radar_game.adb`

## Prerequisites

To compile and run this project, you need:
- Alire (Ada package manager) - includes GNAT compiler and GPRbuild
- OpenGL-capable graphics hardware

Install from: https://alire.ada.dev/

## Dependencies

The project uses:
- **openglada** - Modern OpenGL Ada bindings
- **openglada_glfw** - GLFW window management
- System packages are auto-installed by Alire

## Development Guidelines

- Source files go in the `src/` directory
- Use Ada 2012 standard
- Follow Ada naming conventions (package names in lowercase)
- Build artifacts are generated in `obj/` and `bin/` directories
- Manage dependencies via `alire.toml`

## Building and Running

Build the project:
```bash
alr build
```

Run the executable:
```bash
alr run
```

Or directly:
```bash
./bin/radar_game        # Linux/macOS
.\bin\radar_game.exe    # Windows
```
