/*
Package vendor:raylib implements bindings for version 5.5 of the raylib library (https://www.raylib.com/)

	*********************************************************************************************
	*
	*   raylib v5.5 - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
	*
	*   FEATURES:
	*       - NO external dependencies, all required libraries included with raylib
	*       - Multiplatform: Windows, Linux, FreeBSD, OpenBSD, NetBSD, DragonFly,
	*                        MacOS, Haiku, Android, Raspberry Pi, DRM native, HTML5.
	*       - Written in plain C code (C99) in PascalCase/camelCase notation
	*       - Hardware accelerated with OpenGL (1.1, 2.1, 3.3, 4.3, ES2, ES3 - choose at compile)
	*       - Unique OpenGL abstraction layer (usable as standalone module): [rlgl]
	*       - Multiple Fonts formats supported (TTF, OTF, FNT, BDF, Sprite fonts)
	*       - Outstanding texture formats support, including compressed formats (DXT, ETC, ASTC)
	*       - Full 3d support for 3d Shapes, Models, Billboards, Heightmaps and more!
	*       - Flexible Materials system, supporting classic maps and PBR maps
	*       - Animated 3D models supported (skeletal bones animation) (IQM, M3D, GLTF)
	*       - Shaders support, including Model shaders and Postprocessing shaders
	*       - Powerful math module for Vector, Matrix and Quaternion operations: [raymath]
	*       - Audio loading and playing with streaming support (WAV, OGG, MP3, FLAC, QOA, XM, MOD)
	*       - VR stereo rendering with configurable HMD device parameters
	*       - Bindings to multiple programming languages available!
	*
	*   NOTES:
	*       - One default Font is loaded on InitWindow()->LoadFontDefault() [core, text]
	*       - One default Texture2D is loaded on rlglInit(), 1x1 white pixel R8G8B8A8 [rlgl] (OpenGL 3.3 or ES2)
	*       - One default Shader is loaded on rlglInit()->rlLoadShaderDefault() [rlgl] (OpenGL 3.3 or ES2)
	*       - One default RenderBatch is loaded on rlglInit()->rlLoadRenderBatch() [rlgl] (OpenGL 3.3 or ES2)
	*
	*   DEPENDENCIES (included):
	*       [rcore][GLFW] rglfw (Camilla Löwy - github.com/glfw/glfw) for window/context management and input
	*       [rcore][RGFW] rgfw (ColleagueRiley - github.com/ColleagueRiley/RGFW) for window/context management and input
	*       [rlgl] glad/glad_gles2 (David Herberth - github.com/Dav1dde/glad) for OpenGL 3.3 extensions loading
	*       [raudio] miniaudio (David Reid - github.com/mackron/miniaudio) for audio device/context management
	*
	*   OPTIONAL DEPENDENCIES (included):
	*       [rcore] msf_gif (Miles Fogle) for GIF recording
	*       [rcore] sinfl (Micha Mettke) for DEFLATE decompression algorithm
	*       [rcore] sdefl (Micha Mettke) for DEFLATE compression algorithm
	*       [rcore] rprand (Ramon Snatamaria) for pseudo-random numbers generation
	*       [rtextures] qoi (Dominic Szablewski - https://phoboslab.org) for QOI image manage
	*       [rtextures] stb_image (Sean Barret) for images loading (BMP, TGA, PNG, JPEG, HDR...)
	*       [rtextures] stb_image_write (Sean Barret) for image writing (BMP, TGA, PNG, JPG)
	*       [rtextures] stb_image_resize2 (Sean Barret) for image resizing algorithms
	*       [rtextures] stb_perlin (Sean Barret) for Perlin Noise image generation
	*       [rtext] stb_truetype (Sean Barret) for ttf fonts loading
	*       [rtext] stb_rect_pack (Sean Barret) for rectangles packing
	*       [rmodels] par_shapes (Philip Rideout) for parametric 3d shapes generation
	*       [rmodels] tinyobj_loader_c (Syoyo Fujita) for models loading (OBJ, MTL)
	*       [rmodels] cgltf (Johannes Kuhlmann) for models loading (glTF)
	*       [rmodels] m3d (bzt) for models loading (M3D, https://bztsrc.gitlab.io/model3d)
	*       [rmodels] vox_loader (Johann Nadalutti) for models loading (VOX)
	*       [raudio] dr_wav (David Reid) for WAV audio file loading
	*       [raudio] dr_flac (David Reid) for FLAC audio file loading
	*       [raudio] dr_mp3 (David Reid) for MP3 audio file loading
	*       [raudio] stb_vorbis (Sean Barret) for OGG audio loading
	*       [raudio] jar_xm (Joshua Reisenauer) for XM audio module loading
	*       [raudio] jar_mod (Joshua Reisenauer) for MOD audio module loading
	*       [raudio] qoa (Dominic Szablewski - https://phoboslab.org) for QOA audio manage
	*
	*
	*   LICENSE: zlib/libpng
	*
	*   raylib is licensed under an unmodified zlib/libpng license, which is an OSI-certified,
	*   BSD-like license that allows static linking with closed source software:
	*
	*   Copyright (c) 2013-2024 Ramon Santamaria (@raysan5)
	*
	*   This software is provided "as-is", without any express or implied warranty. In no event
	*   will the authors be held liable for any damages arising from the use of this software.
	*
	*   Permission is granted to anyone to use this software for any purpose, including commercial
	*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
	*
	*     1. The origin of this software must not be misrepresented; you must not claim that you
	*     wrote the original software. If you use this software in a product, an acknowledgment
	*     in the product documentation would be appreciated but is not required.
	*
	*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
	*     as being the original software.
	*
	*     3. This notice may not be removed or altered from any source distribution.
	*
	*********************************************************************************************
*/
package raylib

import "core:c"
import "core:fmt"
import "core:mem"

import "core:math/linalg"
_ :: linalg

MAX_TEXTFORMAT_BUFFERS :: #config(RAYLIB_MAX_TEXTFORMAT_BUFFERS, 4)
MAX_TEXT_BUFFER_LENGTH :: #config(RAYLIB_MAX_TEXT_BUFFER_LENGTH, 1024)

#assert(size_of(rune) == size_of(c.int))

RAYLIB_SHARED :: #config(RAYLIB_SHARED, false)

VERSION_MAJOR :: 5
VERSION_MINOR :: 5
VERSION_PATCH :: 0
VERSION :: "5.5"

PI :: 3.14159265358979323846 
DEG2RAD :: PI/180.0
RAD2DEG :: 180.0/PI


// Some Basic Colors
// NOTE: Custom raylib color palette for amazing visuals on WHITE background
LIGHTGRAY  :: Color{ 200, 200, 200, 255 }   // Light Gray
GRAY       :: Color{ 130, 130, 130, 255 }   // Gray
DARKGRAY   :: Color{ 80, 80, 80, 255 }      // Dark Gray
YELLOW     :: Color{ 253, 249, 0, 255 }     // Yellow
GOLD       :: Color{ 255, 203, 0, 255 }     // Gold
ORANGE     :: Color{ 255, 161, 0, 255 }     // Orange
PINK       :: Color{ 255, 109, 194, 255 }   // Pink
RED        :: Color{ 230, 41, 55, 255 }     // Red
MAROON     :: Color{ 190, 33, 55, 255 }     // Maroon
GREEN      :: Color{ 0, 228, 48, 255 }      // Green
LIME       :: Color{ 0, 158, 47, 255 }      // Lime
DARKGREEN  :: Color{ 0, 117, 44, 255 }      // Dark Green
SKYBLUE    :: Color{ 102, 191, 255, 255 }   // Sky Blue
BLUE       :: Color{ 0, 121, 241, 255 }     // Blue
DARKBLUE   :: Color{ 0, 82, 172, 255 }      // Dark Blue
PURPLE     :: Color{ 200, 122, 255, 255 }   // Purple
VIOLET     :: Color{ 135, 60, 190, 255 }    // Violet
DARKPURPLE :: Color{ 112, 31, 126, 255 }    // Dark Purple
BEIGE      :: Color{ 211, 176, 131, 255 }   // Beige
BROWN      :: Color{ 127, 106, 79, 255 }    // Brown
DARKBROWN  :: Color{ 76, 63, 47, 255 }      // Dark Brown

WHITE      :: Color{ 255, 255, 255, 255 }   // White
BLACK      :: Color{ 0, 0, 0, 255 }         // Black
BLANK      :: Color{ 0, 0, 0, 0 }           // Blank (Transparent)
MAGENTA    :: Color{ 255, 0, 255, 255 }     // Magenta
RAYWHITE   :: Color{ 245, 245, 245, 255 }   // My own White (raylib logo)

// Vector2 type
Vector2 :: [2]f32
// Vector3 type
Vector3 :: [3]f32
// Vector4 type
Vector4 :: [4]f32

// Quaternion type
Quaternion :: quaternion128

// Matrix type (right handed, stored row major)
Matrix :: #row_major matrix[4, 4]f32


// Color, 4 components, R8G8B8A8 (32bit)
//
// Note: In Raylib this is a struct. But here we use a fixed array, so that .rgba swizzling etc work.
Color :: distinct [4]u8

// Rectangle type
Rectangle :: struct {
	x:      f32,                  // Rectangle top-left corner position x
	y:      f32,                  // Rectangle top-left corner position y
	width:  f32,                  // Rectangle width
	height: f32,                  // Rectangle height
}

// Image type, bpp always RGBA (32bit)
// NOTE: Data stored in CPU memory (RAM)
Image :: struct {
	data:    rawptr,              // Image raw data
	width:   c.int,               // Image base width
	height:  c.int,               // Image base height
	mipmaps: c.int,               // Mipmap levels, 1 by default
	format:  PixelFormat,         // Data format (PixelFormat type)
}

// Texture type
// NOTE: Data stored in GPU memory
Texture :: struct {
	id:      c.uint,              // OpenGL texture id
	width:   c.int,               // Texture base width
	height:  c.int,               // Texture base height
	mipmaps: c.int,               // Mipmap levels, 1 by default
	format:  PixelFormat,         // Data format (PixelFormat type)
}

// Texture2D type, same as Texture
Texture2D :: Texture

// TextureCubemap type, actually, same as Texture
TextureCubemap :: Texture

// RenderTexture type, for texture rendering
RenderTexture :: struct {
	id:       c.uint,             // OpenGL framebuffer object id
	texture: Texture,             // Color buffer attachment texture
	depth:   Texture,             // Depth buffer attachment texture
} 

// RenderTexture2D type, same as RenderTexture
RenderTexture2D :: RenderTexture

// N-Patch layout info
NPatchInfo :: struct {
	source: Rectangle,            // Texture source rectangle
	left:   c.int,                // Left border offset
	top:    c.int,                // Top border offset
	right:  c.int,                // Right border offset
	bottom: c.int,                // Bottom border offset
	layout: NPatchLayout,         // Layout of the n-patch: 3x3, 1x3 or 3x1
}

// Font character info
GlyphInfo :: struct {
	value:    rune,               // Character value (Unicode)
	offsetX:  c.int,              // Character offset X when drawing
	offsetY:  c.int,              // Character offset Y when drawing
	advanceX: c.int,              // Character advance position X
	image:    Image,              // Character image data
} 

// Font type, includes texture and charSet array data
Font :: struct {
	baseSize:     c.int,          // Base size (default chars height)
	glyphCount:   c.int,          // Number of characters
	glyphPadding: c.int,          // Padding around the chars
	texture:      Texture2D,      // Characters texture atlas
	recs:         [^]Rectangle,   // Characters rectangles in texture
	glyphs:       [^]GlyphInfo,    // Characters info data
}

// Camera type, defines a camera position/orientation in 3d space
Camera3D :: struct {
	position: Vector3,            // Camera position
	target:   Vector3,            // Camera target it looks-at
	up:       Vector3,            // Camera up vector (rotation over its axis)
	fovy:     f32,                // Camera field-of-view apperture in Y (degrees) in perspective, used as near plane width in orthographic
	projection: CameraProjection, // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
}

Camera :: Camera3D                    // Camera type fallback, defaults to Camera3D

// Camera2D type, defines a 2d camera
Camera2D :: struct {
	offset:   Vector2,            // Camera offset (displacement from target)
	target:   Vector2,            // Camera target (rotation and zoom origin)
	rotation: f32,                // Camera rotation in degrees
	zoom:     f32,                // Camera zoom (scaling), should be 1.0f by default
}

// Vertex data defining a mesh
// NOTE: Data stored in CPU memory (and GPU)
Mesh :: struct {
	vertexCount:   c.int,         // Number of vertices stored in arrays
	triangleCount: c.int,         // Number of triangles stored (indexed or not)

	// Default vertex data
	vertices:   [^]f32,           // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
	texcoords:  [^]f32,           // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
	texcoords2: [^]f32,           // Vertex second texture coordinates (useful for lightmaps) (shader-location = 5)
	normals:    [^]f32,           // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
	tangents:   [^]f32,           // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
	colors:     [^]u8,            // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
	indices:    [^]u16,           // Vertex indices (in case vertex data comes indexed)

	// Animation vertex data
	animVertices: [^]f32,         // Animated vertex positions (after bones transformations)
	animNormals:  [^]f32,         // Animated normals (after bones transformations)
	boneIds:      [^]u8,          // Vertex bone ids, up to 4 bones influence by vertex (skinning)
	boneWeights:  [^]f32,         // Vertex bone weight, up to 4 bones influence by vertex (skinning)
	boneMatrices: [^]Matrix,      // Bones animated transformation matrices
	boneCount:    c.int,          // Number of bones

	// OpenGL identifiers
	vaoId: u32,                   // OpenGL Vertex Array Object id
	vboId: [^]u32,                // OpenGL Vertex Buffer Objects id (default vertex data)
}

// Shader type (generic)
Shader :: struct {
	id:   c.uint,                 // Shader program id
	locs: [^]c.int,               // Shader locations array (MAX_SHADER_LOCATIONS)
}

// Material texture map
MaterialMap :: struct {
	texture: Texture2D,           // Material map texture
	color:   Color,               // Material map color
	value:   f32,                 // Material map value
}

// Material type (generic)
Material :: struct {
	shader: Shader,               // Material shader
	maps:   [^]MaterialMap,       // Material maps array (MAX_MATERIAL_MAPS)
	params: [4]f32,               // Material generic parameters (if required)
}

// Transformation properties
Transform :: struct {
	translation: Vector3,         // Translation
	rotation:    Quaternion,      // Rotation
	scale:       Vector3,         // Scale
}

// Bone information
BoneInfo :: struct {
	name:   [32]byte `fmt:"s,0"`, // Bone name
	parent: c.int,                // Bone parent
}

// Model type
Model :: struct #align(align_of(uintptr)) {
	transform: Matrix,            // Local transform matrix

	meshCount: c.int,             // Number of meshes
	materialCount: c.int,         // Number of materials
	meshes:       [^]Mesh,        // Meshes array
	materials:    [^]Material,    // Materials array
	meshMaterial: [^]c.int,       // Mesh material number

	// Animation data
	boneCount: c.int,             // Number of bones
	bones:     [^]BoneInfo,       // Bones information (skeleton)
	bindPose:  [^]Transform,      // Bones base transformation (pose)
}

// Model animation
ModelAnimation :: struct {
	boneCount:  c.int,            // Number of bones
	frameCount: c.int,            // Number of animation frames
	bones:      [^]BoneInfo,      // Bones information (skeleton)
	framePoses: [^][^]Transform,  // Poses array by frame
	name:       [32]byte `fmt:"s,0"`, // Animation name
}

// Ray type (useful for raycast)
Ray :: struct {
	position:  Vector3,           // Ray position (origin)
	direction: Vector3,           // Ray direction (normalized)
}

// RayCollision, ray hit information
RayCollision :: struct {
	hit:      bool,               // Did the ray hit something?
	distance: f32,                // Distance to nearest hit
	point:    Vector3,            // Point of nearest hit
	normal:   Vector3,            // Surface normal of hit
}

// Bounding box type
BoundingBox :: struct {
	min: Vector3,                 // Minimum vertex box-corner
	max: Vector3,                 // Maximum vertex box-corner
}

// Wave type, defines audio wave data
Wave :: struct {
	frameCount:  c.uint,          // Total number of frames (considering channels)
	sampleRate:  c.uint,          // Frequency (samples per second)
	sampleSize:  c.uint,          // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	channels:    c.uint,          // Number of channels (1-mono, 2-stereo)
	data:        rawptr,          // Buffer data pointer
}

// Audio stream type
// NOTE: Actual structs are defined internally in raudio module
AudioStream :: struct {
	buffer:    rawptr,            // Pointer to internal data used by the audio system
	processor: rawptr,            // Pointer to internal data processor, useful for audio effects

	sampleRate: c.uint,           // Frequency (samples per second)
	sampleSize: c.uint,           // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	channels:   c.uint,           // Number of channels (1-mono, 2-stereo)
}

// Sound source type
Sound :: struct {
	using stream: AudioStream,    // Audio stream
	frameCount:   c.uint,         // Total number of frames (considering channels)
}

// Music stream type (audio file streaming from memory)
// NOTE: Anything longer than ~10 seconds should be streamed
Music :: struct {
	using stream: AudioStream,    // Audio stream
	frameCount:   c.uint,         // Total number of frames (considering channels)
	looping:      bool,           // Music looping enable

	ctxType: c.int,               // Type of music context (audio filetype)
	ctxData: rawptr,              // Audio context data, depends on type
}

// Head-Mounted-Display device parameters
VrDeviceInfo :: struct {
	hResolution:            c.int,    // Horizontal resolution in pixels
	vResolution:            c.int,    // Vertical resolution in pixels
	hScreenSize:            f32,      // Horizontal size in meters
	vScreenSize:            f32,      // Vertical size in meters
	eyeToScreenDistance:    f32,      // Distance between eye and display in meters
	lensSeparationDistance: f32,      // Lens separation distance in meters
	interpupillaryDistance: f32,      // IPD (distance between pupils) in meters
	lensDistortionValues:   [4]f32,   // Lens distortion constant parameters
	chromaAbCorrection:     [4]f32,   // Chromatic aberration correction parameters
}

// VR Stereo rendering configuration for simulator
VrStereoConfig :: struct #align(4) {
	projection:        [2]Matrix,     // VR projection matrices (per eye)
	viewOffset:        [2]Matrix,     // VR view offset matrices (per eye)
	leftLensCenter:    [2]f32,        // VR left lens center
	rightLensCenter:   [2]f32,        // VR right lens center
	leftScreenCenter:  [2]f32,        // VR left screen center
	rightScreenCenter: [2]f32,        // VR right screen center
	scale:             [2]f32,        // VR distortion scale
	scaleIn:           [2]f32,        // VR distortion scale in
}

// File path list
FilePathList :: struct {
	capacity: c.uint,                     // Filepaths max entries
	count:    c.uint,                     // Filepaths entries count
	paths:    [^]cstring,                 // Filepaths entries
}

// Automation event
AutomationEvent :: struct {
	frame:      c.uint,               // Event frame
	type:       c.uint,               // Event type (AutomationEventType)
	params:     [4]c.int,             // Event parameters (if required) ---
}

// Automation event list
AutomationEventList :: struct {
	capacity:   c.uint,                // Events max entries (MAX_AUTOMATION_EVENTS)
	count:      c.uint,                // Events entries count
	events:     [^]AutomationEvent,	   // Events entries
}

//----------------------------------------------------------------------------------
// Enumerators Definition
//----------------------------------------------------------------------------------
// System/Window config flags
// NOTE: Every bit registers one state (use it with bit masks)
// By default all flags are set to 0
ConfigFlag :: enum c.int {
	VSYNC_HINT               = 6,     // Set to try enabling V-Sync on GPU
	FULLSCREEN_MODE          = 1,     // Set to run program in fullscreen
	WINDOW_RESIZABLE         = 2,     // Set to allow resizable window
	WINDOW_UNDECORATED       = 3,     // Set to disable window decoration (frame and buttons)
	WINDOW_HIDDEN            = 7,     // Set to hide window
	WINDOW_MINIMIZED         = 9,     // Set to minimize window (iconify)
	WINDOW_MAXIMIZED         = 10,    // Set to maximize window (expanded to monitor)
	WINDOW_UNFOCUSED         = 11,    // Set to window non focused
	WINDOW_TOPMOST           = 12,    // Set to window always on top
	WINDOW_ALWAYS_RUN        = 8,     // Set to allow windows running while minimized
	WINDOW_TRANSPARENT       = 4,     // Set to allow transparent framebuffer
	WINDOW_HIGHDPI           = 13,    // Set to support HighDPI
	WINDOW_MOUSE_PASSTHROUGH = 14,    // Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
	BORDERLESS_WINDOWED_MODE = 15,    // Set to run program in borderless windowed mode
	MSAA_4X_HINT             = 5,     // Set to try enabling MSAA 4X
	INTERLACED_HINT          = 16,    // Set to try enabling interlaced video format (for V3D)
}
ConfigFlags :: distinct bit_set[ConfigFlag; c.int]


// Trace log level
TraceLogLevel :: enum c.int {
	ALL = 0,                          // Display all logs
	TRACE,                            // Trace logging, intended for internal use only
	DEBUG,                            // Debug logging, used for internal debugging, it should be disabled on release builds
	INFO,                             // Info logging, used for program execution info
	WARNING,                          // Warning logging, used on recoverable failures
	ERROR,                            // Error logging, used on unrecoverable failures
	FATAL,                            // Fatal logging, used to abort program: exit(EXIT_FAILURE)
	NONE,                             // Disable logging
}

// Keyboard keys (US keyboard layout)
// NOTE: Use GetKeyPressed() to allow redefining
// required keys for alternative layouts
KeyboardKey :: enum c.int {
	KEY_NULL         = 0,             // Key: NULL, used for no key pressed
	// Alphanumeric keys
	APOSTROPHE      = 39,             // Key: '
	COMMA           = 44,             // Key: ,
	MINUS           = 45,             // Key: -
	PERIOD          = 46,             // Key: .
	SLASH           = 47,             // Key: /
	ZERO            = 48,             // Key: 0
	ONE             = 49,             // Key: 1
	TWO             = 50,             // Key: 2
	THREE           = 51,             // Key: 3
	FOUR            = 52,             // Key: 4
	FIVE            = 53,             // Key: 5
	SIX             = 54,             // Key: 6
	SEVEN           = 55,             // Key: 7
	EIGHT           = 56,             // Key: 8
	NINE            = 57,             // Key: 9
	SEMICOLON       = 59,             // Key: ;
	EQUAL           = 61,             // Key: =
	A               = 65,             // Key: A | a
	B               = 66,             // Key: B | b
	C               = 67,             // Key: C | c
	D               = 68,             // Key: D | d
	E               = 69,             // Key: E | e
	F               = 70,             // Key: F | f
	G               = 71,             // Key: G | g
	H               = 72,             // Key: H | h
	I               = 73,             // Key: I | i
	J               = 74,             // Key: J | j
	K               = 75,             // Key: K | k
	L               = 76,             // Key: L | l
	M               = 77,             // Key: M | m
	N               = 78,             // Key: N | n
	O               = 79,             // Key: O | o
	P               = 80,             // Key: P | p
	Q               = 81,             // Key: Q | q
	R               = 82,             // Key: R | r
	S               = 83,             // Key: S | s
	T               = 84,             // Key: T | t
	U               = 85,             // Key: U | u
	V               = 86,             // Key: V | v
	W               = 87,             // Key: W | w
	X               = 88,             // Key: X | x
	Y               = 89,             // Key: Y | y
	Z               = 90,             // Key: Z | z
	LEFT_BRACKET    = 91,             // Key: [
	BACKSLASH       = 92,             // Key: '\'
	RIGHT_BRACKET   = 93,             // Key: ]
	GRAVE           = 96,             // Key: `
	// Function keys
	SPACE           = 32,             // Key: Space
	ESCAPE          = 256,            // Key: Esc
	ENTER           = 257,            // Key: Enter
	TAB             = 258,            // Key: Tab
	BACKSPACE       = 259,            // Key: Backspace
	INSERT          = 260,            // Key: Ins
	DELETE          = 261,            // Key: Del
	RIGHT           = 262,            // Key: Cursor right
	LEFT            = 263,            // Key: Cursor left
	DOWN            = 264,            // Key: Cursor down
	UP              = 265,            // Key: Cursor up
	PAGE_UP         = 266,            // Key: Page up
	PAGE_DOWN       = 267,            // Key: Page down
	HOME            = 268,            // Key: Home
	END             = 269,            // Key: End
	CAPS_LOCK       = 280,            // Key: Caps lock
	SCROLL_LOCK     = 281,            // Key: Scroll down
	NUM_LOCK        = 282,            // Key: Num lock
	PRINT_SCREEN    = 283,            // Key: Print screen
	PAUSE           = 284,            // Key: Pause
	F1              = 290,            // Key: F1
	F2              = 291,            // Key: F2
	F3              = 292,            // Key: F3
	F4              = 293,            // Key: F4
	F5              = 294,            // Key: F5
	F6              = 295,            // Key: F6
	F7              = 296,            // Key: F7
	F8              = 297,            // Key: F8
	F9              = 298,            // Key: F9
	F10             = 299,            // Key: F10
	F11             = 300,            // Key: F11
	F12             = 301,            // Key: F12
	LEFT_SHIFT      = 340,            // Key: Shift left
	LEFT_CONTROL    = 341,            // Key: Control left
	LEFT_ALT        = 342,            // Key: Alt left
	LEFT_SUPER      = 343,            // Key: Super left
	RIGHT_SHIFT     = 344,            // Key: Shift right
	RIGHT_CONTROL   = 345,            // Key: Control right
	RIGHT_ALT       = 346,            // Key: Alt right
	RIGHT_SUPER     = 347,            // Key: Super right
	KB_MENU         = 348,            // Key: KB menu
	// Keypad keys
	KP_0            = 320,            // Key: Keypad 0
	KP_1            = 321,            // Key: Keypad 1
	KP_2            = 322,            // Key: Keypad 2
	KP_3            = 323,            // Key: Keypad 3
	KP_4            = 324,            // Key: Keypad 4
	KP_5            = 325,            // Key: Keypad 5
	KP_6            = 326,            // Key: Keypad 6
	KP_7            = 327,            // Key: Keypad 7
	KP_8            = 328,            // Key: Keypad 8
	KP_9            = 329,            // Key: Keypad 9
	KP_DECIMAL      = 330,            // Key: Keypad .
	KP_DIVIDE       = 331,            // Key: Keypad /
	KP_MULTIPLY     = 332,            // Key: Keypad *
	KP_SUBTRACT     = 333,            // Key: Keypad -
	KP_ADD          = 334,            // Key: Keypad +
	KP_ENTER        = 335,            // Key: Keypad Enter
	KP_EQUAL        = 336,            // Key: Keypad =
	// Android key buttons
	BACK            = 4,              // Key: Android back button
	MENU            = 5,              // Key: Android menu button
	VOLUME_UP       = 24,             // Key: Android volume up button
	VOLUME_DOWN     = 25,             // Key: Android volume down button
}

// Mouse buttons
MouseButton :: enum c.int {
	LEFT    = 0,                      // Mouse button left
	RIGHT   = 1,                      // Mouse button right
	MIDDLE  = 2,                      // Mouse button middle (pressed wheel)
	SIDE    = 3,                      // Mouse button side (advanced mouse device)
	EXTRA   = 4,                      // Mouse button extra (advanced mouse device)
	FORWARD = 5,                      // Mouse button fordward (advanced mouse device)
	BACK    = 6,                      // Mouse button back (advanced mouse device)
}

// Mouse cursor
MouseCursor :: enum c.int {
	DEFAULT       = 0,                // Default pointer shape
	ARROW         = 1,                // Arrow shape
	IBEAM         = 2,                // Text writing cursor shape
	CROSSHAIR     = 3,                // Cross shape
	POINTING_HAND = 4,                // Pointing hand cursor
	RESIZE_EW     = 5,                // Horizontal resize/move arrow shape
	RESIZE_NS     = 6,                // Vertical resize/move arrow shape
	RESIZE_NWSE   = 7,                // Top-left to bottom-right diagonal resize/move arrow shape
	RESIZE_NESW   = 8,                // The top-right to bottom-left diagonal resize/move arrow shape
	RESIZE_ALL    = 9,                // The omnidirectional resize/move cursor shape
	NOT_ALLOWED   = 10,               // The operation-not-allowed shape
}

// Gamepad buttons
GamepadButton :: enum c.int {
	UNKNOWN = 0,                      // Unknown button, just for error checking
	LEFT_FACE_UP,                     // Gamepad left DPAD up button
	LEFT_FACE_RIGHT,                  // Gamepad left DPAD right button
	LEFT_FACE_DOWN,                   // Gamepad left DPAD down button
	LEFT_FACE_LEFT,                   // Gamepad left DPAD left button
	RIGHT_FACE_UP,                    // Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
	RIGHT_FACE_RIGHT,                 // Gamepad right button right (i.e. PS3: Circle, Xbox: B)
	RIGHT_FACE_DOWN,                  // Gamepad right button down (i.e. PS3: Cross, Xbox: A)
	RIGHT_FACE_LEFT,                  // Gamepad right button left (i.e. PS3: Square, Xbox: X)
	LEFT_TRIGGER_1,                   // Gamepad top/back trigger left (first), it could be a trailing button
	LEFT_TRIGGER_2,                   // Gamepad top/back trigger left (second), it could be a trailing button
	RIGHT_TRIGGER_1,                  // Gamepad top/back trigger right (first), it could be a trailing button
	RIGHT_TRIGGER_2,                  // Gamepad top/back trigger right (second), it could be a trailing button
	MIDDLE_LEFT,                      // Gamepad center buttons, left one (i.e. PS3: Select)
	MIDDLE,                           // Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
	MIDDLE_RIGHT,                     // Gamepad center buttons, right one (i.e. PS3: Start)
	LEFT_THUMB,                       // Gamepad joystick pressed button left
	RIGHT_THUMB,                      // Gamepad joystick pressed button right
}

// Gamepad axis
GamepadAxis :: enum c.int {
	LEFT_X        = 0,                // Gamepad left stick X axis
	LEFT_Y        = 1,                // Gamepad left stick Y axis
	RIGHT_X       = 2,                // Gamepad right stick X axis
	RIGHT_Y       = 3,                // Gamepad right stick Y axis
	LEFT_TRIGGER  = 4,                // Gamepad back trigger left, pressure level: [1..-1]
	RIGHT_TRIGGER = 5,                // Gamepad back trigger right, pressure level: [1..-1]
}

// Material map index
MaterialMapIndex :: enum c.int {
	ALBEDO = 0,                       // Albedo material (same as: MATERIAL_MAP_DIFFUSE)
	METALNESS,                        // Metalness material (same as: MATERIAL_MAP_SPECULAR)
	NORMAL,                           // Normal material
	ROUGHNESS,                        // Roughness material
	OCCLUSION,                        // Ambient occlusion material
	EMISSION,                         // Emission material
	HEIGHT,                           // Heightmap material
	CUBEMAP,                          // Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
	IRRADIANCE,                       // Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
	PREFILTER,                        // Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
	BRDF,                             // Brdf material
}


// Shader location index
ShaderLocationIndex :: enum c.int {
	VERTEX_POSITION = 0,              // Shader location: vertex attribute: position
	VERTEX_TEXCOORD01,                // Shader location: vertex attribute: texcoord01
	VERTEX_TEXCOORD02,                // Shader location: vertex attribute: texcoord02
	VERTEX_NORMAL,                    // Shader location: vertex attribute: normal
	VERTEX_TANGENT,                   // Shader location: vertex attribute: tangent
	VERTEX_COLOR,                     // Shader location: vertex attribute: color
	MATRIX_MVP,                       // Shader location: matrix uniform: model-view-projection
	MATRIX_VIEW,                      // Shader location: matrix uniform: view (camera transform)
	MATRIX_PROJECTION,                // Shader location: matrix uniform: projection
	MATRIX_MODEL,                     // Shader location: matrix uniform: model (transform)
	MATRIX_NORMAL,                    // Shader location: matrix uniform: normal
	VECTOR_VIEW,                      // Shader location: vector uniform: view
	COLOR_DIFFUSE,                    // Shader location: vector uniform: diffuse color
	COLOR_SPECULAR,                   // Shader location: vector uniform: specular color
	COLOR_AMBIENT,                    // Shader location: vector uniform: ambient color
	MAP_ALBEDO,                       // Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
	MAP_METALNESS,                    // Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
	MAP_NORMAL,                       // Shader location: sampler2d texture: normal
	MAP_ROUGHNESS,                    // Shader location: sampler2d texture: roughness
	MAP_OCCLUSION,                    // Shader location: sampler2d texture: occlusion
	MAP_EMISSION,                     // Shader location: sampler2d texture: emission
	MAP_HEIGHT,                       // Shader location: sampler2d texture: height
	MAP_CUBEMAP,                      // Shader location: samplerCube texture: cubemap
	MAP_IRRADIANCE,                   // Shader location: samplerCube texture: irradiance
	MAP_PREFILTER,                    // Shader location: samplerCube texture: prefilter
	MAP_BRDF,                         // Shader location: sampler2d texture: brdf
	VERTEX_BONEIDS,                   // Shader location: vertex attribute: boneIds
	VERTEX_BONEWEIGHTS,               // Shader location: vertex attribute: boneWeights
	BONE_MATRICES,                    // Shader location: array of matrices uniform: boneMatrices
}


// Shader uniform data type
ShaderUniformDataType :: enum c.int {
	FLOAT = 0,                        // Shader uniform type: float
	VEC2,                             // Shader uniform type: vec2 (2 float)
	VEC3,                             // Shader uniform type: vec3 (3 float)
	VEC4,                             // Shader uniform type: vec4 (4 float)
	INT,                              // Shader uniform type: int
	IVEC2,                            // Shader uniform type: ivec2 (2 int)
	IVEC3,                            // Shader uniform type: ivec3 (3 int)
	IVEC4,                            // Shader uniform type: ivec4 (4 int)
	SAMPLER2D,                        // Shader uniform type: sampler2d
}

// Pixel formats
// NOTE: Support depends on OpenGL version and platform
PixelFormat :: enum c.int {
	UNKNOWN = 0,
	UNCOMPRESSED_GRAYSCALE = 1,       // 8 bit per pixel (no alpha)
	UNCOMPRESSED_GRAY_ALPHA,          // 8*2 bpp (2 channels)
	UNCOMPRESSED_R5G6B5,              // 16 bpp
	UNCOMPRESSED_R8G8B8,              // 24 bpp
	UNCOMPRESSED_R5G5B5A1,            // 16 bpp (1 bit alpha)
	UNCOMPRESSED_R4G4B4A4,            // 16 bpp (4 bit alpha)
	UNCOMPRESSED_R8G8B8A8,            // 32 bpp
	UNCOMPRESSED_R32,                 // 32 bpp (1 channel - float)
	UNCOMPRESSED_R32G32B32,           // 32*3 bpp (3 channels - float)
	UNCOMPRESSED_R32G32B32A32,        // 32*4 bpp (4 channels - float)
	UNCOMPRESSED_R16,                 // 16 bpp (1 channel - float)
	UNCOMPRESSED_R16G16B16,           // 16*3 bpp (3 channels - float)
	UNCOMPRESSED_R16G16B16A16,        // 16*4 bpp (4 channels - float)
	COMPRESSED_DXT1_RGB,              // 4 bpp (no alpha)
	COMPRESSED_DXT1_RGBA,             // 4 bpp (1 bit alpha)
	COMPRESSED_DXT3_RGBA,             // 8 bpp
	COMPRESSED_DXT5_RGBA,             // 8 bpp
	COMPRESSED_ETC1_RGB,              // 4 bpp
	COMPRESSED_ETC2_RGB,              // 4 bpp
	COMPRESSED_ETC2_EAC_RGBA,         // 8 bpp
	COMPRESSED_PVRT_RGB,              // 4 bpp
	COMPRESSED_PVRT_RGBA,             // 4 bpp
	COMPRESSED_ASTC_4x4_RGBA,         // 8 bpp
	COMPRESSED_ASTC_8x8_RGBA,         // 2 bpp
}

// Texture parameters: filter mode
// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
TextureFilter :: enum c.int {
	POINT = 0,                        // No filter, just pixel approximation
	BILINEAR,                         // Linear filtering
	TRILINEAR,                        // Trilinear filtering (linear with mipmaps)
	ANISOTROPIC_4X,                   // Anisotropic filtering 4x
	ANISOTROPIC_8X,                   // Anisotropic filtering 8x
	ANISOTROPIC_16X,                  // Anisotropic filtering 16x
}

// Texture parameters: wrap mode
TextureWrap :: enum c.int {
	REPEAT = 0,                       // Repeats texture in tiled mode
	CLAMP,                            // Clamps texture to edge pixel in tiled mode
	MIRROR_REPEAT,                    // Mirrors and repeats the texture in tiled mode
	MIRROR_CLAMP,                      // Mirrors and clamps to border the texture in tiled mode
}

// Cubemap layouts
CubemapLayout :: enum c.int {
	AUTO_DETECT = 0,                  // Automatically detect layout type
	LINE_VERTICAL,                    // Layout is defined by a vertical line with faces
	LINE_HORIZONTAL,                  // Layout is defined by an horizontal line with faces
	CROSS_THREE_BY_FOUR,              // Layout is defined by a 3x4 cross with cubemap faces
	CROSS_FOUR_BY_THREE,              // Layout is defined by a 4x3 cross with cubemap faces
}

// Font type, defines generation method
FontType :: enum c.int {
	DEFAULT = 0,                      // Default font generation, anti-aliased
	BITMAP,                           // Bitmap font generation, no anti-aliasing
	SDF,                              // SDF font generation, requires external shader
}

// Color blending modes (pre-defined)
BlendMode :: enum c.int {
	ALPHA = 0,                        // Blend textures considering alpha (default)
	ADDITIVE,                         // Blend textures adding colors
	MULTIPLIED,                       // Blend textures multiplying colors
	ADD_COLORS,                       // Blend textures adding colors (alternative)
	SUBTRACT_COLORS,                  // Blend textures subtracting colors (alternative)
	ALPHA_PREMULTIPLY,                // Blend premultiplied textures considering alpha
	CUSTOM,                           // Blend textures using custom src/dst factors (use rlSetBlendFactors())
	CUSTOM_SEPARATE,                  // Blend textures using custom rgb/alpha separate src/dst factors (use rlSetBlendFactorsSeparate())
}

// Gestures
// NOTE: It could be used as flags to enable only some gestures
Gesture :: enum c.uint {
	TAP         = 0,                  // Tap gesture
	DOUBLETAP   = 1,                  // Double tap gesture
	HOLD        = 2,                  // Hold gesture
	DRAG        = 3,                  // Drag gesture
	SWIPE_RIGHT = 4,                  // Swipe right gesture
	SWIPE_LEFT  = 5,                  // Swipe left gesture
	SWIPE_UP    = 6,                  // Swipe up gesture
	SWIPE_DOWN  = 7,                  // Swipe down gesture
	PINCH_IN    = 8,                  // Pinch in gesture
	PINCH_OUT   = 9,                  // Pinch out gesture
}
Gestures :: distinct bit_set[Gesture; c.uint]

// Camera system modes
CameraMode :: enum c.int {
	CUSTOM = 0,              // Camera custom, controlled by user (UpdateCamera() does nothing)
	FREE,                    // Camera free mode
	ORBITAL,                 // Camera orbital, around target, zoom supported
	FIRST_PERSON,            // Camera first person
	THIRD_PERSON,            // Camera third person
}

// Camera projection
CameraProjection :: enum c.int {
	PERSPECTIVE = 0,                  // Perspective projection
	ORTHOGRAPHIC,                     // Orthographic projection
}

// N-patch layout
NPatchLayout :: enum c.int {
	NINE_PATCH = 0,          // Npatch layout: 3x3 tiles
	THREE_PATCH_VERTICAL,    // Npatch layout: 1x3 tiles
	THREE_PATCH_HORIZONTAL,  // Npatch layout: 3x1 tiles
}

// Callbacks to hook some internal functions
// WARNING: This callbacks are intended for advanced users
TraceLogCallback     :: #type proc "c" (logLevel: TraceLogLevel, text: cstring, args: ^c.va_list)       // Logging: Redirect trace log messages
LoadFileDataCallback :: #type proc "c"(fileName: cstring, dataSize: ^c.int) -> [^]u8                    // FileIO: Load binary data
SaveFileDataCallback :: #type proc "c" (fileName: cstring, data: rawptr, dataSize: c.int) -> bool       // FileIO: Save binary data
LoadFileTextCallback :: #type proc "c" (fileName: cstring) -> [^]u8                                     // FileIO: Load text data
SaveFileTextCallback :: #type proc "c" (fileName: cstring, text: cstring) -> bool                       // FileIO: Save text data

AudioCallback :: #type proc "c" (bufferData: rawptr, frames: c.uint)

// Text formatting with variables (sprintf style)
TextFormat :: proc(text: cstring, args: ..any) -> cstring {
	@static buffers: [MAX_TEXTFORMAT_BUFFERS][MAX_TEXT_BUFFER_LENGTH]byte
	@static index: u32
	
	buffer := buffers[index][:]
	mem.zero_slice(buffer)
	
	index = (index+1)%MAX_TEXTFORMAT_BUFFERS
	
	str := fmt.bprintf(buffer[:len(buffer)-1], string(text), ..args)
	buffer[len(str)] = 0
	
	return cstring(raw_data(buffer))
}

// Text formatting with variables (sprintf style) and allocates (must be freed with 'MemFree')
TextFormatAlloc :: proc(text: cstring, args: ..any) -> cstring {
	return fmt.caprintf(string(text), ..args, allocator=MemAllocator())
}

// Internal memory free
MemFree :: proc{
	MemFreePtr,
	MemFreeCstring,
}

MemFreeCstring :: proc "c" (s: cstring) {
	MemFreePtr(rawptr(s))
}


MemAllocator :: proc "contextless" () -> mem.Allocator {
	return mem.Allocator{MemAllocatorProc, nil}
}

MemAllocatorProc :: proc(allocator_data: rawptr, mode: mem.Allocator_Mode,
                         size, alignment: int,
                         old_memory: rawptr, old_size: int, location := #caller_location) -> (data: []byte, err: mem.Allocator_Error)  {
	switch mode {
	case .Alloc, .Alloc_Non_Zeroed:
		ptr := MemAlloc(c.uint(size))
		if ptr == nil {
			err = .Out_Of_Memory
			return
		}
		data = mem.byte_slice(ptr, size)
		return
	case .Free:
		MemFree(old_memory)
		return nil, nil
	
	case .Resize, .Resize_Non_Zeroed:
		ptr := MemRealloc(old_memory, c.uint(size))
		if ptr == nil {
			err = .Out_Of_Memory
			return
		}
		data = mem.byte_slice(ptr, size)
		return
	
	case .Free_All, .Query_Features, .Query_Info:
		return nil, .Mode_Not_Implemented
	}	
	return nil, .Mode_Not_Implemented
}

// RayLib 5.5 renamed Is*Ready to Is*Valid.
// See: https://github.com/raysan5/raylib/commit/8cbf34ddc495e2bca42245f786915c27210b0507
IsImageReady         :: IsImageValid
IsTextureReady       :: IsTextureValid
IsRenderTextureReady :: IsRenderTextureValid
IsFontReady          :: IsFontValid
IsModelReady         :: IsModelValid
IsMaterialReady      :: IsMaterialValid
IsWaveReady          :: IsWaveValid
IsSoundReady         :: IsSoundValid
IsMusicReady         :: IsMusicValid
IsAudioStreamReady   :: IsAudioStreamValid
IsShaderReady        :: IsShaderValid
