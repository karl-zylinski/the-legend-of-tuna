@echo off

if not exist build_web mkdir build_web

set EMSDK_QUIET=1
call C:\emsdk\emsdk_env.bat

pushd build_web
odin build ..\game -target:freestanding_wasm32 -build-mode:obj -show-system-calls -vet -strict-style -o:speed
IF %ERRORLEVEL% NEQ 0 popd && exit /b 1

set files=..\main_web\main_wasm.c ..\game\raylib\wasm\libraylib.a ..\game\box2d\lib\box2d_wasm.o game.wasm.o
set flags=-sUSE_GLFW=3 -sASYNCIFY -sASSERTIONS -DPLATFORM_WEB
set mem=-sTOTAL_STACK=64MB -sINITIAL_MEMORY=128MB
set custom=--shell-file ..\main_web\minshell.html
emcc -o index.html %files% %flags% %mem% %custom% && cd ..