#include <stdlib.h>
#include <emscripten/emscripten.h>
#include <emscripten/html5.h>

extern void game_init_window();
extern void game_init();
extern void game_update();
extern void game_window_size_changed(int w, int h);

void send_size_to_game() {
	double w, h;
	emscripten_get_element_css_size( "#canvas", &w, &h);
	game_window_size_changed((int)w, (int)h);
}

static EM_BOOL on_web_display_size_changed(
	int event_type,
	const EmscriptenUiEvent *event,
	void *user_data
) {
	send_size_to_game();
	return 0;
}

int main(void) {
	emscripten_set_resize_callback(
		EMSCRIPTEN_EVENT_TARGET_WINDOW,
		0, 0, on_web_display_size_changed
	);

	game_init_window();
	game_init();
	send_size_to_game();

	emscripten_set_main_loop(game_update, 0, 1);
	return 0;
}