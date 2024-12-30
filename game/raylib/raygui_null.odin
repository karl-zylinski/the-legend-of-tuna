#+build freestanding
package raylib

import "core:c"

//----------------------------------------------------------------------------------
// Module Functions Declaration
//----------------------------------------------------------------------------------

@(default_calling_convention="c")
foreign {
	// WASM does not have foreign variable declarations.
	when ODIN_ARCH != .wasm32 && ODIN_ARCH != .wasm64p32 {
		@(link_name="raylib_version") version: cstring
	}
	// Global gui state control functions
	
	GuiEnable           :: proc() ---                                                                         // Enable gui controls (global state)
	GuiLock             :: proc() ---                                                                         // Lock gui controls (global state)
	GuiDisable          :: proc() ---                                                                         // Disable gui controls (global state)
	GuiUnlock           :: proc() ---                                                                         // Unlock gui controls (global state)
	GuiIsLocked         :: proc() -> bool ---                                                                 // Check if gui is locked (global state)
	GuiSetAlpha         :: proc(alpha: f32) ---                                                               // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
	GuiSetState         :: proc(state: c.int) ---                                                             // Set gui state (global state)
	GuiGetState         :: proc() -> c.int ---                                                                // Get gui state (global state)
	
	// Font set/get functions
	
	GuiSetFont          :: proc(font: Font) ---                                                               // Set gui custom font (global state)
	GuiGetFont          :: proc() -> Font ---                                                                 // Get gui custom font (global state)
	
	// Style set/get functions
	
	GuiSetStyle         :: proc(control: GuiControl, property: c.int, value: c.int) ---          // Set one style property
	GuiGetStyle         :: proc(control: GuiControl, property: c.int) -> c.int ---               // Get one style property
	
	// Styles loading functions
	
	GuiLoadStyle        :: proc(fileName: cstring) ---                                                        // Load style file over global style variable (.rgs)
	GuiLoadStyleDefault :: proc() ---                                                                         // Load style default over global style
	
	// Tooltips management functions
	
	GuiEnableTooltip    :: proc() ---                                                                         // Enable gui tooltips (global state)
	GuiDisableTooltip   :: proc() ---                                                                         // Disable gui tooltips (global state)
	GuiSetTooltip       :: proc(tooltip: cstring) ---                                                         // Set tooltip string
	
	// Icons functionality
	
	GuiIconText         :: proc(iconId: GuiIconName, text: cstring) -> cstring ---                            // Get text with icon id prepended (if supported)
	GuiSetIconScale     :: proc(scale: c.int) ---                                                             // Set default icon drawing size
	GuiGetIcons         :: proc() -> [^]u32 ---                                                               // Get raygui icons data pointer
	GuiLoadIcons        :: proc(fileName: cstring, loadIconsName: bool) -> [^]cstring ---                     // Load raygui icons file (.rgi) into internal icons data
	GuiDrawIcon         :: proc(iconId: GuiIconName, posX, posY: c.int, pixelSize: c.int, color: Color) ---   // Draw icon using pixel size at specified position
	
	
	// Controls
	//----------------------------------------------------------------------------------------------------------
	// Container/separator controls, useful for controls organization
	
	GuiWindowBox        :: proc(bounds: Rectangle, title: cstring) -> c.int ---                               // Window Box control, shows a window that can be closed
	GuiGroupBox         :: proc(bounds: Rectangle, text: cstring) -> c.int ---                                // Group Box control with text name
	GuiLine             :: proc(bounds: Rectangle, text: cstring) -> c.int ---                                // Line separator control, could contain text
	GuiPanel            :: proc(bounds: Rectangle, text: cstring) -> c.int ---                                // Panel control, useful to group controls
	GuiTabBar           :: proc(bounds: Rectangle, text: [^]cstring, count: c.int, active: ^c.int) -> c.int --- // Tab Bar control, returns TAB to be closed or -1
	GuiScrollPanel      :: proc(bounds: Rectangle, text: cstring, content: Rectangle, scroll: ^Vector2, view: ^Rectangle) -> c.int --- // Scroll Panel control
	
	// Basic controls set
	
	GuiLabel            :: proc(bounds: Rectangle, text: cstring) -> c.int ---                                // Label control, shows text
	GuiButton           :: proc(bounds: Rectangle, text: cstring) -> bool ---                                 // Button control, returns true when clicked
	GuiLabelButton      :: proc(bounds: Rectangle, text: cstring) -> bool ---                                 // Label button control, show true when clicked
	GuiToggle           :: proc(bounds: Rectangle, text: cstring, active: ^bool) -> c.int ---                 // Toggle Button control, returns true when active
	GuiToggleGroup      :: proc(bounds: Rectangle, text: cstring, active: ^c.int) -> c.int ---                // Toggle Group control, returns active toggle index
	GuiToggleSlider     :: proc(bounds: Rectangle, text: cstring, active: ^c.int) -> c.int ---
	GuiCheckBox         :: proc(bounds: Rectangle, text: cstring, checked: ^bool) -> bool ---                 // Check Box control, returns true when active
	GuiComboBox         :: proc(bounds: Rectangle, text: cstring, active: ^c.int) -> c.int ---                // Combo Box control, returns selected item index
	
	GuiDropdownBox      :: proc(bounds: Rectangle, text: cstring, active: ^c.int, editMode: bool) -> bool --- // Dropdown Box control, returns selected item
	GuiSpinner          :: proc(bounds: Rectangle, text: cstring, value: ^c.int, minValue, maxValue: c.int, editMode: bool) -> c.int --- // Spinner control, returns selected value
	GuiValueBox         :: proc(bounds: Rectangle, text: cstring, value: ^c.int, minValue, maxValue: c.int, editMode: bool) -> c.int --- // Value Box control, updates input text with numbers
	GuiTextBox          :: proc(bounds: Rectangle, text: cstring, textSize: c.int, editMode: bool) -> bool --- // Text Box control, updates input text
	
	GuiSlider           :: proc(bounds: Rectangle, textLeft: cstring, textRight: cstring, value: ^f32, minValue: f32, maxValue: f32) -> c.int --- // Slider control, returns selected value
	GuiSliderBar        :: proc(bounds: Rectangle, textLeft: cstring, textRight: cstring, value: ^f32, minValue: f32, maxValue: f32) -> c.int --- // Slider Bar control, returns selected value
	GuiProgressBar      :: proc(bounds: Rectangle, textLeft: cstring, textRight: cstring, value: ^f32, minValue: f32, maxValue: f32) -> c.int --- // Progress Bar control, shows current progress value
	GuiStatusBar        :: proc(bounds: Rectangle, text: cstring) -> c.int ---                                // Status Bar control, shows info text
	GuiDummyRec         :: proc(bounds: Rectangle, text: cstring) -> c.int ---                                // Dummy control for placeholders
	GuiGrid             :: proc(bounds: Rectangle, text: cstring, spacing: f32, subdivs: c.int, mouseCell: ^Vector2) -> c.int --- // Grid control, returns mouse cell position
	
	// Advance controls set
	GuiListView         :: proc(bounds: Rectangle, text: cstring, scrollIndex: ^c.int, active: ^c.int) -> c.int --- // List View control, returns selected list item index
	GuiListViewEx       :: proc(bounds: Rectangle, text:[^]cstring, count: c.int, scrollIndex: ^c.int, active: ^c.int, focus: ^c.int) -> c.int --- // List View with extended parameters
	GuiMessageBox       :: proc(bounds: Rectangle, title: cstring, message: cstring, buttons: cstring) -> c.int --- // Message Box control, displays a message
	GuiTextInputBox     :: proc(bounds: Rectangle, title: cstring, message: cstring, buttons: cstring, text: cstring, textMaxSize: c.int, secretViewActive: ^bool) -> c.int --- // Text Input Box control, ask for text, supports secret
	GuiColorPicker      :: proc(bounds: Rectangle, text: cstring, color: ^Color) -> c.int ---                 // Color Picker control (multiple color controls)
	GuiColorPanel       :: proc(bounds: Rectangle, text: cstring, color: ^Color) -> c.int ---                 // Color Panel control
	GuiColorBarAlpha    :: proc(bounds: Rectangle, text: cstring, alpha: ^f32) -> c.int ---                   // Color Bar Alpha control
	GuiColorBarHue      :: proc(bounds: Rectangle, text: cstring, value: ^f32) -> c.int ---                   // Color Bar Hue control
	GuiColorPickerHSV   :: proc(bounds: Rectangle, text: cstring, colorHsv: ^Vector3) -> c.int ---            // Color Picker control that avoids conversion to RGB on each call (multiple color controls)
	GuiColorPanelHSV    :: proc(bounds: Rectangle, text: cstring, colorHsv: ^Vector3) -> c.int ---            // Color Panel control that returns HSV color value, used by GuiColorPickerHSV()
	//----------------------------------------------------------------------------------------------------------
}
