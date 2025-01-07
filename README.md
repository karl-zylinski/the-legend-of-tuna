![cover](https://github.com/user-attachments/assets/8091a9c5-abcb-4841-9253-6451d242571e)

Playable in browser here: https://zylinski.itch.io/the-legend-of-tuna

Long Cat and Round Cat needs tuna. Use Long Cat to smack Round Cat to the treat! It's like golf, but fishy.

Uses Odin Programming Language, Raylib and Box2D.

Made during https://itch.io/jam/odin-holiday-jam

Made in 48 hours. Every single second of the development can be watched here: https://www.youtube.com/playlist?list=PLxE7SoPYTef2XC-ObA811vIefj02uSGnB (except the web build creation, I did that after the jam)

Uses my Odin + Raylib + Hot Reload template: https://github.com/karl-zylinski/odin-raylib-hot-reload-game-template

Uses my atlas builder: https://github.com/karl-zylinski/atlas-builder

This repository helped me figure out how to do the web build: https://github.com/Aronicu/Raylib-WASM

## Box2D notes

This project uses a copy of `vendor:box2d`, you'll find it in `source` folder.

- I've added a DLL version for windows, in order to enable hot reload (box2d stores some global state internally that is destroyed each reload if it is statically linked into `game.dll`).
- I've removed `source/box2d/box2d_wasm.odin` in order to remove some emscripten compile issues. Odin's box2D works without emscripten. But if you need emscripten, because of for example raylib, then you'll this conflict.
- The in `build_web.bat`: Note that I need to link `source/box2d/box2d_wasm.o` when calling `emcc`.
