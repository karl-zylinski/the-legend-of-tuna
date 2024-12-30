#+build freestanding
package raylib

import "core:c"

@(default_calling_convention="c")
foreign {
	//------------------------------------------------------------------------------------
	// Global Variables Definition
	//------------------------------------------------------------------------------------
	// It's lonely here...

	//------------------------------------------------------------------------------------
	// Window and Graphics Device Functions (Module: core)
	//------------------------------------------------------------------------------------

	// Window-related functions

	InitWindow               :: proc(width, height: c.int, title: cstring) ---  // Initialize window and OpenGL context
	WindowShouldClose        :: proc() -> bool  ---                             // Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
	CloseWindow              :: proc() ---                                      // Close window and unload OpenGL context
	IsWindowReady            :: proc() -> bool  ---                             // Check if window has been initialized successfully
	IsWindowFullscreen       :: proc() -> bool  ---                             // Check if window is currently fullscreen
	IsWindowHidden           :: proc() -> bool  ---                             // Check if window is currently hidden
	IsWindowMinimized        :: proc() -> bool  ---                             // Check if window is currently minimized
	IsWindowMaximized        :: proc() -> bool  ---                             // Check if window is currently maximized
	IsWindowFocused          :: proc() -> bool  ---                             // Check if window is currently focused
	IsWindowResized          :: proc() -> bool  ---                             // Check if window has been resized last frame
	IsWindowState            :: proc(flags: ConfigFlags) -> bool  ---           // Check if one specific window flag is enabled
	SetWindowState           :: proc(flags: ConfigFlags) ---                    // Set window configuration state using flags
	ClearWindowState         :: proc(flags: ConfigFlags) ---                    // Clear window configuration state flags
	ToggleFullscreen         :: proc() ---                                      // Toggle window state: fullscreen/windowed
	ToggleBorderlessWindowed :: proc() ---                                      // Toggle window state: borderless windowed
	MaximizeWindow           :: proc() ---                                      // Set window state: maximized, if resizable
	MinimizeWindow           :: proc() ---                                      // Set window state: minimized, if resizable
	RestoreWindow            :: proc() ---                                      // Set window state: not minimized/maximized
	SetWindowIcon            :: proc(image: Image) ---                          // Set icon for window (single image, RGBA 32bit,)
	SetWindowIcons           :: proc(images: [^]Image, count: c.int) ---        // Set icon for window (multiple images, RGBA 32bit,)
	SetWindowTitle           :: proc(title: cstring) ---                        // Set title for window
	SetWindowPosition        :: proc(x, y: c.int) ---                           // Set window position on screen
	SetWindowMonitor         :: proc(monitor: c.int) ---                        // Set monitor for the current window
	SetWindowMinSize         :: proc(width, height: c.int) ---                  // Set window minimum dimensions (for WINDOW_RESIZABLE)
	SetWindowMaxSize         :: proc(width, height: c.int) ---                  // Set window maximum dimensions (for WINDOW_RESIZABLE)
	SetWindowSize            :: proc(width, height: c.int) ---                  // Set window dimensions
	SetWindowOpacity         :: proc(opacity: f32) ---                          // Set window opacity [0.0f..1.0f]
	SetWindowFocused         :: proc() ---                                      // Set window focused
	GetWindowHandle          :: proc() -> rawptr ---                            // Get native window handle
	GetScreenWidth           :: proc() -> c.int ---                             // Get current screen width
	GetScreenHeight          :: proc() -> c.int ---                             // Get current screen height
	GetRenderWidth           :: proc() -> c.int ---                             // Get current render width (it considers HiDPI)
	GetRenderHeight          :: proc() -> c.int ---                             // Get current render height (it considers HiDPI)
	GetMonitorCount          :: proc() -> c.int ---                             // Get number of connected monitors
	GetCurrentMonitor        :: proc() -> c.int ---                             // Get current monitor where window is placed
	GetMonitorPosition       :: proc(monitor: c.int) -> Vector2 ---             // Get specified monitor position
	GetMonitorWidth          :: proc(monitor: c.int) -> c.int ---               // Get specified monitor width (current video mode used by monitor)
	GetMonitorHeight         :: proc(monitor: c.int) -> c.int ---               // Get specified monitor height (current video mode used by monitor)
	GetMonitorPhysicalWidth  :: proc(monitor: c.int) -> c.int ---               // Get specified monitor physical width in millimetres
	GetMonitorPhysicalHeight :: proc(monitor: c.int) -> c.int ---               // Get specified monitor physical height in millimetres
	GetMonitorRefreshRate    :: proc(monitor: c.int) -> c.int ---               // Get specified monitor refresh rate
	GetWindowPosition        :: proc() -> Vector2 ---                           // Get window position XY on monitor
	GetWindowScaleDPI        :: proc() -> Vector2 ---                           // Get window scale DPI factor
	GetMonitorName           :: proc(monitor: c.int) -> cstring ---             // Get the human-readable, UTF-8 encoded name of the specified monitor
	SetClipboardText         :: proc(text: cstring) ---                         // Set clipboard text content
	GetClipboardText         :: proc() -> cstring ---                           // Get clipboard text content
	GetClipboardImage        :: proc() -> Image ---                             // Get clipboard image content
	EnableEventWaiting       :: proc() ---                                      // Enable waiting for events on EndDrawing(), no automatic event polling
	DisableEventWaiting      :: proc() ---                                      // Disable waiting for events on EndDrawing(), automatic events polling


	// Custom frame control functions
	// NOTE: Those functions are intended for advance users that want full control over the frame processing
	// By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
	// To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL

	SwapScreenBuffer :: proc() ---             // Swap back buffer with front buffer (screen drawing)
	PollInputEvents  :: proc() ---             // Register all input events
	WaitTime         :: proc(seconds: f64) --- // Wait for some time (halt program execution)


	// Cursor-related functions

	ShowCursor       :: proc() ---                                              // Shows cursor
	HideCursor       :: proc() ---                                              // Hides cursor
	IsCursorHidden   :: proc() -> bool ---                                      // Check if cursor is not visible
	EnableCursor     :: proc() ---                                              // Enables cursor (unlock cursor)
	DisableCursor    :: proc() ---                                              // Disables cursor (lock cursor)
	IsCursorOnScreen :: proc() -> bool ---                                      // Check if cursor is on the current screen.

	// Drawing-related functions

	ClearBackground   :: proc(color: Color) ---               // Set background color (framebuffer clear color)
	BeginDrawing      :: proc() ---                           // Setup canvas (framebuffer) to start drawing
	EndDrawing        :: proc() ---                           // End canvas drawing and swap buffers (double buffering)
	BeginMode2D       :: proc(camera: Camera2D) ---           // Initialize 2D mode with custom camera (2D)
	EndMode2D         :: proc() ---                           // Ends 2D mode with custom camera
	BeginMode3D       :: proc(camera: Camera3D) ---           // Initializes 3D mode with custom camera (3D)
	EndMode3D         :: proc() ---                           // Ends 3D mode and returns to default 2D orthographic mode
	BeginTextureMode  :: proc(target: RenderTexture2D) ---    // Initializes render texture for drawing
	EndTextureMode    :: proc() ---                           // Ends drawing to render texture
	BeginShaderMode   :: proc(shader: Shader) ---             // Begin custom shader drawing
	EndShaderMode     :: proc() ---                           // End custom shader drawing (use default shader)
	BeginBlendMode    :: proc(mode: BlendMode) ---            // Begin blending mode (alpha, additive, multiplied)
	EndBlendMode      :: proc() ---                           // End blending mode (reset to default: alpha blending)
	BeginScissorMode  :: proc(x, y, width, height: c.int) --- // Begin scissor mode (define screen area for following drawing)
	EndScissorMode    :: proc() ---                           // End scissor mode
	BeginVrStereoMode :: proc(config: VrStereoConfig) ---     // Begin stereo rendering (requires VR simulator)
	EndVrStereoMode   :: proc() ---                           // End stereo rendering (requires VR simulator)

	// VR stereo config functions for VR simulator

	LoadVrStereoConfig   :: proc(device: VrDeviceInfo) -> VrStereoConfig --- // Load VR stereo config for VR simulator device parameters
	UnloadVrStereoConfig :: proc(config: VrStereoConfig) ---                 // Unload VR stereo config

	// Shader management functions
	// NOTE: Shader functionality is not available on OpenGL 1.1

	LoadShader              :: proc(vsFileName, fsFileName: cstring) -> Shader ---                                                        // Load shader from files and bind default locations
	LoadShaderFromMemory    :: proc(vsCode, fsCode: cstring) -> Shader ---                                                                // Load shader from code strings and bind default locations
	IsShaderValid           :: proc(shader: Shader) -> bool ---                                                                           // Check if a shader is valid (loaded on GPU)
	GetShaderLocation       :: proc(shader: Shader, uniformName: cstring) -> c.int ---                                                    // Get shader uniform location
	GetShaderLocationAttrib :: proc(shader: Shader, attribName: cstring)  -> c.int ---                                                    // Get shader attribute location

	// We use #any_int here so we can pass ShaderLocationIndex
	SetShaderValue          :: proc(shader: Shader, #any_int locIndex: c.int, value: rawptr, uniformType: ShaderUniformDataType) ---               // Set shader uniform value
	SetShaderValueV         :: proc(shader: Shader, #any_int locIndex: c.int, value: rawptr, uniformType: ShaderUniformDataType, count: c.int) --- // Set shader uniform value vector
	SetShaderValueMatrix    :: proc(shader: Shader, #any_int locIndex: c.int, mat: Matrix) ---                                                     // Set shader uniform value (matrix 4x4)
	SetShaderValueTexture   :: proc(shader: Shader, #any_int locIndex: c.int, texture: Texture2D) ---                                              // Set shader uniform value for texture (sampler2d)
	UnloadShader            :: proc(shader: Shader) ---                                                                                   // Unload shader from GPU memory (VRAM)

	// Screen-space-related functions

	GetScreenToWorldRay   :: proc(position: Vector2, camera: Camera) -> Ray ---                                  // Get a ray trace from screen position (i.e mouse)
	GetScreenToWorldRayEx :: proc(position: Vector2, camera: Camera, width: c.int, height: c.int) ->Ray ---      // Get a ray trace from screen position (i.e mouse) in a viewport
	GetWorldToScreen      :: proc(position: Vector3, camera: Camera) -> Vector2 ---                              // Get the screen space position for a 3d world space position
	GetWorldToScreenEx    :: proc(position: Vector3, camera: Camera, width: c.int, height: c.int) -> Vector2 --- // Get size position for a 3d world space position
	GetWorldToScreen2D    :: proc(position: Vector2, camera: Camera2D) -> Vector2 ---                            // Get the screen space position for a 2d camera world space position
	GetScreenToWorld2D    :: proc(position: Vector2, camera: Camera2D) -> Vector2 ---                            // Get the world space position for a 2d camera screen space position
	GetCameraMatrix       :: proc(camera: Camera) -> Matrix ---                                                  // Get camera transform matrix (view matrix)
	GetCameraMatrix2D     :: proc(camera: Camera2D) -> Matrix ---                                                // Get camera 2d transform matrix
	
	// Timing-related functions

	SetTargetFPS :: proc(fps: c.int) --- // Set target FPS (maximum)
	GetFPS       :: proc() -> c.int ---  // Returns current FPS
	GetFrameTime :: proc() -> f32 ---    // Returns time in seconds for last frame drawn (delta time)
	GetTime      :: proc() -> f64 ---    // Returns elapsed time in seconds since InitWindow()

	// Random value generation functions

	SetRandomSeed        :: proc(seed: c.uint) ---                               // Set the seed for the random number generator
	GetRandomValue       :: proc(min, max: c.int) -> c.int ---                   // Get a random value between min and max (both included)
	LoadRandomSequence   :: proc(count: c.uint, min, max: c.int) -> [^]c.int --- // Load random values sequence, no values repeated
	UnloadRandomSequence :: proc(sequence: [^]c.int) ---                         // Unload random values sequence

	// Misc. functions
	TakeScreenshot :: proc(fileName: cstring) ---        // Takes a screenshot of current screen (filename extension defines format)
	SetConfigFlags :: proc(flags: ConfigFlags) ---       // Setup init configuration flags (view FLAGS). NOTE: This function is expected to be called before window creation
	OpenURL        :: proc(url: cstring) ---             // Open URL with default system browser (if available)

	// NOTE: Following functions implemented in module [utils]
	//------------------------------------------------------------------
	TraceLog         :: proc(logLevel: TraceLogLevel, text: cstring, #c_vararg args: ..any) --- // Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR)
	SetTraceLogLevel :: proc(logLevel: TraceLogLevel) ---                                       // Set the current threshold (minimum) log level
	MemAlloc         :: proc(size: c.uint) -> rawptr ---                                        // Internal memory allocator
	MemRealloc       :: proc(ptr: rawptr, size: c.uint) -> rawptr ---                           // Internal memory reallocator

	// Set custom callbacks
	// WARNING: Callbacks setup is intended for advanced users

	SetTraceLogCallback     :: proc(callback: TraceLogCallback) ---     // Set custom trace log
	SetLoadFileDataCallback :: proc(callback: LoadFileDataCallback) --- // Set custom file binary data loader
	SetSaveFileDataCallback :: proc(callback: SaveFileDataCallback) --- // Set custom file binary data saver
	SetLoadFileTextCallback :: proc(callback: LoadFileTextCallback) --- // Set custom file text data loader
	SetSaveFileTextCallback :: proc(callback: SaveFileTextCallback) --- // Set custom file text data saver

	// Files management functions

	LoadFileData            :: proc(fileName: cstring, dataSize: ^c.int) -> [^]byte ---                   // Load file data as byte array (read)
	UnloadFileData          :: proc(data: [^]byte) ---                                                    // Unload file data allocated by LoadFileData()
	SaveFileData            :: proc(fileName: cstring, data: rawptr, dataSize: c.int) -> bool ---         // Save data to file from byte array (write), returns true on success
	ExportDataAsCode        :: proc(data: rawptr, dataSize: c.int, fileName: cstring) -> bool ---         // Export data to code (.h), returns true on success
	LoadFileText            :: proc(fileName: cstring) -> [^]byte ---                                     // Load text data from file (read), returns a '\0' terminated string
	UnloadFileText          :: proc(text: [^]byte) ---                                                    // Unload file text data allocated by LoadFileText()
	SaveFileText            :: proc(fileName: cstring, text: [^]byte) -> bool ---                         // Save text data to file (write), string must be '\0' terminated, returns true on success

	// File system functions

	FileExists              :: proc(fileName: cstring) -> bool ---                                             // Check if file exists
	DirectoryExists         :: proc(dirPath: cstring) -> bool ---                                              // Check if a directory path exists
	IsFileExtension         :: proc(fileName, ext: cstring) -> bool ---                                        // Check file extension (including point: .png, .wav)
	GetFileLength           :: proc(fileName: cstring) -> c.int ---                                            // Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
	GetFileExtension        :: proc(fileName: cstring) -> cstring ---                                          // Get pointer to extension for a filename string (includes dot: '.png')
	GetFileName             :: proc(filePath: cstring) -> cstring ---                                          // Get pointer to filename for a path string
	GetFileNameWithoutExt   :: proc(filePath: cstring) -> cstring ---                                          // Get filename string without extension (uses static string)
	GetDirectoryPath        :: proc(filePath: cstring) -> cstring ---                                          // Get full path for a given fileName with path (uses static string)
	GetPrevDirectoryPath    :: proc(dirPath: cstring) -> cstring ---                                           // Get previous directory path for a given path (uses static string)
	GetWorkingDirectory     :: proc() -> cstring ---                                                           // Get current working directory (uses static string)
	GetApplicationDirectory :: proc() -> cstring ---                                                           // Get the directory of the running application (uses static string)
	MakeDirectory           :: proc(dirPath: cstring) -> c.int ---                                             // Create directories (including full path requested), returns 0 on success
	ChangeDirectory         :: proc(dir: cstring) -> bool ---                                                  // Change working directory, return true on success
	IsPathFile              :: proc(path: cstring) -> bool ---                                                 // Check if a given path is a file or a directory
	IsFileNameValid         :: proc (fileName: cstring) -> bool ---                                            // Check if fileName is valid for the platform/OS
	LoadDirectoryFiles      :: proc(dirPath: cstring) -> FilePathList ---                                      // Load directory filepaths
	LoadDirectoryFilesEx    :: proc(basePath: cstring, filter: cstring, scanSubdirs: bool) -> FilePathList --- // Load directory filepaths with extension filtering and recursive directory scan. Use 'DIR' in the filter string to include directories in the result
	UnloadDirectoryFiles    :: proc(files: FilePathList) ---                                                   // Unload filepaths
	IsFileDropped           :: proc() -> bool ---                                                              // Check if a file has been dropped into window
	LoadDroppedFiles        :: proc() -> FilePathList ---                                                      // Load dropped filepaths
	UnloadDroppedFiles      :: proc(files: FilePathList) ---                                                   // Unload dropped filepaths
	GetFileModTime          :: proc(fileName: cstring) -> c.long ---                                           // Get file modification time (last write time)

	// Compression/Encoding functionality

	CompressData     :: proc(data: rawptr,     dataSize: c.int,     compDataSize: ^c.int) -> [^]byte ---       // Compress data (DEFLATE algorithm), memory must be MemFree()
	DecompressData   :: proc(compData: rawptr, compDataSize: c.int, dataSize:     ^c.int) -> [^]byte ---       // Decompress data (DEFLATE algorithm), memory must be MemFree()
	EncodeDataBase64 :: proc(data: rawptr,     dataSize: c.int,     outputSize:   ^c.int) -> [^]byte ---       // Encode data to Base64 string, memory must be MemFree()
	DecodeDataBase64 :: proc(data: rawptr,     outputSize: ^c.int) -> [^]byte ---                              // Decode Base64 string data, memory must be MemFree()
	ComputeCRC32     :: proc(data: rawptr,     dataSize: c.int) -> c.uint ---                                  // Compute CRC32 hash code
	ComputeMD5       :: proc (data: rawptr,    dataSize: c.int) -> [^]c.uint ---                               // Compute MD5 hash code, returns static int[4] (16 bytes)
	ComputeSHA1      :: proc(data: rawptr,     dataSize: c.int) -> [^]c.uint ---                               // Compute SHA1 hash code, returns static int[5] (20 bytes)

	
	// Automation events functionality

	LoadAutomationEventList       :: proc(fileName: cstring) -> AutomationEventList ---             // Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS
	UnloadAutomationEventList     :: proc(list: AutomationEventList) ---                        	// Unload automation events list from file
	ExportAutomationEventList     :: proc(list: AutomationEventList, fileName: cstring) -> bool --- // Export automation events list as text file
	SetAutomationEventList        :: proc(list: ^AutomationEventList) ---                        	// Set automation event list to record to
	SetAutomationEventBaseFrame   :: proc(frame: c.int) ---                                         // Set automation event internal base frame to start recording
	StartAutomationEventRecording :: proc() ---                                                     // Start recording automation events (AutomationEventList must be set)
	StopAutomationEventRecording  :: proc() ---                                                     // Stop recording automation events
	PlayAutomationEvent           :: proc(event: AutomationEvent) ---                               // Play a recorded automation event

	//------------------------------------------------------------------------------------
	// Input Handling Functions (Module: core)
	//------------------------------------------------------------------------------------

	// Input-related functions: keyboard

	IsKeyPressed   	   :: proc(key: KeyboardKey) -> bool --- // Detect if a key has been pressed once
	IsKeyPressedRepeat :: proc(key: KeyboardKey) -> bool --- // Check if a key has been pressed again
	IsKeyDown      	   :: proc(key: KeyboardKey) -> bool --- // Detect if a key is being pressed
	IsKeyReleased  	   :: proc(key: KeyboardKey) -> bool --- // Detect if a key has been released once
	IsKeyUp        	   :: proc(key: KeyboardKey) -> bool --- // Detect if a key is NOT being pressed
	GetKeyPressed  	   :: proc() -> KeyboardKey ---          // Get key pressed (keycode), call it multiple times for keys queued
	GetCharPressed 	   :: proc() -> rune ---                 // Get char pressed (unicode), call it multiple times for chars queued
	SetExitKey     	   :: proc(key: KeyboardKey) ---         // Set a custom key to exit program (default is ESC)

	// Input-related functions: gamepads

	IsGamepadAvailable       :: proc(gamepad: c.int) -> bool ---                                         // Check if a gamepad is available
	GetGamepadName           :: proc(gamepad: c.int) -> cstring ---                                      // Get gamepad internal name id
	IsGamepadButtonPressed   :: proc(gamepad: c.int, button: GamepadButton) -> bool ---                  // Check if a gamepad button has been pressed once
	IsGamepadButtonDown      :: proc(gamepad: c.int, button: GamepadButton) -> bool ---                  // Check if a gamepad button is being pressed
	IsGamepadButtonReleased  :: proc(gamepad: c.int, button: GamepadButton) -> bool ---                  // Check if a gamepad button has been released once
	IsGamepadButtonUp        :: proc(gamepad: c.int, button: GamepadButton) -> bool ---                  // Check if a gamepad button is NOT being pressed
	GetGamepadButtonPressed  :: proc() -> GamepadButton ---                                              // Get the last gamepad button pressed
	GetGamepadAxisCount      :: proc(gamepad: c.int) -> c.int ---                                        // Get gamepad axis count for a gamepad
	GetGamepadAxisMovement   :: proc(gamepad: c.int, axis: GamepadAxis) -> f32 ---                       // Get axis movement value for a gamepad axis
	SetGamepadMappings       :: proc(mappings: cstring) -> c.int ---                                     // Set internal gamepad mappings (SDL_GameControllerDB)
	SetGamepadVibration      :: proc(gamepad: c.int, leftMotor: f32, rightMotor: f32, duration: f32) --- // Set gamepad vibration for both motors (duration in seconds)

	
	// Input-related functions: mouse

	IsMouseButtonPressed  :: proc(button: MouseButton) -> bool ---    // Detect if a mouse button has been pressed once
	IsMouseButtonDown     :: proc(button: MouseButton) -> bool ---    // Detect if a mouse button is being pressed
	IsMouseButtonReleased :: proc(button: MouseButton) -> bool ---    // Detect if a mouse button has been released once
	IsMouseButtonUp       :: proc(button: MouseButton) -> bool ---
	
	GetMouseX             :: proc() -> c.int ---                      // Returns mouse position X
	GetMouseY             :: proc() -> c.int ---                      // Returns mouse position Y
	GetMousePosition      :: proc() -> Vector2 ---                    // Returns mouse position XY
	GetMouseDelta         :: proc() -> Vector2 ---                    // Returns mouse delta XY
	SetMousePosition      :: proc(x, y: c.int) ---                    // Set mouse position XY
	SetMouseOffset        :: proc(offsetX, offsetY: c.int) ---        // Set mouse offset
	SetMouseScale         :: proc(scaleX, scaleY: f32) ---            // Set mouse scaling
	GetMouseWheelMove     :: proc() -> f32 ---                        // Returns mouse wheel movement Y
	GetMouseWheelMoveV    :: proc() -> Vector2 ---                    // Get mouse wheel movement for both X and Y
	SetMouseCursor        :: proc(cursor: MouseCursor) ---            // Set mouse cursor

	// Input-related functions: touch

	GetTouchX          :: proc() -> c.int ---               // Returns touch position X for touch point 0 (relative to screen size)
	GetTouchY          :: proc() -> c.int ---               // Returns touch position Y for touch point 0 (relative to screen size)
	GetTouchPosition   :: proc(index: c.int) -> Vector2 --- // Returns touch position XY for a touch point index (relative to screen size)
	GetTouchPointId    :: proc(index: c.int) -> c.int ---   // Get touch point identifier for given index
	GetTouchPointCount :: proc() -> c.int ---               // Get number of touch points

	//------------------------------------------------------------------------------------
	// Gestures and Touch Handling Functions (Module: rgestures)
	//------------------------------------------------------------------------------------

	SetGesturesEnabled     :: proc(flags: Gestures) ---          // Enable a set of gestures using flags

	GetGestureDetected     :: proc() -> Gestures ---             // Get latest detected gesture
	GetGestureHoldDuration :: proc() -> f32 ---                  // Get gesture hold time in seconds
	GetGestureDragVector   :: proc() -> Vector2 ---              // Get gesture drag vector
	GetGestureDragAngle    :: proc() -> f32 ---                  // Get gesture drag angle
	GetGesturePinchVector  :: proc() -> Vector2 ---              // Get gesture pinch delta
	GetGesturePinchAngle   :: proc() -> f32 ---                  // Get gesture pinch angle

	//------------------------------------------------------------------------------------
	// Camera System Functions (Module: camera)
	//------------------------------------------------------------------------------------

	UpdateCamera :: proc(camera: ^Camera, mode: CameraMode) ---                                   // Set camera mode (multiple camera modes available)
	UpdateCameraPro :: proc(camera: ^Camera, movement: Vector3, rotation: Vector3, zoom: f32) --- // Update camera movement/rotation

	//------------------------------------------------------------------------------------
	// Basic Shapes Drawing Functions (Module: shapes)
	//------------------------------------------------------------------------------------
	// Set texture and rectangle to be used on shapes drawing
	// NOTE: It can be useful when using basic shapes and one single font,
	// defining a font char white rectangle would allow drawing everything in a single draw call

	SetShapesTexture :: proc(texture: Texture2D, source: Rectangle) ---     // Set texture and rectangle to be used on shapes drawing
	GetShapesTexture :: proc() -> Texture2D ---                             // Get texture that is used for shapes drawing
	GetShapesTextureRectangle :: proc() -> Rectangle ---                    // Get texture source rectangle that is used for shapes drawing

	
	// Basic shapes drawing functions

	DrawPixel                   :: proc(posX, posY: c.int, color: Color) ---                                                                          // Draw a pixel using geometry [Can be slow, use with care]
	DrawPixelV                  :: proc(position: Vector2, color: Color) ---                                                                          // Draw a pixel using geometry (Vector version) [Can be slow, use with care]
	DrawLine                    :: proc(startPosX, startPosY, endPosX, endPosY: c.int, color: Color) ---                                              // Draw a line
	DrawLineV                   :: proc(startPos, endPos: Vector2, color: Color) ---                                                                  // Draw a line (using gl lines)
	DrawLineEx                  :: proc(startPos, endPos: Vector2, thick: f32, color: Color) ---                                                      // Draw a line (using triangles/quads)
	DrawLineStrip               :: proc(points: [^]Vector2, pointCount: c.int, color: Color) ---                                                      // Draw lines sequence (using gl lines)
	DrawLineBezier              :: proc(startPos, endPos: Vector2, thick: f32, color: Color) ---                                                      // Draw line segment cubic-bezier in-out interpolation
	DrawCircle                  :: proc(centerX, centerY: c.int, radius: f32, color: Color) ---                                                       // Draw a color-filled circle
	DrawCircleSector            :: proc(center: Vector2, radius: f32, startAngle, endAngle: f32, segments: c.int, color: Color) ---                   // Draw a piece of a circle
	DrawCircleSectorLines       :: proc(center: Vector2, radius: f32, startAngle, endAngle: f32, segments: c.int, color: Color) ---                   // Draw circle sector outline
	DrawCircleGradient          :: proc(centerX, centerY: c.int, radius: f32, inner, outer: Color) ---                                                // Draw a gradient-filled circle
	DrawCircleV                 :: proc(center: Vector2, radius: f32, color: Color) ---                                                               // Draw a color-filled circle (Vector version)
	DrawCircleLines             :: proc(centerX, centerY: c.int, radius: f32, color: Color) ---                                                       // Draw circle outline
	DrawCircleLinesV            :: proc(center: Vector2, radius: f32, color: Color) ---                                                               // Draw circle outline (Vector version)
	DrawEllipse                 :: proc(centerX, centerY: c.int, radiusH, radiusV: f32, color: Color) ---                                             // Draw ellipse
	DrawEllipseLines            :: proc(centerX, centerY: c.int, radiusH, radiusV: f32, color: Color) ---                                             // Draw ellipse outline
	DrawRing                    :: proc(center: Vector2, innerRadius, outerRadius: f32, startAngle, endAngle: f32, segments: c.int, color: Color) --- // Draw ring
	DrawRingLines               :: proc(center: Vector2, innerRadius, outerRadius: f32, startAngle, endAngle: f32, segments: c.int, color: Color) --- // Draw ring outline
	DrawRectangle               :: proc(posX, posY: c.int, width, height: c.int, color: Color) ---                                                    // Draw a color-filled rectangle
	DrawRectangleV              :: proc(position: Vector2, size: Vector2, color: Color) ---                                                           // Draw a color-filled rectangle (Vector version)
	DrawRectangleRec            :: proc(rec: Rectangle, color: Color) ---                                                                             // Draw a color-filled rectangle
	DrawRectanglePro            :: proc(rec: Rectangle, origin: Vector2, rotation: f32, color: Color) ---                                             // Draw a color-filled rectangle with pro parameters
	DrawRectangleGradientV      :: proc(posX, posY: c.int, width, height: c.int, top, bottom: Color) ---                                              // Draw a vertical-gradient-filled rectangle
	DrawRectangleGradientH      :: proc(posX, posY: c.int, width, height: c.int, left, right: Color) ---                                              // Draw a horizontal-gradient-filled rectangle
	DrawRectangleGradientEx     :: proc(rec: Rectangle, topLeft, bottomLeft, topRight, bottomRight: Color) ---                                        // Draw a gradient-filled rectangle with custom vertex colors
	DrawRectangleLines          :: proc(posX, posY: c.int, width, height: c.int, color: Color) ---                                                    // Draw rectangle outline
	DrawRectangleLinesEx        :: proc(rec: Rectangle, lineThick: f32, color: Color) ---                                                             // Draw rectangle outline with extended parameters
	DrawRectangleRounded        :: proc(rec: Rectangle, roundness: f32, segments: c.int, color: Color) ---                                            // Draw rectangle with rounded edges
	DrawRectangleRoundedLines   :: proc(rec: Rectangle, roundness: f32, segments: c.int, lineThick: f32, color: Color) ---                            // Draw rectangle lines with rounded edges
	DrawRectangleRoundedLinesEx :: proc(rec: Rectangle, roundness: f32, segments: c.int, lineThick: f32, color: Color) ---                            // Draw rectangle with rounded edges outline
	DrawTriangle                :: proc(v1, v2, v3: Vector2, color: Color) ---                                                                        // Draw a color-filled triangle (vertex in counter-clockwise order!)
	DrawTriangleLines           :: proc(v1, v2, v3: Vector2, color: Color) ---                                                                        // Draw triangle outline (vertex in counter-clockwise order!)
	DrawTriangleFan             :: proc(points: [^]Vector2, pointCount: c.int, color: Color) ---                                                      // Draw a triangle fan defined by points (first vertex is the center)
	DrawTriangleStrip           :: proc(points: [^]Vector2, pointCount: c.int, color: Color) ---                                                      // Draw a triangle strip defined by points
	DrawPoly                    :: proc(center: Vector2, sides: c.int, radius: f32, rotation: f32, color: Color) ---                                  // Draw a regular polygon (Vector version)
	DrawPolyLines               :: proc(center: Vector2, sides: c.int, radius: f32, rotation: f32, color: Color) ---                                  // Draw a polygon outline of n sides
	DrawPolyLinesEx             :: proc(center: Vector2, sides: c.int, radius: f32, rotation: f32, lineThick: f32, color: Color) ---                  // Draw a polygon outline of n sides with extended parameters

	// Splines drawing functions
	DrawSplineLinear                 :: proc(points: [^]Vector2, pointCount: c.int, thick: f32, color: Color) --- // Draw spline: Linear, minimum 2 points
	DrawSplineBasis                  :: proc(points: [^]Vector2, pointCount: c.int, thick: f32, color: Color) --- // Draw spline: B-Spline, minimum 4 points
	DrawSplineCatmullRom             :: proc(points: [^]Vector2, pointCount: c.int, thick: f32, color: Color) --- // Draw spline: Catmull-Rom, minimum 4 points
	DrawSplineBezierQuadratic        :: proc(points: [^]Vector2, pointCount: c.int, thick: f32, color: Color) --- // Draw spline: Quadratic Bezier, minimum 3 points (1 control point): [p1, c2, p3, c4...]
	DrawSplineBezierCubic            :: proc(points: [^]Vector2, pointCount: c.int, thick: f32, color: Color) --- // Draw spline: Cubic Bezier, minimum 4 points (2 control points): [p1, c2, c3, p4, c5, c6...]
	DrawSplineSegmentLinear          :: proc(p1, p2: Vector2, thick: f32, color: Color) ---                       // Draw spline segment: Linear, 2 points
	DrawSplineSegmentBasis           :: proc(p1, p2, p3, p4: Vector2, thick: f32, color: Color) ---               // Draw spline segment: B-Spline, 4 points
	DrawSplineSegmentCatmullRom 	 :: proc(p1, p2, p3, p4: Vector2, thick: f32, color: Color) ---               // Draw spline segment: Catmull-Rom, 4 points
	DrawSplineSegmentBezierQuadratic :: proc(p1, c2, p3: Vector2, thick: f32, color: Color) ---                   // Draw spline segment: Quadratic Bezier, 2 points, 1 control point
	DrawSplineSegmentBezierCubic 	 :: proc(p1, c2, c3, p4: Vector2, thick: f32, color: Color) ---               // Draw spline segment: Cubic Bezier, 2 points, 2 control points

	// Spline segment point evaluation functions, for a given t [0.0f .. 1.0f]
	GetSplinePointLinear  	  :: proc(startPos, endPos: Vector2, t: f32) -> Vector2 ---    // Get (evaluate) spline point: Linear
	GetSplinePointBasis 	  :: proc(p1, p2, p3, p4: Vector2, t: f32) -> Vector2 ---      // Get (evaluate) spline point: B-Spline
	GetSplinePointCatmullRom  :: proc(p1, p2, p3, p4: Vector2, t: f32) -> Vector2 ---      // Get (evaluate) spline point: Catmull-Rom
	GetSplinePointBezierQuad  :: proc(p1, c2, p3: Vector2, t: f32) -> Vector2 ---          // Get (evaluate) spline point: Quadratic Bezier
	GetSplinePointBezierCubic :: proc(p1, c2, c3, p4: Vector2, t: f32) -> Vector2 ---      // Get (evaluate) spline point: Cubic Bezier
                                                                                                                                                        // Basic shapes collision detection functions
	CheckCollisionRecs          :: proc(rec1, rec2: Rectangle) -> bool ---                                                                          // Check collision between two rectangles
	CheckCollisionCircles       :: proc(center1: Vector2, radius1: f32, center2: Vector2, radius2: f32) -> bool ---                                 // Check collision between two circles
	CheckCollisionCircleRec     :: proc(center: Vector2, radius: f32, rec: Rectangle) -> bool ---                                                   // Check collision between circle and rectangle
	CheckCollisionCircleLine    :: proc(center: Vector2, radius: f32, p1, p2: Vector2) -> bool ---                                                  // Check if circle collides with a line created betweeen two points [p1] and [p2]
	CheckCollisionPointRec      :: proc(point: Vector2, rec: Rectangle) -> bool ---                                                                 // Check if point is inside rectangle
	CheckCollisionPointCircle   :: proc(point, center: Vector2, radius: f32) -> bool ---                                                            // Check if point is inside circle
	CheckCollisionPointTriangle :: proc(point: Vector2, p1, p2, p3: Vector2) -> bool ---                                                            // Check if point is inside a triangle
	CheckCollisionPointLine     :: proc(point: Vector2, p1, p2: Vector2, threshold: c.int) -> bool ---                                              // Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
	CheckCollisionPointPoly     :: proc(point: Vector2, points: [^]Vector2, pointCount: c.int) -> bool ---                                          // Check if point is within a polygon described by array of vertices
	CheckCollisionLines         :: proc(startPos1, endPos1, startPos2, endPos2: Vector2, collisionPoint: [^]Vector2) -> bool ---                    // Check the collision between two lines defined by two points each, returns collision point by reference
	GetCollisionRec             :: proc(rec1, rec2: Rectangle) -> Rectangle ---                                                                     // Get collision rectangle for two rectangles collision



	// Image loading functions
	// NOTE: These functions do not require GPU access

	LoadImage               :: proc(fileName: cstring) -> Image ---                                                               // Load image from file into CPU memory (RAM)
	LoadImageRaw            :: proc(fileName: cstring, width, height: c.int, format: PixelFormat, headerSize: c.int) -> Image --- // Load image from RAW file data
	LoadImageAnim           :: proc(fileName: cstring, frames: ^c.int) -> Image ---                                               // Load image sequence from file (frames appended to image.data)
	LoadImageAnimFromMemory :: proc(fileType: cstring, fileData: rawptr, dataSize: c.int, frames: ^c.int) -> Image ---            // Load image sequence from memory buffer
	LoadImageFromMemory     :: proc(fileType: cstring, fileData: rawptr, dataSize: c.int) -> Image ---                            // Load image from memory buffer, fileType refers to extension: i.e. '.png'
	LoadImageFromTexture    :: proc(texture: Texture2D) -> Image ---                                                              // Load image from GPU texture data
	LoadImageFromScreen     :: proc() -> Image ---                                                                                // Load image from screen buffer and (screenshot)
	IsImageValid            :: proc(image: Image) -> bool ---                                                                     // Check if an image is ready
	UnloadImage             :: proc(image: Image) ---                                                                             // Unload image from CPU memory (RAM)
	ExportImage             :: proc(image: Image, fileName: cstring) -> bool ---                                                  // Export image data to file, returns true on success
	ExportImageToMemory     :: proc(image: Image, fileType: cstring, fileSize: ^c.int) -> rawptr ---                              // Export image to memory buffer
	ExportImageAsCode       :: proc(image: Image, fileName: cstring) -> bool ---                                                  // Export image as code file defining an array of bytes, returns true on success

	// Image generation functions

	GenImageColor          :: proc(width, height: c.int, color: Color) -> Image  ---                                           // Generate image: plain color
	GenImageGradientLinear :: proc(width, height, direction: c.int, start, end: Color) -> Image ---                            // Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
	GenImageGradientRadial :: proc(width, height: c.int, density: f32, inner, outer: Color) -> Image  ---                      // Generate image: radial gradient
	GenImageGradientSquare :: proc(width, height: c.int, density: f32, inner, outer: Color) -> Image  ---                      // Generate image: square gradient
	GenImageChecked        :: proc(width, height: c.int, checksX, checksY: c.int, col1, col2: Color) -> Image  ---             // Generate image: checked
	GenImageWhiteNoise     :: proc(width, height: c.int, factor: f32) -> Image  ---                                            // Generate image: white noise
	GenImagePerlinNoise    :: proc(width, height: c.int, offsetX, offsetY: c.int, scale: f32) -> Image  ---                    // Generate image: perlin noise
	GenImageCellular       :: proc(width, height: c.int, tileSize: c.int) -> Image  ---                                        // Generate image: cellular algorithm, bigger tileSize means bigger cells
	GenImageText           :: proc(width, height: c.int, text: cstring) -> Image  ---                                          // Generate image: grayscale image from text data

	// Image manipulation functions

	ImageCopy              :: proc(image: Image) -> Image ---                                                                   // Create an image duplicate (useful for transformations)
	ImageFromImage         :: proc(image: Image, rec: Rectangle) -> Image ---                                                   // Create an image from another image piece
	ImageFromChannel       :: proc(image: Image, selectedChannel: c.int) -> Image ---                                           // Create an image from a selected channel of another image (GRAYSCALE)
	ImageText              :: proc(text: cstring, fontSize: c.int, color: Color) -> Image ---                                   // Create an image from text (default font)
	ImageTextEx            :: proc(font: Font, text: cstring, fontSize: f32, spacing: f32, tint: Color) -> Image ---            // Create an image from text (custom sprite font)
	ImageFormat            :: proc(image: ^Image, newFormat: PixelFormat) ---                                                   // Convert image data to desired format
	ImageToPOT             :: proc(image: ^Image, fill: Color) ---                                                              // Convert image to POT (power-of-two)
	ImageCrop              :: proc(image: ^Image, crop: Rectangle) ---                                                          // Crop an image to a defined rectangle
	ImageAlphaCrop         :: proc(image: ^Image, threshold: f32) ---                                                           // Crop image depending on alpha value
	ImageAlphaClear        :: proc(image: ^Image, color: Color, threshold: f32) ---                                             // Clear alpha channel to desired color
	ImageAlphaMask         :: proc(image: ^Image, alphaMask: Image) ---                                                         // Apply alpha mask to image
	ImageAlphaPremultiply  :: proc(image: ^Image) ---                                                                           // Premultiply alpha channel
	ImageBlurGaussian      :: proc(image: ^Image, blurSize: c.int) ---                                                          // Apply Gaussian blur using a box blur approximation
	ImageKernelConvolution :: proc(image: ^Image, kernel: [^]f32, kernelSize: c.int) ---                                        // Apply custom square convolution kernel to image
	ImageResize           :: proc(image: ^Image, newWidth,  newHeight: c.int) ---                                               // Resize image (Bicubic scaling algorithm)
	ImageResizeNN         :: proc(image: ^Image, newWidth,  newHeight: c.int) ---                                               // Resize image (Nearest-Neighbor scaling algorithm)
	ImageResizeCanvas     :: proc(image: ^Image, newWidth,  newHeight: c.int, offsetX, offsetY: c.int, fill: Color) ---         // Resize canvas and fill with color
	ImageMipmaps          :: proc(image: ^Image) ---                                                                            // Compute all mipmap levels for a provided image
	ImageDither           :: proc(image: ^Image, rBpp, gBpp, bBpp, aBpp: c.int) ---                                             // Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
	ImageFlipVertical     :: proc(image: ^Image) ---                                                                            // Flip image vertically
	ImageFlipHorizontal   :: proc(image: ^Image) ---                                                                            // Flip image horizontally
	ImageRotate           :: proc(image: ^Image, degrees: c.int) ---                                                            // Rotate image by input angle in degrees( -359 to 359)
	ImageRotateCW         :: proc(image: ^Image) ---                                                                            // Rotate image clockwise 90deg
	ImageRotateCCW        :: proc(image: ^Image) ---                                                                            // Rotate image counter-clockwise 90deg
	ImageColorTint        :: proc(image: ^Image, color: Color) ---                                                              // Modify image color: tint
	ImageColorInvert      :: proc(image: ^Image) ---                                                                            // Modify image color: invert
	ImageColorGrayscale   :: proc(image: ^Image) ---                                                                            // Modify image color: grayscale
	ImageColorContrast    :: proc(image: ^Image, contrast: f32) ---                                                             // Modify image color: contrast (-100 to 100)
	ImageColorBrightness  :: proc(image: ^Image, brightness: c.int) ---                                                         // Modify image color: brightness (-255 to 255)
	ImageColorReplace     :: proc(image: ^Image, color, replace: Color) ---                                                     // Modify image color: replace color
	LoadImageColors       :: proc(image: Image) -> [^]Color ---                                                                 // Load color data from image as a Color array (RGBA - 32bit)
	LoadImagePalette      :: proc(image: Image, maxPaletteSize: c.int, colorCount: ^c.int) -> [^]Color ---                      // Load colors palette from image as a Color array (RGBA - 32bit)
	UnloadImageColors     :: proc(colors: [^]Color) ---                                                                         // Unload color data loaded with LoadImageColors()
	UnloadImagePalette    :: proc(colors: [^]Color) ---                                                                         // Unload colors palette loaded with LoadImagePalette()
	GetImageAlphaBorder   :: proc(image: Image, threshold: f32) -> Rectangle ---                                                // Get image alpha border rectangle
	GetImageColor         :: proc(image: Image, x, y: c.int) -> Color ---                                                       // Get image pixel color at (x, y) position

	// Image drawing functions
	// NOTE: Image software-rendering functions (CPU)

	ImageClearBackground    :: proc(dst: ^Image, color: Color) ---                                                                           // Clear image background with given color
	ImageDrawPixel          :: proc(dst: ^Image, posX, posY: c.int, color: Color) ---                                                        // Draw pixel within an image
	ImageDrawPixelV         :: proc(dst: ^Image, position: Vector2, color: Color) ---                                                        // Draw pixel within an image (Vector version)
	ImageDrawLine           :: proc(dst: ^Image, startPosX, startPosY, endPosX, endPosY: c.int, color: Color) ---                            // Draw line within an image
	ImageDrawLineV          :: proc(dst: ^Image, start, end: Vector2, color: Color) ---                                                      // Draw line within an image (Vector version)
	ImageDrawLineEx         :: proc(dst: ^Image, start, end: Vector2, thick: c.int, color: Color) ---                                        // Draw a line defining thickness within an image
	ImageDrawCircle         :: proc(dst: ^Image, centerX, centerY: c.int, radius: c.int, color: Color) ---                                   // Draw a filled circle within an image
	ImageDrawCircleV        :: proc(dst: ^Image, center: Vector2, radius: c.int, color: Color) ---                                           // Draw a filled circle within an image (Vector version)
	ImageDrawCircleLines    :: proc(dst: ^Image, centerX, centerY: c.int, radius: c.int, color: Color) ---                                   // Draw circle outline within an image
	ImageDrawCircleLinesV   :: proc(dst: ^Image, center: Vector2, radius: c.int, color: Color) ---                                           // Draw circle outline within an image (Vector version)
	ImageDrawRectangle      :: proc(dst: ^Image, posX, posY: c.int, width, height: c.int, color: Color) ---                                  // Draw rectangle within an image
	ImageDrawRectangleV     :: proc(dst: ^Image, position, size: Vector2, color: Color) ---                                                  // Draw rectangle within an image (Vector version)
	ImageDrawRectangleRec   :: proc(dst: ^Image, rec: Rectangle, color: Color) ---                                                           // Draw rectangle within an image
	ImageDrawRectangleLines :: proc(dst: ^Image, rec: Rectangle, thick: c.int, color: Color) ---                                             // Draw rectangle lines within an image
	ImageDrawTriangle       :: proc(dst: ^Image, v1, v2, v3: Vector2, color: Color) ---                                                      // Draw triangle within an image
	ImageDrawTriangleEx     :: proc(dst: ^Image, v1, v2, v3: Vector2, c1, c2, c3: Color) ---                                                 // Draw triangle with interpolated colors within an image
	ImageDrawTriangleLines  :: proc(dst: ^Image, v1, v2, v3: Vector2, color: Color) ---                                                      // Draw triangle outline within an image
	ImageDrawTriangleFan    :: proc(dst: ^Image, points: [^]Vector2, pointCount: c.int, color: Color) ---                                    // Draw a triangle fan defined by points within an image (first vertex is the center)
	ImageDrawTriangleStrip  :: proc(dst: ^Image, points: [^]Vector2, pointCount: c.int, color: Color) ---                                    // Draw a triangle strip defined by points within an image
	ImageDraw               :: proc(dst: ^Image, src: Image, srcRec, dstRec: Rectangle, tint: Color) ---                                     // Draw a source image within a destination image (tint applied to source)
	ImageDrawText           :: proc(dst: ^Image, text: cstring, posX, posY: c.int, fontSize: c.int, color: Color) ---                        // Draw text (using default font) within an image (destination)
	ImageDrawTextEx         :: proc(dst: ^Image, font: Font, text: cstring, position: Vector2, fontSize: f32, spacing: f32, tint: Color) --- // Draw text (custom sprite font) within an image (destination)

	// Texture loading functions
	// NOTE: These functions require GPU access

	LoadTexture          :: proc(fileName: cstring) -> Texture2D ---                        // Load texture from file into GPU memory (VRAM)
	LoadTextureFromImage :: proc(image: Image) -> Texture2D ---                             // Load texture from image data
	LoadTextureCubemap   :: proc(image: Image, layout: CubemapLayout) -> TextureCubemap --- // Load cubemap from image, multiple image cubemap layouts supported
	LoadRenderTexture    :: proc(width, height: c.int) -> RenderTexture2D ---               // Load texture for rendering (framebuffer)
	IsTextureValid       :: proc(texture: Texture2D) -> bool ---                            // Check if a texture is valid
	UnloadTexture        :: proc(texture: Texture2D) ---                                    // Unload texture from GPU memory (VRAM)
	IsRenderTextureValid :: proc(target: RenderTexture2D) -> bool  ---                      // Check if a render texture is valid
	UnloadRenderTexture  :: proc(target: RenderTexture2D) ---                               // Unload render texture from GPU memory (VRAM)
	UpdateTexture        :: proc(texture: Texture2D, pixels: rawptr) ---                    // Update GPU texture with new data
	UpdateTextureRec     :: proc(texture: Texture2D, rec: Rectangle, pixels: rawptr) ---    // Update GPU texture rectangle with new data

	// Texture configuration functions

	GenTextureMipmaps :: proc(texture: ^Texture2D) ---                                                                                      // Generate GPU mipmaps for a texture
	SetTextureFilter  :: proc(texture: Texture2D, filter: TextureFilter) ---                                                                // Set texture scaling filter mode
	SetTextureWrap    :: proc(texture: Texture2D, wrap: TextureWrap) ---                                                                    // Set texture wrapping mode

                                                                                                                                                // Texture drawing functions
	DrawTexture       :: proc(texture: Texture2D, posX, posY: c.int, tint: Color) ---                                                       // Draw a Texture2D
	DrawTextureV      :: proc(texture: Texture2D, position: Vector2, tint: Color) ---                                                       // Draw a Texture2D with position defined as Vector2
	DrawTextureEx     :: proc(texture: Texture2D, position: Vector2, rotation: f32, scale: f32, tint: Color) ---                            // Draw a Texture2D with extended parameters
	DrawTextureRec    :: proc(texture: Texture2D, source: Rectangle, position: Vector2, tint: Color) ---                                    // Draw a part of a texture defined by a rectangle
	DrawTexturePro    :: proc(texture: Texture2D, source, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) ---                 // Draw a part of a texture defined by a rectangle with 'pro' parameters
	DrawTextureNPatch :: proc(texture: Texture2D, nPatchInfo: NPatchInfo, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) --- // Draws a texture (or part of it) that stretches or shrinks nicely

	// Color/pixel related functions
	
	@(deprecated="Prefer col1 == col2")
	ColorIsEqual        :: proc(col1, col2: Color) ---                                  // Check if two colors are equal
	Fade                :: proc(color: Color, alpha: f32) -> Color ---                  // Get color with alpha applied, alpha goes from 0.0f to 1.0f
	ColorToInt          :: proc(color: Color) -> c.uint ---                             // Get hexadecimal value for a Color (0xRRGGBBAA)
	ColorNormalize      :: proc(color: Color) -> Vector4 ---                            // Get Color normalized as float [0..1]
	ColorFromNormalized :: proc(normalized: Vector4) -> Color ---                       // Get Color from normalized values [0..1]
	ColorToHSV          :: proc(color: Color) -> Vector3 ---                            // Get HSV values for a Color, hue [0..360], saturation/value [0..1]
	ColorFromHSV        :: proc(hue, saturation, value: f32) -> Color ---               // Get a Color from HSV values, hue [0..360], saturation/value [0..1]
	ColorTint           :: proc(color, tint: Color) -> Color ---                        // Get color multiplied with another color
	ColorBrightness     :: proc(color: Color, factor: f32) -> Color ---                 // Get color with brightness correction, brightness factor goes from -1.0f to 1.0f
	ColorContrast       :: proc(color: Color, contrast: f32) -> Color ---               // Get color with contrast correction, contrast values between -1.0f and 1.0f
	ColorAlpha          :: proc(color: Color, alpha: f32) -> Color ---                  // Get color with alpha applied, alpha goes from 0.0f to 1.0f
	ColorAlphaBlend     :: proc(dst, src, tint: Color) -> Color ---                     // Get src alpha-blended into dst color with tint
	ColorLerp           :: proc(color1, color2: Color, factor: f32) -> Color ---        // Get color lerp interpolation between two colors, factor [0.0f..1.0f]
	GetColor            :: proc(hexValue: c.uint) -> Color ---                          // Get Color structure from hexadecimal value
	GetPixelColor       :: proc(srcPtr: rawptr, format: PixelFormat) -> Color ---       // Get Color from a source pixel pointer of certain format
	SetPixelColor       :: proc(dstPtr: rawptr, color: Color, format: PixelFormat) ---  // Set color formatted into destination pixel pointer
	GetPixelDataSize    :: proc(width, height: c.int, format: PixelFormat) -> c.int --- // Get pixel data size in bytes for certain format




	//------------------------------------------------------------------------------------
	// Font Loading and Text Drawing Functions (Module: text)
	//------------------------------------------------------------------------------------

	// Font loading/unloading functions

	GetFontDefault     :: proc() -> Font ---                                                                                                                  		   // Get the default Font
	LoadFont           :: proc(fileName: cstring) -> Font ---                                                                                                 		   // Load font from file into GPU memory (VRAM)
	LoadFontEx         :: proc(fileName: cstring, fontSize: c.int, codepoints: [^]rune, codepointCount: c.int) -> Font ---                                             // Load font from file with extended parameters, use NULL for codepoints and 0 for codepointCount to load the default character set, font size is provided in pixels height
	LoadFontFromImage  :: proc(image: Image, key: Color, firstChar: rune) -> Font ---                                                                         		   // Load font from Image (XNA style)
	LoadFontFromMemory :: proc(fileType: cstring, fileData: rawptr, dataSize: c.int, fontSize: c.int, codepoints: [^]rune, codepointCount: c.int) -> Font ---      	   // Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
	IsFontValid        :: proc(font: Font) -> bool ---                                                                                                        		   // Check if a font is valid (font data loaded, WARNING: GPU texture not checked)
	LoadFontData       :: proc(fileData: rawptr, dataSize: c.int, fontSize: c.int, codepoints: [^]rune, codepointCount: c.int, type: FontType) -> [^]GlyphInfo --- 	   // Load font data for further use
	GenImageFontAtlas  :: proc(glyphs: [^]GlyphInfo, glyphRecs: ^[^]Rectangle, codepointCount: c.int, fontSize: c.int, padding: c.int, packMethod: c.int) -> Image --- // Generate image font atlas using chars info
	UnloadFontData     :: proc(glyphs: [^]GlyphInfo, glyphCount: c.int) ---                                                                                    		   // Unload font chars info data (RAM)
	UnloadFont         :: proc(font: Font) ---                                                                                                                		   // Unload font from GPU memory (VRAM)
	ExportFontAsCode   :: proc(font: Font, fileName: cstring) -> bool ---                                                                                     		   // Export font as code file, returns true on success

	// Text drawing functions

	DrawFPS            :: proc(posX, posY: c.int) ---                                                                                             		// Draw current FPS
	DrawText           :: proc(text: cstring, posX, posY: c.int, fontSize: c.int, color: Color) ---                                               		// Draw text (using default font)
	DrawTextEx         :: proc(font: Font, text: cstring, position: Vector2, fontSize: f32, spacing: f32, tint: Color) ---                        		// Draw text using font and additional parameters
	DrawTextPro        :: proc(font: Font, text: cstring, position, origin: Vector2, rotation: f32, fontSize: f32, spacing: f32, tint: Color) --- 		// Draw text using Font and pro parameters (rotation)
	DrawTextCodepoint  :: proc(font: Font, codepoint: rune, position: Vector2, fontSize: f32, tint: Color) ---                                    		// Draw one character (codepoint)
	DrawTextCodepoints :: proc(font: Font, codepoints: [^]rune, codepointCount: c.int, position: Vector2, fontSize: f32, spacing: f32, tint: Color) ---     // Draw multiple character (codepoint)

	// Text font info functions

	SetTextLineSpacing :: proc(spacing: c.int) ---                                                      // Set vertical line spacing when drawing with line-breaks
	MeasureText        :: proc(text: cstring, fontSize: c.int) -> c.int ---                             // Measure string width for default font
	MeasureTextEx      :: proc(font: Font, text: cstring, fontSize: f32, spacing: f32) -> Vector2 ---   // Measure string size for Font
	GetGlyphIndex      :: proc(font: Font, codepoint: rune) -> c.int ---                                // Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
	GetGlyphInfo       :: proc(font: Font, codepoint: rune) -> GlyphInfo ---                            // Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
	GetGlyphAtlasRec   :: proc(font: Font, codepoint: rune) -> Rectangle ---                            // Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found

	// Text codepoints management functions (unicode characters)

	LoadUTF8             :: proc(codepoints: [^]rune, length: c.int) -> [^]byte --- // Load UTF-8 text encoded from codepoints array
	UnloadUTF8           :: proc(text: [^]byte) ---                                 // Unload UTF-8 text encoded from codepoints array
	LoadCodepoints       :: proc(text: cstring, count: ^c.int) -> [^]rune ---       // Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
	UnloadCodepoints     :: proc(codepoints: [^]rune) ---                           // Unload codepoints data from memory
	GetCodepointCount    :: proc(text: cstring) -> c.int ---                        // Get total number of codepoints in a UTF-8 encoded string
	GetCodepoint         :: proc(text: cstring, codepointSize: ^c.int) -> rune ---  // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
	GetCodepointNext     :: proc(text: cstring, codepointSize: ^c.int) -> rune ---  // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
	GetCodepointPrevious :: proc(text: cstring, codepointSize: ^c.int) -> rune ---  // Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
	CodepointToUTF8      :: proc(codepoint: rune, utf8Size: ^c.int) -> cstring ---  // Encode one codepoint into UTF-8 byte array (array length returned as parameter)

	// Text strings management functions (no UTF-8 strings, only byte chars)
	// NOTE: Some strings allocate memory internally for returned strings, just be careful!

	TextCopy      :: proc(dst: [^]byte, src: cstring) -> c.int ---                               // Copy one string to another, returns bytes copied
	TextIsEqual   :: proc(text1, text2: cstring) -> bool ---                                     // Check if two text string are equal
	TextLength    :: proc(text: cstring) -> c.uint ---                                           // Get text length, checks for '\0' ending

	// TextFormat is defined at the bottom of this file

	TextSubtext   :: proc(text: cstring, position: c.int, length: c.int) -> cstring ---          // Get a piece of a text string
	TextReplace   :: proc(text: [^]byte, replace, by: cstring) -> [^]byte ---                    // Replace text string (WARNING: memory must be freed!)
	TextInsert    :: proc(text, insert: cstring, position: c.int) -> [^]byte ---                 // Insert text in a position (WARNING: memory must be freed!)
	TextJoin      :: proc(textList: [^]cstring, count: c.int, delimiter: cstring) -> cstring --- // Join text strings with delimiter
	TextSplit     :: proc(text: cstring, delimiter: byte, count: ^c.int) -> [^]cstring ---       // Split text into multiple strings
	TextAppend    :: proc(text: [^]byte, append: cstring, position: ^c.int) ---                  // Append text at specific position and move cursor!
	TextFindIndex :: proc(text, find: cstring) -> c.int ---                                      // Find first text occurrence within a string
	TextToUpper   :: proc(text: cstring) -> cstring ---                                          // Get upper case version of provided string
	TextToLower   :: proc(text: cstring) -> cstring ---                                          // Get lower case version of provided string
	TextToPascal  :: proc(text: cstring) -> cstring ---                                          // Get Pascal case notation version of provided string
	TextToSnake   :: proc(text: cstring) -> cstring ---                                          // Get Snake case notation version of provided string
	TextToCamel   :: proc(text: cstring) -> cstring ---                                          // Get Camel case notation version of provided string

	TextToInteger :: proc(text: cstring) -> c.int ---                                            // Get integer value from text (negative values not supported)
	TextToFloat   :: proc(text: cstring) -> f32 ---                                              // Get float value from text (negative values not supported)


	//------------------------------------------------------------------------------------
	// Basic 3d Shapes Drawing Functions (Module: models)
	//------------------------------------------------------------------------------------

	// Basic geometric 3D shapes drawing functions

	DrawLine3D           :: proc(startPos, endPos: Vector3, color: Color) ---                                                   // Draw a line in 3D world space
	DrawPoint3D          :: proc(position: Vector3, color: Color) ---                                                           // Draw a point in 3D space, actually a small line
	DrawCircle3D         :: proc(center: Vector3, radius: f32, rotationAxis: Vector3, rotationAngle: f32, color: Color) ---     // Draw a circle in 3D world space
	DrawTriangle3D       :: proc(v1, v2, v3: Vector3, color: Color) ---                                                         // Draw a color-filled triangle (vertex in counter-clockwise order!)
	DrawTriangleStrip3D  :: proc(points: [^]Vector3, pointCount: c.int, color: Color) ---                                       // Draw a triangle strip defined by points
	DrawCube             :: proc(position: Vector3, width, height, length: f32, color: Color) ---                               // Draw cube
	DrawCubeV            :: proc(position: Vector3, size: Vector3, color: Color) ---                                            // Draw cube (Vector version)
	DrawCubeWires        :: proc(position: Vector3, width, height, length: f32, color: Color) ---                               // Draw cube wires
	DrawCubeWiresV       :: proc(position, size: Vector3, color: Color) ---                                                     // Draw cube wires (Vector version)
	DrawSphere           :: proc(centerPos: Vector3, radius: f32, color: Color) ---                                             // Draw sphere
	DrawSphereEx         :: proc(centerPos: Vector3, radius: f32, rings, slices: c.int, color: Color) ---                       // Draw sphere with extended parameters
	DrawSphereWires      :: proc(centerPos: Vector3, radius: f32, rings, slices: c.int, color: Color) ---                       // Draw sphere wires
	DrawCylinder         :: proc(position: Vector3, radiusTop, radiusBottom: f32, height: f32, slices: c.int, color: Color) --- // Draw a cylinder/cone
	DrawCylinderEx       :: proc(startPos, endPos: Vector3, startRadius, endRadius: f32, sides: c.int, color: Color) ---        // Draw a cylinder with base at startPos and top at endPos
	DrawCylinderWires    :: proc(position: Vector3, radiusTop, radiusBottom, height: f32, slices: c.int, color: Color) ---      // Draw a cylinder/cone wires
	DrawCylinderWiresEx  :: proc(startPos, endPos: Vector3, startRadius, endRadius: f32, sides: c.int, color: Color) ---        // Draw a cylinder wires with base at startPos and top at endPos
	DrawCapsule          :: proc(startPos, endPos: Vector3, radius: f32, slices, rings: c.int, color: Color) ---                // Draw a capsule with the center of its sphere caps at startPos and endPos
	DrawCapsuleWires     :: proc(startPos, endPos: Vector3, radius: f32, slices, rings: c.int, color: Color) ---                // Draw capsule wireframe with the center of its sphere caps at startPos and endPos
	DrawPlane            :: proc(centerPos: Vector3, size: Vector2, color: Color) ---                                           // Draw a plane XZ
	DrawRay              :: proc(ray: Ray, color: Color) ---                                                                    // Draw a ray line
	DrawGrid             :: proc(slices: c.int, spacing: f32) ---                                                               // Draw a grid (centered at (0, 0, 0))

	//------------------------------------------------------------------------------------
	// Model 3d Loading and Drawing Functions (Module: models)
	//------------------------------------------------------------------------------------

	// Model management functions

	LoadModel           :: proc(fileName: cstring) -> Model ---  // Load model from files (meshes and materials)
	LoadModelFromMesh   :: proc(mesh: Mesh) -> Model ---         // Load model from generated mesh (default material)
	IsModelValid        :: proc(model: Model) -> bool ---        // Check if a model is valid (loaded in GPU, VAO/VBOs)
	UnloadModel         :: proc(model: Model) ---                // Unload model (including meshes) from memory (RAM and/or VRAM)
	GetModelBoundingBox :: proc(model: Model) -> BoundingBox --- // Compute model bounding box limits (considers all meshes)

	// Model drawing functions

	DrawModel         :: proc(model: Model, position: Vector3, scale: f32, tint: Color) ---                                                                                          // Draw a model (with texture if set)
	DrawModelEx       :: proc(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) ---                                           // Draw a model with extended parameters
	DrawModelWires    :: proc(model: Model, position: Vector3, scale: f32, tint: Color) ---                                                                                          // Draw a model wires (with texture if set)
	DrawModelWiresEx  :: proc(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) ---                                           // Draw a model wires (with texture if set) with extended parameters
	DrawModelPoints   :: proc(model: Model, position: Vector3, scale: f32, tint: Color) ---                                                                                          // Draw a model as points
	DrawModelPointsEx :: proc(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) ---                                           // Draw a model as points with extended parameters
	DrawBoundingBox   :: proc(box: BoundingBox, color: Color) ---                                                                                                                    // Draw bounding box (wires)
	DrawBillboard     :: proc(camera: Camera, texture: Texture2D, position: Vector3, scale: f32, tint: Color) ---                                                                    // Draw a billboard texture
	DrawBillboardRec  :: proc(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, size: Vector2, tint: Color) ---                                              // Draw a billboard texture defined by source
	DrawBillboardPro  :: proc(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: f32, tint: Color) --- // Draw a billboard texture defined by source and rotation

	// Mesh management functions

	UploadMesh         :: proc(mesh: ^Mesh, is_dynamic: bool) ---                                             // Upload mesh vertex data in GPU and provide VAO/VBO ids
	UpdateMeshBuffer   :: proc(mesh: Mesh, index: c.int, data: rawptr, dataSize: c.int, offset: c.int) ---    // Update mesh vertex data in GPU for a specific buffer index
	UnloadMesh         :: proc(mesh: Mesh) ---                                                                // Unload mesh data from CPU and GPU
	DrawMesh           :: proc(mesh: Mesh, material: Material, transform: Matrix) ---                         // Draw a 3d mesh with material and transform
	DrawMeshInstanced  :: proc(mesh: Mesh, material: Material, transforms: [^]Matrix, instances: c.int) ---   // Draw multiple mesh instances with material and different transforms
	GetMeshBoundingBox :: proc(mesh: Mesh) -> BoundingBox ---                                                 // Compute mesh bounding box limits
	GenMeshTangents    :: proc(mesh: ^Mesh) ---                                                               // Compute mesh tangents
	ExportMesh         :: proc(mesh: Mesh, fileName: cstring) -> bool ---                                     // Export mesh data to file, returns true on success
	ExportMeshAsCode   :: proc(mesh: Mesh, fileName: cstring) -> bool ---                                     // Export mesh as code file (.h) defining multiple arrays of vertex attributes

	// Mesh generation functions

	GenMeshPoly       :: proc(sides: c.int, radius: f32) -> Mesh ---               // Generate polygonal mesh
	GenMeshPlane      :: proc(width, length: f32, resX, resZ: c.int) -> Mesh ---   // Generate plane mesh (with subdivisions)
	GenMeshCube       :: proc(width, height, length: f32) -> Mesh ---              // Generate cuboid mesh
	GenMeshSphere     :: proc(radius: f32, rings, slices: c.int) -> Mesh ---       // Generate sphere mesh (standard sphere)
	GenMeshHemiSphere :: proc(radius: f32, rings, slices: c.int) -> Mesh ---       // Generate half-sphere mesh (no bottom cap)
	GenMeshCylinder   :: proc(radius, height: f32, slices: c.int) -> Mesh ---      // Generate cylinder mesh
	GenMeshCone       :: proc(radius, height: f32, slices: c.int) -> Mesh ---      // Generate cone/pyramid mesh
	GenMeshTorus      :: proc(radius, size: f32, radSeg, sides: c.int) -> Mesh --- // Generate torus mesh
	GenMeshKnot       :: proc(radius, size: f32, radSeg, sides: c.int) -> Mesh --- // Generate trefoil knot mesh
	GenMeshHeightmap  :: proc(heightmap: Image, size: Vector3) -> Mesh ---         // Generate heightmap mesh from image data
	GenMeshCubicmap   :: proc(cubicmap: Image, cubeSize: Vector3) -> Mesh ---      // Generate cubes-based map mesh from image data

	// Material loading/unloading functions

	LoadMaterials         :: proc(fileName: cstring, materialCount: ^c.int) -> [^]Material ---            // Load materials from model file
	LoadMaterialDefault   :: proc() -> Material ---                                                       // Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
	IsMaterialValid       :: proc(material: Material) -> bool ---                                         // Check if a material is valid (shader assigned, map textures loaded in GPU)
	UnloadMaterial        :: proc(material: Material) ---                                                 // Unload material from GPU memory (VRAM)
	SetMaterialTexture    :: proc(material: ^Material, mapType: MaterialMapIndex, texture: Texture2D) --- // Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
	SetModelMeshMaterial  :: proc(model: ^Model, meshId: c.int, materialId: c.int) ---                    // Set material for a mesh

	// Model animations loading/unloading functions

	LoadModelAnimations       :: proc(fileName: cstring, animCount: ^c.int) -> [^]ModelAnimation ---  // Load model animations from file
	UpdateModelAnimation      :: proc(model: Model, anim: ModelAnimation, frame: c.int) ---           // Update model animation pose (CPU)
	UpdateModelAnimationBones :: proc(model: Model, anim: ModelAnimation, frame: c.int) ---           // Update model animation mesh bone matrices (GPU skinning)
	UnloadModelAnimation      :: proc(anim: ModelAnimation) ---                                       // Unload animation data
	UnloadModelAnimations     :: proc(animations: [^]ModelAnimation, animCount: c.int) ---            // Unload animation array data
	IsModelAnimationValid     :: proc(model: Model, anim: ModelAnimation) -> bool ---                 // Check model animation skeleton match

	// Collision detection functions

	CheckCollisionSpheres   :: proc(center1: Vector3, radius1: f32, center2: Vector3, radius2: f32) -> bool --- // Check collision between two spheres
	CheckCollisionBoxes     :: proc(box1, box2: BoundingBox) -> bool ---                                        // Check collision between two bounding boxes
	CheckCollisionBoxSphere :: proc(box: BoundingBox, center: Vector3, radius: f32) -> bool ---                 // Check collision between box and sphere
	GetRayCollisionSphere   :: proc(ray: Ray, center: Vector3, radius: f32) -> RayCollision ---                 // Get collision info between ray and sphere
	GetRayCollisionBox      :: proc(ray: Ray, box: BoundingBox) -> RayCollision ---                             // Get collision info between ray and box
	GetRayCollisionMesh     :: proc(ray: Ray, mesh: Mesh, transform: Matrix) -> RayCollision ---                // Get collision info between ray and mesh
	GetRayCollisionTriangle :: proc(ray: Ray, p1, p2, p3: Vector3) -> RayCollision ---                          // Get collision info between ray and triangle
	GetRayCollisionQuad     :: proc(ray: Ray, p1, p2, p3, p4: Vector3) -> RayCollision ---                      // Get collision info between ray and quad

	//------------------------------------------------------------------------------------
	// Audio Loading and Playing Functions (Module: audio)
	//------------------------------------------------------------------------------------

	// Audio device management functions

	InitAudioDevice    :: proc() ---            // Initialize audio device and context
	CloseAudioDevice   :: proc() ---            // Close the audio device and context
	IsAudioDeviceReady :: proc() -> bool ---    // Check if audio device has been initialized successfully
	SetMasterVolume    :: proc(volume: f32) --- // Set master volume (listener)
	GetMasterVolume    :: proc() -> f32 ---     // Get master volume (listener)

	// Wave/Sound loading/unloading functions

	LoadWave           :: proc(fileName: cstring) -> Wave ---                                    // Load wave data from file
	LoadWaveFromMemory :: proc(fileType: cstring, fileData: rawptr, dataSize: c.int) -> Wave --- // Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
	IsWaveValid        :: proc(wave: Wave) -> bool ---                                           // Checks if wave data is // Checks if wave data is valid (data loaded and parameters)
	LoadSound          :: proc(fileName: cstring) -> Sound ---                                   // Load sound from file
	LoadSoundFromWave  :: proc(wave: Wave) -> Sound ---                                          // Load sound from wave data
	LoadSoundAlias	   :: proc(source: Sound) -> Sound ---                                       // Create a new sound that shares the same sample data as the source sound, does not own the sound data
	IsSoundValid       :: proc(sound: Sound) -> bool ---                                         // Checks if a sound is valid (data loaded and buffers initialized)
	UpdateSound        :: proc(sound: Sound, data: rawptr, frameCount: c.int) ---                // Update sound buffer with new data
	UnloadWave         :: proc(wave: Wave) ---                                                   // Unload wave data
	UnloadSound        :: proc(sound: Sound) ---                                                 // Unload sound
	UnloadSoundAlias   :: proc(alias: Sound) ---                                                 // Unload a sound alias (does not deallocate sample data)
	ExportWave         :: proc(wave: Wave, fileName: cstring) -> bool ---                        // Export wave data to file, returns true on success
	ExportWaveAsCode   :: proc(wave: Wave, fileName: cstring) -> bool ---                        // Export wave sample data to code (.h), returns true on success

	// Wave/Sound management functions

	PlaySound         :: proc(sound: Sound) ---                                                // Play a sound
	StopSound         :: proc(sound: Sound) ---                                                // Stop playing a sound
	PauseSound        :: proc(sound: Sound) ---                                                // Pause a sound
	ResumeSound       :: proc(sound: Sound) ---                                                // Resume a paused sound
	IsSoundPlaying    :: proc(sound: Sound) -> bool ---                                        // Check if a sound is currently playing
	SetSoundVolume    :: proc(sound: Sound, volume: f32) ---                                   // Set volume for a sound (1.0 is max level)
	SetSoundPitch     :: proc(sound: Sound, pitch: f32) ---                                    // Set pitch for a sound (1.0 is base level)
	SetSoundPan       :: proc(sound: Sound, pan: f32) ---                                      // Set pan for a sound (0.5 is center)
	WaveCopy          :: proc(wave: Wave) -> Wave ---                                          // Copy a wave to a new wave
	WaveCrop          :: proc(wave: ^Wave, initFrame, finalFrame: c.int) ---                   // Crop a wave to defined samples range
	WaveFormat        :: proc(wave: ^Wave, sampleRate, sampleSize: c.int, channels: c.int) --- // Convert wave data to desired format
	LoadWaveSamples   :: proc(wave: Wave) -> [^]f32 ---                                        // Load samples data from wave as a 32bit float data array
	UnloadWaveSamples :: proc(samples: [^]f32) ---                                             // Unload samples data loaded with LoadWaveSamples()


	// Music management functions

	LoadMusicStream           :: proc(fileName: cstring) -> Music ---                                // Load music stream from file
	LoadMusicStreamFromMemory :: proc(fileType: cstring, data: rawptr, dataSize: c.int) -> Music --- // Load music stream from data
	IsMusicValid              :: proc(music: Music) -> bool ---                                      // Checks if a music stream is valid (context and buffers initialized)
	UnloadMusicStream         :: proc(music: Music) ---                                              // Unload music stream
	PlayMusicStream           :: proc(music: Music) ---                                              // Start music playing
	IsMusicStreamPlaying      :: proc(music: Music) -> bool ---                                      // Check if music is playing
	UpdateMusicStream         :: proc(music: Music) ---                                              // Updates buffers for music streaming
	StopMusicStream           :: proc(music: Music) ---                                              // Stop music playing
	PauseMusicStream          :: proc(music: Music) ---                                              // Pause music playing
	ResumeMusicStream         :: proc(music: Music) ---                                              // Resume playing paused music
	SeekMusicStream           :: proc(music: Music, position: f32) ---                               // Seek music to a position (in seconds)
	SetMusicVolume            :: proc(music: Music, volume: f32) ---                                 // Set volume for music (1.0 is max level)
	SetMusicPitch             :: proc(music: Music, pitch: f32) ---                                  // Set pitch for a music (1.0 is base level)
	SetMusicPan               :: proc(music: Music, pan: f32) ---                                    // Set pan for a music (0.5 is center)
	GetMusicTimeLength        :: proc(music: Music) -> f32 ---                                       // Get music time length (in seconds)
	GetMusicTimePlayed        :: proc(music: Music) -> f32 ---                                       // Get current music time played (in seconds)

	// AudioStream management functions

	LoadAudioStream                 :: proc(sampleRate, sampleSize: c.uint, channels: c.uint) -> AudioStream --- // Load audio stream (to stream raw audio pcm data)
	IsAudioStreamValid              :: proc(stream: AudioStream) -> bool ---                                     // Checks if an audio stream is valid (buffers initialized)
	UnloadAudioStream               :: proc(stream: AudioStream) ---                                             // Unload audio stream and free memory
	UpdateAudioStream               :: proc(stream: AudioStream, data: rawptr, frameCount: c.int) ---            // Update audio stream buffers with data
	IsAudioStreamProcessed          :: proc(stream: AudioStream) -> bool ---                                     // Check if any audio stream buffers requires refill
	PlayAudioStream                 :: proc(stream: AudioStream) ---                                             // Play audio stream
	PauseAudioStream                :: proc(stream: AudioStream) ---                                             // Pause audio stream
	ResumeAudioStream               :: proc(stream: AudioStream) ---                                             // Resume audio stream
	IsAudioStreamPlaying            :: proc(stream: AudioStream) -> bool ---                                     // Check if audio stream is playing
	StopAudioStream                 :: proc(stream: AudioStream) ---                                             // Stop audio stream
	SetAudioStreamVolume            :: proc(stream: AudioStream, volume: f32) ---                                // Set volume for audio stream (1.0 is max level)
	SetAudioStreamPitch             :: proc(stream: AudioStream, pitch: f32) ---                                 // Set pitch for audio stream (1.0 is base level)
	SetAudioStreamPan               :: proc(stream: AudioStream, pan: f32) ---                                   // Set pan for audio stream (0.5 is centered)
	SetAudioStreamBufferSizeDefault :: proc(size: c.int) ---                                                     // Default size for new audio streams
	SetAudioStreamCallback          :: proc(stream: AudioStream, callback: AudioCallback) ---                    // Audio thread callback to request new data

	AttachAudioStreamProcessor :: proc(stream: AudioStream, processor: AudioCallback) --- // Attach audio stream processor to stream, receives the samples as 'float'
	DetachAudioStreamProcessor :: proc(stream: AudioStream, processor: AudioCallback) --- // Detach audio stream processor from stream

	AttachAudioMixedProcessor :: proc(processor: AudioCallback) --- // Attach audio stream processor to the entire audio pipeline, receives the samples as 'float'
	DetachAudioMixedProcessor :: proc(processor: AudioCallback) --- // Detach audio stream processor from the entire audio pipeline
}

//  Check if a gesture have been detected
IsGestureDetected :: proc "c" (gesture: Gesture) -> bool {
	@(default_calling_convention="c")
	foreign {
		IsGestureDetected :: proc "c" (gesture: Gestures) -> bool ---
	}
	return IsGestureDetected({gesture})
}

@(default_calling_convention="c")
foreign {
	@(link_name="MemFree")
	MemFreePtr :: proc(ptr: rawptr) ---
}
