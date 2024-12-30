/**********************************************************************************************
*
*   rlgl v5.0 - A multi-OpenGL abstraction layer with an immediate-mode style API
*
*   DESCRIPTION:
*       An abstraction layer for multiple OpenGL versions (1.1, 2.1, 3.3 Core, 4.3 Core, ES 2.0)
*       that provides a pseudo-OpenGL 1.1 immediate-mode style API (rlVertex, rlTranslate, rlRotate...)
*
*   ADDITIONAL NOTES:
*       When choosing an OpenGL backend different than OpenGL 1.1, some internal buffer are
*       initialized on rlglInit() to accumulate vertex data.
*
*       When an internal state change is required all the stored vertex data is renderer in batch,
*       additionally, rlDrawRenderBatchActive() could be called to force flushing of the batch.
*
*       Some resources are also loaded for convenience, here the complete list:
*          - Default batch (RLGL.defaultBatch): RenderBatch system to accumulate vertex data
*          - Default texture (RLGL.defaultTextureId): 1x1 white pixel R8G8B8A8
*          - Default shader (RLGL.State.defaultShaderId, RLGL.State.defaultShaderLocs)
*
*       Internal buffer (and resources) must be manually unloaded calling rlglClose().
*
*   CONFIGURATION:
*       #define GRAPHICS_API_OPENGL_11
*       #define GRAPHICS_API_OPENGL_21
*       #define GRAPHICS_API_OPENGL_33
*       #define GRAPHICS_API_OPENGL_43
*       #define GRAPHICS_API_OPENGL_ES2
*       #define GRAPHICS_API_OPENGL_ES3
*           Use selected OpenGL graphics backend, should be supported by platform
*           Those preprocessor defines are only used on rlgl module, if OpenGL version is
*           required by any other module, use rlGetVersion() to check it
*
*       #define RLGL_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*       #define RLGL_RENDER_TEXTURES_HINT
*           Enable framebuffer objects (fbo) support (enabled by default)
*           Some GPUs could not support them despite the OpenGL version
*
*       #define RLGL_SHOW_GL_DETAILS_INFO
*           Show OpenGL extensions and capabilities detailed logs on init
*
*       #define RLGL_ENABLE_OPENGL_DEBUG_CONTEXT
*           Enable debug context (only available on OpenGL 4.3)
*
*       rlgl capabilities could be customized just defining some internal
*       values before library inclusion (default values listed):
*
*       #define RL_DEFAULT_BATCH_BUFFER_ELEMENTS   8192    // Default internal render batch elements limits
*       #define RL_DEFAULT_BATCH_BUFFERS              1    // Default number of batch buffers (multi-buffering)
*       #define RL_DEFAULT_BATCH_DRAWCALLS          256    // Default number of batch draw calls (by state changes: mode, texture)
*       #define RL_DEFAULT_BATCH_MAX_TEXTURE_UNITS    4    // Maximum number of textures units that can be activated on batch drawing (SetShaderValueTexture())
*
*       #define RL_MAX_MATRIX_STACK_SIZE             32    // Maximum size of internal Matrix stack
*       #define RL_MAX_SHADER_LOCATIONS              32    // Maximum number of shader locations supported
*       #define RL_CULL_DISTANCE_NEAR              0.01    // Default projection matrix near cull distance
*       #define RL_CULL_DISTANCE_FAR             1000.0    // Default projection matrix far cull distance
*
*       When loading a shader, the following vertex attributes and uniform
*       location names are tried to be set automatically:
*
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_POSITION     "vertexPosition"    // Bound by default to shader location: 0
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD     "vertexTexCoord"    // Bound by default to shader location: 1
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_NORMAL       "vertexNormal"      // Bound by default to shader location: 2
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_COLOR        "vertexColor"       // Bound by default to shader location: 3
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_TANGENT      "vertexTangent"     // Bound by default to shader location: 4
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD2    "vertexTexCoord2"   // Bound by default to shader location: 5
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_MVP         "mvp"               // model-view-projection matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_VIEW        "matView"           // view matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_PROJECTION  "matProjection"     // projection matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_MODEL       "matModel"          // model matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_NORMAL      "matNormal"         // normal matrix (transpose(inverse(matModelView))
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_COLOR       "colDiffuse"        // color diffuse (base tint color, multiplied by texture color)
*       #define RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE0  "texture0"          // texture0 (texture slot active 0)
*       #define RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE1  "texture1"          // texture1 (texture slot active 1)
*       #define RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE2  "texture2"          // texture2 (texture slot active 2)
*
*   DEPENDENCIES:
*      - OpenGL libraries (depending on platform and OpenGL version selected)
*      - GLAD OpenGL extensions loading library (only for OpenGL 3.3 Core, 4.3 Core)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
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
**********************************************************************************************/


package rlgl

import "core:c"
import rl "../."

VERSION :: "5.0"

RAYLIB_SHARED :: #config(RAYLIB_SHARED, false)

GRAPHICS_API_OPENGL_11  :: false
GRAPHICS_API_OPENGL_21  :: true
GRAPHICS_API_OPENGL_33  :: GRAPHICS_API_OPENGL_21 // default currently
GRAPHICS_API_OPENGL_ES2 :: false
GRAPHICS_API_OPENGL_43  :: false
GRAPHICS_API_OPENGL_ES3 :: false

when GRAPHICS_API_OPENGL_ES3 {
	GRAPHICS_API_OPENGL_ES2 :: true
}
 
when !GRAPHICS_API_OPENGL_ES2 {
	// This is the maximum amount of elements (quads) per batch
	// NOTE: Be careful with text, every letter maps to a quad
	DEFAULT_BATCH_BUFFER_ELEMENTS :: 8192
} else {
	// We reduce memory sizes for embedded systems (RPI and HTML5)
	// NOTE: On HTML5 (emscripten) this is allocated on heap,
	// by default it's only 16MB!...just take care...
	DEFAULT_BATCH_BUFFER_ELEMENTS :: 2048
}

DEFAULT_BATCH_BUFFERS            :: 1                    // Default number of batch buffers (multi-buffering)
DEFAULT_BATCH_DRAWCALLS          :: 256                  // Default number of batch draw calls (by state changes: mode, texture)
DEFAULT_BATCH_MAX_TEXTURE_UNITS  :: 4                    // Maximum number of additional textures that can be activated on batch drawing (SetShaderValueTexture())

// Internal Matrix stack
MAX_MATRIX_STACK_SIZE          :: 32                   // Maximum size of Matrix stack

// Shader limits
MAX_SHADER_LOCATIONS           :: 32                   // Maximum number of shader locations supported

// Projection matrix culling
CULL_DISTANCE_NEAR          :: 0.01                 // Default near cull distance
CULL_DISTANCE_FAR           :: 1000.0               // Default far cull distance

// Texture parameters (equivalent to OpenGL defines)
TEXTURE_WRAP_S                       :: 0x2802      // GL_TEXTURE_WRAP_S
TEXTURE_WRAP_T                       :: 0x2803      // GL_TEXTURE_WRAP_T
TEXTURE_MAG_FILTER                   :: 0x2800      // GL_TEXTURE_MAG_FILTER
TEXTURE_MIN_FILTER                   :: 0x2801      // GL_TEXTURE_MIN_FILTER

TEXTURE_FILTER_NEAREST               :: 0x2600      // GL_NEAREST
TEXTURE_FILTER_LINEAR                :: 0x2601      // GL_LINEAR
TEXTURE_FILTER_MIP_NEAREST           :: 0x2700      // GL_NEAREST_MIPMAP_NEAREST
TEXTURE_FILTER_NEAREST_MIP_LINEAR    :: 0x2702      // GL_NEAREST_MIPMAP_LINEAR
TEXTURE_FILTER_LINEAR_MIP_NEAREST    :: 0x2701      // GL_LINEAR_MIPMAP_NEAREST
TEXTURE_FILTER_MIP_LINEAR            :: 0x2703      // GL_LINEAR_MIPMAP_LINEAR
TEXTURE_FILTER_ANISOTROPIC           :: 0x3000      // Anisotropic filter (custom identifier)

TEXTURE_WRAP_REPEAT                  :: 0x2901      // GL_REPEAT
TEXTURE_WRAP_CLAMP                   :: 0x812F      // GL_CLAMP_TO_EDGE
TEXTURE_WRAP_MIRROR_REPEAT           :: 0x8370      // GL_MIRRORED_REPEAT
TEXTURE_WRAP_MIRROR_CLAMP            :: 0x8742      // GL_MIRROR_CLAMP_EXT

// Matrix modes (equivalent to OpenGL)
MODELVIEW                            :: 0x1700      // GL_MODELVIEW
PROJECTION                           :: 0x1701      // GL_PROJECTION
TEXTURE                              :: 0x1702      // GL_TEXTURE

// Primitive assembly draw modes
LINES                                :: 0x0001      // GL_LINES
TRIANGLES                            :: 0x0004      // GL_TRIANGLES
QUADS                                :: 0x0007      // GL_QUADS

// GL equivalent data types
UNSIGNED_BYTE                        :: 0x1401      // GL_UNSIGNED_BYTE
FLOAT                                :: 0x1406      // GL_FLOAT

// Buffer usage hint
STREAM_DRAW                          :: 0x88E0      // GL_STREAM_DRAW
STREAM_READ                          :: 0x88E1      // GL_STREAM_READ
STREAM_COPY                          :: 0x88E2      // GL_STREAM_COPY
STATIC_DRAW                          :: 0x88E4      // GL_STATIC_DRAW
STATIC_READ                          :: 0x88E5      // GL_STATIC_READ
STATIC_COPY                          :: 0x88E6      // GL_STATIC_COPY
DYNAMIC_DRAW                         :: 0x88E8      // GL_DYNAMIC_DRAW
DYNAMIC_READ                         :: 0x88E9      // GL_DYNAMIC_READ
DYNAMIC_COPY                         :: 0x88EA      // GL_DYNAMIC_COPY

// GL Shader type
FRAGMENT_SHADER                      :: 0x8B30      // GL_FRAGMENT_SHADER
VERTEX_SHADER                        :: 0x8B31      // GL_VERTEX_SHADER
COMPUTE_SHADER                       :: 0x91B9      // GL_COMPUTE_SHADER

// GL blending factors
ZERO                                 :: 0           // GL_ZERO
ONE                                  :: 1           // GL_ONE
SRC_COLOR                            :: 0x0300      // GL_SRC_COLOR
ONE_MINUS_SRC_COLOR                  :: 0x0301      // GL_ONE_MINUS_SRC_COLOR
SRC_ALPHA                            :: 0x0302      // GL_SRC_ALPHA
ONE_MINUS_SRC_ALPHA                  :: 0x0303      // GL_ONE_MINUS_SRC_ALPHA
DST_ALPHA                            :: 0x0304      // GL_DST_ALPHA
ONE_MINUS_DST_ALPHA                  :: 0x0305      // GL_ONE_MINUS_DST_ALPHA
DST_COLOR                            :: 0x0306      // GL_DST_COLOR
ONE_MINUS_DST_COLOR                  :: 0x0307      // GL_ONE_MINUS_DST_COLOR
SRC_ALPHA_SATURATE                   :: 0x0308      // GL_SRC_ALPHA_SATURATE
CONSTANT_COLOR                       :: 0x8001      // GL_CONSTANT_COLOR
ONE_MINUS_CONSTANT_COLOR             :: 0x8002      // GL_ONE_MINUS_CONSTANT_COLOR
CONSTANT_ALPHA                       :: 0x8003      // GL_CONSTANT_ALPHA
ONE_MINUS_CONSTANT_ALPHA             :: 0x8004      // GL_ONE_MINUS_CONSTANT_ALPHA

// GL blending functions/equations
FUNC_ADD                             :: 0x8006      // GL_FUNC_ADD
MIN                                  :: 0x8007      // GL_MIN
MAX                                  :: 0x8008      // GL_MAX
FUNC_SUBTRACT                        :: 0x800A      // GL_FUNC_SUBTRACT
FUNC_REVERSE_SUBTRACT                :: 0x800B      // GL_FUNC_REVERSE_SUBTRACT
BLEND_EQUATION                       :: 0x8009      // GL_BLEND_EQUATION
BLEND_EQUATION_RGB                   :: 0x8009      // GL_BLEND_EQUATION_RGB   // (Same as BLEND_EQUATION)
BLEND_EQUATION_ALPHA                 :: 0x883D      // GL_BLEND_EQUATION_ALPHA
BLEND_DST_RGB                        :: 0x80C8      // GL_BLEND_DST_RGB
BLEND_SRC_RGB                        :: 0x80C9      // GL_BLEND_SRC_RGB
BLEND_DST_ALPHA                      :: 0x80CA      // GL_BLEND_DST_ALPHA
BLEND_SRC_ALPHA                      :: 0x80CB      // GL_BLEND_SRC_ALPHA
BLEND_COLOR                          :: 0x8005      // GL_BLEND_COLOR

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------


VertexBufferIndexType :: c.ushort when GRAPHICS_API_OPENGL_ES2 else c.uint

// Dynamic vertex buffers (position + texcoords + colors + indices arrays)
VertexBuffer :: struct {
	elementCount: c.int,                 // Number of elements in the buffer (QUADS)

	vertices:  [^]f32,                   // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
	texcoords: [^]f32,                   // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
	colors:    [^]u8,                    // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
	indices:   [^]VertexBufferIndexType, // Vertex indices (in case vertex data comes indexed) (6 indices per quad)
	vaoId:     c.uint,                   // OpenGL Vertex Array Object id
	vboId:     [4]c.uint,                // OpenGL Vertex Buffer Objects id (4 types of vertex data)
}

// Draw call type
// NOTE: Only texture changes register a new draw, other state-change-related elements are not
// used at this moment (vaoId, shaderId, matrices), raylib just forces a batch draw call if any
// of those state-change happens (this is done in core module)
DrawCall :: struct {
	mode:            c.int,        // Drawing mode: LINES, TRIANGLES, QUADS
	vertexCount:     c.int,        // Number of vertex of the draw
	vertexAlignment: c.int,        // Number of vertex required for index alignment (LINES, TRIANGLES)
	textureId:       c.uint,       // Texture id to be used on the draw -> Use to create new draw call if changes
}

// RenderBatch type
RenderBatch :: struct {
	bufferCount:   c.int,           // Number of vertex buffers (multi-buffering support)
	currentBuffer: c.int,           // Current buffer tracking in case of multi-buffering
	vertexBuffer:  [^]VertexBuffer, // Dynamic buffer(s) for vertex data

	draws:         [^]DrawCall,     // Draw calls array, depends on textureId
	drawCounter:   c.int,           // Draw calls counter
	currentDepth:  f32,             // Current depth value for next draw
}

// OpenGL version
GlVersion :: enum c.int {
	OPENGL_11 = 1,           // OpenGL 1.1
	OPENGL_21,               // OpenGL 2.1 (GLSL 120)
	OPENGL_33,               // OpenGL 3.3 (GLSL 330)
	OPENGL_43,               // OpenGL 4.3 (using GLSL 330)
	OPENGL_ES_20,            // OpenGL ES 2.0 (GLSL 100)
	OPENGL_ES_30,            // OpenGL ES 3.0 (GLSL 300 es)
}

PixelFormat :: rl.PixelFormat
TextureFilter :: rl.TextureFilter
BlendMode :: rl.BlendMode
ShaderLocationIndex :: rl.ShaderLocationIndex
ShaderUniformDataType :: rl.ShaderUniformDataType

// Shader attribute data types
ShaderAttributeDataType :: enum c.int {
	FLOAT = 0,         // Shader attribute type: float
	VEC2,              // Shader attribute type: vec2 (2 float)
	VEC3,              // Shader attribute type: vec3 (3 float)
	VEC4,              // Shader attribute type: vec4 (4 float)
}

// Framebuffer attachment type
// NOTE: By default up to 8 color channels defined, but it can be more
FramebufferAttachType :: enum c.int {
	COLOR_CHANNEL0 = 0,   // Framebuffer attachment type: color 0
	COLOR_CHANNEL1 = 1,   // Framebuffer attachment type: color 1
	COLOR_CHANNEL2 = 2,   // Framebuffer attachment type: color 2
	COLOR_CHANNEL3 = 3,   // Framebuffer attachment type: color 3
	COLOR_CHANNEL4 = 4,   // Framebuffer attachment type: color 4
	COLOR_CHANNEL5 = 5,   // Framebuffer attachment type: color 5
	COLOR_CHANNEL6 = 6,   // Framebuffer attachment type: color 6
	COLOR_CHANNEL7 = 7,   // Framebuffer attachment type: color 7
	DEPTH = 100,          // Framebuffer attachment type: depth
	STENCIL = 200,        // Framebuffer attachment type: stencil
}

// Framebuffer texture attachment type
FramebufferAttachTextureType :: enum c.int {
	CUBEMAP_POSITIVE_X = 0, // Framebuffer texture attachment type: cubemap, +X side
	CUBEMAP_NEGATIVE_X = 1, // Framebuffer texture attachment type: cubemap, -X side
	CUBEMAP_POSITIVE_Y = 2, // Framebuffer texture attachment type: cubemap, +Y side
	CUBEMAP_NEGATIVE_Y = 3, // Framebuffer texture attachment type: cubemap, -Y side
	CUBEMAP_POSITIVE_Z = 4, // Framebuffer texture attachment type: cubemap, +Z side
	CUBEMAP_NEGATIVE_Z = 5, // Framebuffer texture attachment type: cubemap, -Z side
	TEXTURE2D = 100,        // Framebuffer texture attachment type: texture2d
	RENDERBUFFER = 200,     // Framebuffer texture attachment type: renderbuffer
}

CullMode :: enum c.int {
	FRONT = 0,
	BACK,
}

Matrix :: rl.Matrix
