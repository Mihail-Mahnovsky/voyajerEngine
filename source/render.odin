package main

screenWidth :: 60
screenHeight :: 30

import "core:fmt"
import "core:math"
import "core:time"

RotateAngeles :: struct{
    angs : Vec3
}

RenderBuffer :: struct{
    width : i32,
    height : i32,
    ZBuffer : []f64,
    CharBuffer :[]byte
}

Render :: struct {
    renBuf : RenderBuffer,
    rotAng : RotateAngeles,
    cube : CubeConfig,
    obj : ObjConfig,
    horizontalOffset : f64
}

newRender :: proc() -> Render{
    return Render{
        renBuf = RenderBuffer{
            width = screenWidth,
            height = screenHeight,
            ZBuffer = make([]f64, screenWidth * screenHeight),
            CharBuffer = make([]byte, screenWidth * screenHeight),
        },
        cube = CubeConfig{
            size = 40,
            width = 10,
            incrementSpeed = 0.89,
            distance = 100,
            backgroundChar = ' '
        },
        obj = loadObj("../res/monkey.obj"),
    }
}

renderSurface :: proc(rn : ^Render,cubeX ,cubeY,cubeZ : f64,charToDraw : byte){
    modelCords := calcPosition(rn,cubeX,cubeY,cubeZ)
    modelCords.z += f64(rn^.cube.distance)

    zFraction := 1 / modelCords.z

    //проверка на то что число не улетает в безконечность
    if math.is_inf(zFraction,0){
        return
    }

    xPos := i32(f64(rn^.renBuf.width) / 2 + rn^.horizontalOffset + rn^.cube.size * zFraction*modelCords.x*2)
    yPos := i32(f64(rn^.renBuf.height) / 2 + rn^.cube.size*zFraction*modelCords.y)

    idx : i32 = xPos + yPos * rn^.renBuf.width

    if idx >= 0 && idx < i32(len(rn^.renBuf.ZBuffer)) && zFraction > rn^.renBuf.ZBuffer[idx]{
        rn^.renBuf.ZBuffer[idx] = zFraction
        rn^.renBuf.CharBuffer[idx] = charToDraw
    }


}

clearSurface :: proc(rn : ^Render) {
    for i : i32 = 0; i < i32(len(rn^.renBuf.CharBuffer)); i += 1{
        rn^.renBuf.CharBuffer[i] = rn^.cube.backgroundChar
    }
        for i : i32 = 0; i < i32(len(rn^.renBuf.ZBuffer)); i += 1{
        rn^.renBuf.ZBuffer[i] = 0
    }
}

renderCubeFrame :: proc(rn : ^Render){
    clearSurface(rn)
    cw := rn^.cube.width

    for x := -cw; x < cw; x += 1 {
        for y := -cw; y < cw; y += 1 {
            renderSurface(rn, f64(x), f64(y), -cw, '@')
            renderSurface(rn, cw, f64(x), f64(y), '$')
            renderSurface(rn, -cw, f64(x), f64(y), '~')
            renderSurface(rn, f64(x), -cw, f64(y), '#')
            renderSurface(rn, f64(x), cw, f64(y), ';')
            renderSurface(rn, f64(x), f64(y), cw, '+')
        }
    }
}

renderObjFrame :: proc(rn : ^Render){
    for vertex in rn^.obj.vertices {
        renderSurface(rn, vertex.x, vertex.y, vertex.z, '@')
    }
}

updateRotation :: proc(rn : ^Render){
    rn^.rotAng.angs.x += rn^.cube.incrementSpeed * 0.02
    rn^.rotAng.angs.y += rn^.cube.incrementSpeed * 0.01
    rn^.rotAng.angs.z += rn^.cube.incrementSpeed * 0.015
}

renderLoop :: proc(rn : ^Render){
    for {
        renderObjFrame(rn)

        for y : i32 = 0; y < rn^.renBuf.height; y += 1 {
            start := y * rn^.renBuf.width
            end := start + rn^.renBuf.width
            fmt.println(string(rn^.renBuf.CharBuffer[start:end]))
        }

        updateRotation(rn)
        time.sleep(time.Millisecond * 66)
    }
}