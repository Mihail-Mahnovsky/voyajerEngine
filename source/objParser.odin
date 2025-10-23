package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

loadObj :: proc(pathToObj : string) -> ObjConfig {
    vertices := make([dynamic]Vec3, 0)

    data, ok := os.read_entire_file(pathToObj, context.allocator)
	if !ok {
		fmt.println("Failed to read file: ", pathToObj)
	}

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
        if strings.starts_with(line, "v ") {
            parts := strings.split(line, " ")
            if len(parts) >= 4 {
                x,_ := strconv.parse_f64(parts[1])
                y,_ := strconv.parse_f64(parts[2])
                z,_ := strconv.parse_f64(parts[3])
                 append(&vertices, newVec3(x, y, z))
            }
        }
	}

    return ObjConfig{
        vertices = vertices,
        type = confType.OBJ,
        incrementSpeed = 0.75,
        distance = 100,
        backgroundChar = ' ',
        size = 40,
        width = 10,
    }
}