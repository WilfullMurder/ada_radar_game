# Radar Game

An Ada programming project with OpenGL graphics, managed with Alire.

## Features

- OpenGL rendering via OpenGLAda
- Window management with GLFW
- Tile-based map system with procedural generation
- Texture loading and rendering (PNG support)
- Seascape with beaches, cliffs, and landmasses
- Ready for game entity and radar system implementation

## Prerequisites

- [Alire](https://alire.ada.dev/) - Ada package manager (includes GNAT and GPRbuild)
- System dependencies are automatically installed by Alire

## Dependencies

- **openglada** (~0.9.0) - Thick Ada binding for OpenGL
- **openglada_glfw** (~0.9.0) - GLFW window management for OpenGLAda
- **openglada_images** (~0.9.0) - Image loading library (PNG, BMP, etc.)
- **gid** (9.0.0) - Generic Image Decoder
- **libglfw3** (3.4.0) - GLFW library (system package)

## Project Structure

```
radar_game/
├── src/           # Source files (.adb, .ads)
├── obj/           # Object files (generated)
├── bin/           # Executable output
├── alire.toml     # Alire manifest
├── radar_game.gpr # GNAT project file
└── README.md      # This file
```

## Building the Project

To build the project, run:

```bash
alr build
```

## Running the Project

To run the executable:

```bash
alr run
```

Or run the executable directly:

```powershell
.\bin\radar_game.exe    # Windows
./bin/radar_game        # Linux/macOS
```

## Development

- Main program: `src/radar_game.adb` - OpenGL window application
- Project configuration: `radar_game.gpr` - includes OpenGL dependencies
- Dependencies: `alire.toml` - manages OpenGLAda and GLFW

### Key Components

The application uses:
- `Glfw.Windows` - Window creation and management
- `Glfw.Input` - Keyboard and mouse input handling
- `GL.Buffers` - OpenGL buffer operations
- `GL.Immediate` - Legacy OpenGL immediate mode rendering
- `GL.Images` - Texture and image loading
- `Tile_Map` - Custom tile-based map renderer

### Tile Map System

The `Tile_Map` package provides:
- Procedural island/seascape generation
- 32x24 tile grid
- 5 tile types: Water, Grass, Sand, Mountain, Tree
- Texture atlas support (16x16 pixel tiles)
- Configurable tile size for screen rendering

### Adding More Graphics Features

To extend the graphics capabilities:
- Use `GL.Objects.Shaders` for custom shaders
- Use `GL.Objects.Buffers` for vertex data
- Use `GL.Objects.Textures` for texture mapping
- Check OpenGLAda documentation for full API

## Resources

- [Ada Programming Language](https://www.adaic.org/)
- [GNAT Community Edition](https://www.adacore.com/community)
- [Learn Ada](https://learn.adacore.com/)
