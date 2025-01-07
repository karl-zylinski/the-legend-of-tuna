![cover](https://github.com/user-attachments/assets/8091a9c5-abcb-4841-9253-6451d242571e)

Playable in browser here: https://zylinski.itch.io/the-legend-of-tuna

Long Cat and Round Cat needs tuna. Use Long Cat to smack Round Cat to the treat! It's like golf, but fishy.

Uses Odin Programming Language, Raylib and Box2D.

Made during https://itch.io/jam/odin-holiday-jam

Made in 48 hours. Every single second of the development can be watched here: https://www.youtube.com/playlist?list=PLxE7SoPYTef2XC-ObA811vIefj02uSGnB (except the web build creation, I did that after the jam)

Uses the Odin + Raylib + Hot Reload template: https://github.com/karl-zylinski/odin-raylib-hot-reload-game-template

This repository helped me figure out how to do the web build: https://github.com/Aronicu/Raylib-WASM

## Box2D notes

This project uses a copy of `vendor:box2d`, you'll find it in `source` folder. I copied it because I needed to remove the `box2d_wasm.odin` file inside in order to make it compatible with emscripten.
