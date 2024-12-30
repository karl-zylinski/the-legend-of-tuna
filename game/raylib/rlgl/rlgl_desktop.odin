#+build !freestanding
#+build !js
#+build !orca

package rlgl

import "core:c"


// Note: We pull in the full raylib library. If you want a truly stand-alone rlgl, then:
// - Compile a separate rlgl library and use that in the foreign import blocks below.
// - Remove the `import rl "../."` line
// - Copy the code from raylib.odin for any types we alias from that package (see PixelFormat etc)

when ODIN_OS == .Windows {
	@(extra_linker_flags="/NODEFAULTLIB:" + ("msvcrt" when RAYLIB_SHARED else "libcmt"))
	foreign import lib {
		"../windows/raylibdll.lib" when RAYLIB_SHARED else "../windows/raylib.lib" ,
		"system:Winmm.lib",
		"system:Gdi32.lib",
		"system:User32.lib",
		"system:Shell32.lib",
	}
} else when ODIN_OS == .Linux  {
	foreign import lib {
		// Note(bumbread): I'm not sure why in `linux/` folder there are
		// multiple copies of raylib.so, but since these bindings are for
		// particular version of the library, I better specify it. Ideally,
		// though, it's best specified in terms of major (.so.4)
		"../linux/libraylib.so.550" when RAYLIB_SHARED else "../linux/libraylib.a",
		"system:dl",
		"system:pthread",
	}
} else when ODIN_OS == .Darwin {
	foreign import lib {
		"../macos/libraylib.550.dylib" when RAYLIB_SHARED else "../macos/libraylib.a",
		"system:Cocoa.framework",
		"system:OpenGL.framework",
		"system:IOKit.framework",
	} 
} else {
	foreign import lib "system:raylib"
}


@(default_calling_convention="c", link_prefix="rl")
foreign lib {
	//------------------------------------------------------------------------------------
	// Functions Declaration - Matrix operations
	//------------------------------------------------------------------------------------
	MatrixMode   :: proc(mode: c.int) ---                 // Choose the current matrix to be transformed
	PushMatrix   :: proc() ---                            // Push the current matrix to stack
	PopMatrix    :: proc() ---                            // Pop lattest inserted matrix from stack
	LoadIdentity :: proc() ---                            // Reset current matrix to identity matrix
	Translatef   :: proc(x, y, z: f32) ---                // Multiply the current matrix by a translation matrix
	Rotatef      :: proc(angleDeg: f32, x, y, z: f32) --- // Multiply the current matrix by a rotation matrix
	Scalef       :: proc(x, y, z: f32) ---                // Multiply the current matrix by a scaling matrix
	MultMatrixf  :: proc(matf: [^]f32) ---                // Multiply the current matrix by another matrix
	Frustum      :: proc(left, right, bottom, top, znear, zfar: f64) ---
	Ortho        :: proc(left, right, bottom, top, znear, zfar: f64) ---
	Viewport     :: proc(x, y, width, height: c.int) ---  // Set the viewport area

	//------------------------------------------------------------------------------------
	// Functions Declaration - Vertex level operations
	//------------------------------------------------------------------------------------
	Begin        :: proc(mode: c.int)     --- // Initialize drawing mode (how to organize vertex)
	End          :: proc()                --- // Finish vertex providing
	Vertex2i     :: proc(x, y: c.int)     --- // Define one vertex (position) - 2 int
	Vertex2f     :: proc(x, y: f32)       --- // Define one vertex (position) - 2 f32
	Vertex3f     :: proc(x, y, z: f32)    --- // Define one vertex (position) - 3 f32
	TexCoord2f   :: proc(x, y: f32)       --- // Define one vertex (texture coordinate) - 2 f32
	Normal3f     :: proc(x, y, z: f32)    --- // Define one vertex (normal) - 3 f32
	Color4ub     :: proc(r, g, b, a: u8)  --- // Define one vertex (color) - 4 byte
	Color3f      :: proc(x, y, z: f32)    --- // Define one vertex (color) - 3 f32
	Color4f      :: proc(x, y, z, w: f32) --- // Define one vertex (color) - 4 f32

	//------------------------------------------------------------------------------------
	// Functions Declaration - OpenGL style functions (common to 1.1, 3.3+, ES2)
	// NOTE: This functions are used to completely abstract raylib code from OpenGL layer,
	// some of them are direct wrappers over OpenGL calls, some others are custom
	//------------------------------------------------------------------------------------

	// Vertex buffers state
	EnableVertexArray          :: proc(vaoId: c.uint) -> bool --- // Enable vertex array (VAO, if supported)
	DisableVertexArray         :: proc() ---                      // Disable vertex array (VAO, if supported)
	EnableVertexBuffer         :: proc(id: c.uint) ---            // Enable vertex buffer (VBO)
	DisableVertexBuffer        :: proc() ---                      // Disable vertex buffer (VBO)
	EnableVertexBufferElement  :: proc(id: c.uint) ---            // Enable vertex buffer element (VBO element)
	DisableVertexBufferElement :: proc() ---                      // Disable vertex buffer element (VBO element)
	EnableVertexAttribute      :: proc(index: c.uint) ---         // Enable vertex attribute index
	DisableVertexAttribute     :: proc(index: c.uint) ---         // Disable vertex attribute index
	when GRAPHICS_API_OPENGL_11 {
		EnableStatePointer :: proc(vertexAttribType: c.int, buffer: rawptr) ---
		DisableStatePointer :: proc(vertexAttribType: c.int) ---
	}

	// Textures state
	ActiveTextureSlot     :: proc(slot: c.int) ---                            // Select and active a texture slot
	EnableTexture         :: proc(id: c.uint) ---                             // Enable texture
	DisableTexture        :: proc() ---                                       // Disable texture
	EnableTextureCubemap  :: proc(id: c.uint) ---                             // Enable texture cubemap
	DisableTextureCubemap :: proc() ---                                       // Disable texture cubemap
	TextureParameters     :: proc(id: c.uint, param: c.int, value: c.int) --- // Set texture parameters (filter, wrap)
	CubemapParameters     :: proc(id: i32, param: c.int, value: c.int) ---    // Set cubemap parameters (filter, wrap)

	// Shader state
	EnableShader  :: proc(id: c.uint) ---                                       // Enable shader program
	DisableShader :: proc() ---                                                 // Disable shader program

	// Framebuffer state
	EnableFramebuffer  :: proc(id: c.uint) ---                                  // Enable render texture (fbo)
	DisableFramebuffer :: proc() ---                                            // Disable render texture (fbo), return to default framebuffer
	ActiveDrawBuffers  :: proc(count: c.int) ---                                // Activate multiple draw color buffers
	BlitFramebuffer	 :: proc(srcX, srcY, srcWidth, srcHeight, dstX, dstY, dstWidth, dstHeight, bufferMask: c.int) --- // Blit active framebuffer to main framebuffer

	// General render state
	EnableColorBlend       :: proc() ---                           // Enable color blending
	DisableColorBlend      :: proc() ---                           // Disable color blending
	EnableDepthTest        :: proc() ---                           // Enable depth test
	DisableDepthTest       :: proc() ---                           // Disable depth test
	EnableDepthMask        :: proc() ---                           // Enable depth write
	DisableDepthMask       :: proc() ---                           // Disable depth write
	EnableBackfaceCulling  :: proc() ---                           // Enable backface culling
	DisableBackfaceCulling :: proc() ---                           // Disable backface culling
	SetCullFace            :: proc(mode: CullMode) ---             // Set face culling mode
	EnableScissorTest      :: proc() ---                           // Enable scissor test
	DisableScissorTest     :: proc() ---                           // Disable scissor test
	Scissor                :: proc(x, y, width, height: c.int) --- // Scissor test
	EnableWireMode         :: proc() ---                           // Enable wire mode
	EnablePointMode        :: proc() --- 							 // Enable point mode
	DisableWireMode        :: proc() ---                           // Disable wire and point modes
	SetLineWidth           :: proc(width: f32) ---                 // Set the line drawing width
	GetLineWidth           :: proc() -> f32 ---                    // Get the line drawing width
	EnableSmoothLines      :: proc() ---                           // Enable line aliasing
	DisableSmoothLines     :: proc() ---                           // Disable line aliasing
	EnableStereoRender     :: proc() ---                           // Enable stereo rendering
	DisableStereoRender    :: proc() ---                           // Disable stereo rendering
	IsStereoRenderEnabled  :: proc() -> bool ---                   // Check if stereo render is enabled


	ClearColor              :: proc(r, g, b, a: u8) ---                                                        // Clear color buffer with color
	ClearScreenBuffers      :: proc() ---                                                                      // Clear used screen buffers (color and depth)
	CheckErrors             :: proc() ---                                                                      // Check and log OpenGL error codes
	SetBlendMode            :: proc(mode: c.int) ---                                                           // Set blending mode
	SetBlendFactors         :: proc(glSrcFactor, glDstFactor, glEquation: c.int) ---                           // Set blending mode factor and equation (using OpenGL factors)
	SetBlendFactorsSeparate :: proc(glSrcRGB, glDstRGB, glSrcAlpha, glDstAlpha, glEqRGB, glEqAlpha: c.int) --- // Set blending mode factors and equations separately (using OpenGL factors)

	//------------------------------------------------------------------------------------
	// Functions Declaration - rlgl functionality
	//------------------------------------------------------------------------------------
	// rlgl initialization functions
	@(link_prefix="rlgl")
	Init                 :: proc(width, height: c.int) --- // Initialize rlgl (buffers, shaders, textures, states)
	@(link_prefix="rlgl")
	Close                :: proc() ---                     // De-initialize rlgl (buffers, shaders, textures)
	LoadExtensions       :: proc(loader: rawptr) ---       // Load OpenGL extensions (loader function required)
	GetVersion           :: proc() -> GlVersion ---        // Get current OpenGL version
	SetFramebufferWidth  :: proc(width: c.int) ---         // Set current framebuffer width
	GetFramebufferWidth  :: proc() -> c.int ---            // Get default framebuffer width
	SetFramebufferHeight :: proc(height: c.int) ---        // Set current framebuffer height
	GetFramebufferHeight :: proc() -> c.int ---            // Get default framebuffer height


	GetTextureIdDefault  :: proc() -> c.uint ---   // Get default texture id
	GetShaderIdDefault   :: proc() -> c.uint ---   // Get default shader id
	GetShaderLocsDefault :: proc() -> [^]c.int --- // Get default shader locations

	// Render batch management
	// NOTE: rlgl provides a default render batch to behave like OpenGL 1.1 immediate mode
	// but this render batch API is exposed in case of custom batches are required
	LoadRenderBatch       :: proc(numBuffers, bufferElements: c.int) -> RenderBatch --- // Load a render batch system
	UnloadRenderBatch     :: proc(batch: RenderBatch) ---                               // Unload render batch system
	DrawRenderBatch       :: proc(batch: ^RenderBatch) ---                              // Draw render batch data (Update->Draw->Reset)
	SetRenderBatchActive  :: proc(batch: ^RenderBatch) ---                              // Set the active render batch for rlgl (NULL for default internal)
	DrawRenderBatchActive :: proc() ---                                                 // Update and draw internal render batch
	CheckRenderBatchLimit :: proc(vCount: c.int) -> c.int ---                           // Check internal buffer overflow for a given number of vertex

	SetTexture :: proc(id: c.uint) --- // Set current texture for render batch and check buffers limits

	//------------------------------------------------------------------------------------------------------------------------

	// Vertex buffers management
	LoadVertexArray                  :: proc() -> c.uint ---                                                      // Load vertex array (vao) if supported
	LoadVertexBuffer                 :: proc(buffer: rawptr, size: c.int, is_dynamic: bool) -> c.uint ---         // Load a vertex buffer attribute
	LoadVertexBufferElement          :: proc(buffer: rawptr, size: c.int, is_dynamic: bool) -> c.uint ---         // Load a new attributes element buffer
	UpdateVertexBuffer               :: proc(bufferId: c.uint, data: rawptr, dataSize: c.int, offset: c.int) ---  // Update GPU buffer with new data
	UpdateVertexBufferElements       :: proc(id: c.uint, data: rawptr, dataSize: c.int, offset: c.int) ---        // Update vertex buffer elements with new data
	UnloadVertexArray                :: proc(vaoId: c.uint) ---
	UnloadVertexBuffer               :: proc(vboId: c.uint) ---
	SetVertexAttribute               :: proc(index: c.uint, compSize: c.int, type: c.int, normalized: bool, stride: c.int, pointer: rawptr) ---
	SetVertexAttributeDivisor        :: proc(index: c.uint, divisor: c.int) ---
	SetVertexAttributeDefault        :: proc(locIndex: c.int, value: rawptr, attribType: c.int, count: c.int) --- // Set vertex attribute default value
	DrawVertexArray                  :: proc(offset: c.int, count: c.int) ---
	DrawVertexArrayElements          :: proc(offset: c.int, count: c.int, buffer: rawptr) ---
	DrawVertexArrayInstanced         :: proc(offset: c.int, count: c.int, instances: c.int) ---
	DrawVertexArrayElementsInstanced :: proc(offset: c.int, count: c.int, buffer: rawptr, instances: c.int) ---

	// Textures management
	LoadTexture         :: proc(data: rawptr, width, height: c.int, format: c.int, mipmapCount: c.int) -> c.uint ---        // Load texture in GPU
	LoadTextureDepth    :: proc(width, height: c.int, useRenderBuffer: bool) -> c.uint ---                                  // Load depth texture/renderbuffer (to be attached to fbo)
	LoadTextureCubemap  :: proc(data: rawptr, size: c.int, format: c.int) -> c.uint ---                                     // Load texture cubemap
	UpdateTexture       :: proc(id: c.uint, offsetX, offsetY: c.int, width, height: c.int, format: c.int, data: rawptr) --- // Update GPU texture with new data
	GetGlTextureFormats :: proc(format: c.int, glInternalFormat, glFormat, glType: ^c.uint) ---                             // Get OpenGL internal formats
	GetPixelFormatName  :: proc(format: c.uint) -> cstring ---                                                              // Get name string for pixel format
	UnloadTexture       :: proc(id: c.uint) ---                                                                             // Unload texture from GPU memory
	GenTextureMipmaps   :: proc(id: c.uint, width, height: c.int, format: c.int, mipmaps: ^c.int) ---                       // Generate mipmap data for selected texture
	ReadTexturePixels   :: proc(id: c.uint, width, height: c.int, format: c.int) -> rawptr ---                              // Read texture pixel data
	ReadScreenPixels    :: proc(width, height: c.int) -> [^]byte ---                                                        // Read screen pixel data (color buffer)

	// Framebuffer management (fbo)
	LoadFramebuffer     :: proc(width, height: c.int) -> c.uint ---                                           // Load an empty framebuffer
	FramebufferAttach   :: proc(fboId, texId: c.uint, attachType: c.int, texType: c.int, mipLevel: c.int) --- // Attach texture/renderbuffer to a framebuffer
	FramebufferComplete :: proc(id: c.uint) -> bool ---                                                       // Verify framebuffer is complete
	UnloadFramebuffer   :: proc(id: c.uint) ---                                                               // Delete framebuffer from GPU

	// Shaders management
	LoadShaderCode      :: proc(vsCode, fsCode: cstring) -> c.uint ---                                // Load shader from code strings
	CompileShader       :: proc(shaderCode: cstring, type: c.int) -> c.uint ---                       // Compile custom shader and return shader id (type: VERTEX_SHADER, FRAGMENT_SHADER, COMPUTE_SHADER)
	LoadShaderProgram   :: proc(vShaderId, fShaderId: c.uint) -> c.uint ---                           // Load custom shader program
	UnloadShaderProgram :: proc(id: c.uint) ---                                                       // Unload shader program
	GetLocationUniform  :: proc(shaderId: c.uint, uniformName: cstring) -> c.int ---                  // Get shader location uniform
	GetLocationAttrib   :: proc(shaderId: c.uint, attribName: cstring) -> c.int ---                   // Get shader location attribute
	SetUniform          :: proc(locIndex: c.int, value: rawptr, uniformType: c.int, count: c.int) --- // Set shader value uniform
	SetUniformMatrix    :: proc(locIndex: c.int, mat: Matrix) ---                                     // Set shader value matrix
	SetUniformSampler   :: proc(locIndex: c.int, textureId: c.uint) ---                               // Set shader value sampler
	SetShader           :: proc(id: c.uint, locs: [^]c.int) ---                                       // Set shader currently active (id and locations)

	// Compute shader management
	LoadComputeShaderProgram :: proc(shaderId: c.uint) -> c.uint ---     // Load compute shader program
	ComputeShaderDispatch    :: proc(groupX, groupY, groupZ: c.uint) --- // Dispatch compute shader (equivalent to *draw* for graphics pipeline)

	// Shader buffer storage object management (ssbo)
	LoadShaderBuffer    :: proc(size: c.uint, data: rawptr, usageHint: c.int) -> c.uint ---              // Load shader storage buffer object (SSBO)
	UnloadShaderBuffer  :: proc(ssboId: c.uint) ---                                                      // Unload shader storage buffer object (SSBO)
	UpdateShaderBuffer  :: proc(id: c.uint, data: rawptr, dataSize: c.uint, offset: c.uint) ---          // Update SSBO buffer data
	BindShaderBuffer    :: proc(id: c.uint, index: c.uint) ---                                           // Bind SSBO buffer
	ReadShaderBuffer    :: proc(id: c.uint, dest: rawptr, count: c.uint, offset: c.uint) ---             // Read SSBO buffer data (GPU->CPU)
	CopyShaderBuffer    :: proc(destId, srcId: c.uint, destOffset, srcOffset: c.uint, count: c.uint) --- // Copy SSBO data between buffers
	GetShaderBufferSize :: proc(id: c.uint) -> c.uint ---                                                // Get SSBO buffer size

	// Buffer management
	BindImageTexture :: proc(id: c.uint, index: c.uint, format: c.int, readonly: bool) ---  // Bind image texture

	// Matrix state management
	GetMatrixModelview        :: proc() -> Matrix ---           // Get internal modelview matrix
	GetMatrixProjection       :: proc() -> Matrix ---           // Get internal projection matrix
	GetMatrixTransform        :: proc() -> Matrix ---           // Get internal accumulated transform matrix
	GetMatrixProjectionStereo :: proc(eye: c.int) -> Matrix --- // Get internal projection matrix for stereo render (selected eye)
	GetMatrixViewOffsetStereo :: proc(eye: c.int) -> Matrix --- // Get internal view offset matrix for stereo render (selected eye)
	SetMatrixProjection       :: proc(proj: Matrix) ---         // Set a custom projection matrix (replaces internal projection matrix)
	SetMatrixModelview        :: proc(view: Matrix) ---         // Set a custom modelview matrix (replaces internal modelview matrix)
	SetMatrixProjectionStereo :: proc(right, left: Matrix) ---  // Set eyes projection matrices for stereo rendering
	SetMatrixViewOffsetStereo :: proc(right, left: Matrix) ---  // Set eyes view offsets matrices for stereo rendering

	// Quick and dirty cube/quad buffers load->draw->unload
	LoadDrawCube :: proc() --- // Load and draw a cube
	LoadDrawQuad :: proc() --- // Load and draw a quad
}

