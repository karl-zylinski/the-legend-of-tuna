package raylib

import "core:strings"

LoadFileDataSlice :: proc(filename: string, allocator := context.allocator) -> (res: []byte, ok: bool) {
    filename_str := strings.clone_to_cstring(filename, context.temp_allocator)
    file_length: i32
    data := LoadFileData(filename_str, &file_length)
    if data == nil do return nil, false
    defer UnloadFileData(data)

    res = make([]byte, file_length, allocator)
    copy_slice(res, data[:file_length])
    
    return res, true
}

LoadFileDataString :: proc(filename: string, allocator := context.allocator) -> (res: string, ok: bool) {
    data := LoadFileDataSlice(filename, allocator) or_return
    return string(data), true
}