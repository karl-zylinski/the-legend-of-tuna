@echo off

odin run atlas_builder

odin build main_release -out:game_debug.exe -strict-style -vet -debug
