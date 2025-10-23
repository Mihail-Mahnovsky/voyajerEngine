package main

import "core:math"

Vec3 :: struct{
    x : f64,
    y : f64,
    z : f64
}

newVec3 :: proc(x,y,z : f64) -> Vec3{
    return Vec3 { x = x,y=y,z=z }
}

addVectors3 :: proc(vec1,vec2 : ^Vec3) -> Vec3{
    return newVec3(vec1^.x + vec2^.x,vec1^.y + vec2^.y,vec1^.z + vec2^.z)
}

calcPosition :: proc(render: ^Render, cubeX, cubeY, cubeZ: f64) -> Vec3 {
    sinA := math.sin(render^.rotAng.angs.x)
    cosA := math.cos(render^.rotAng.angs.x)

    sinB := math.sin(render^.rotAng.angs.y)
    cosB := math.cos(render^.rotAng.angs.y)

    sinC := math.sin(render^.rotAng.angs.z)
    cosC := math.cos(render^.rotAng.angs.z)

    x := cubeX*(cosB*cosC) + cubeY*(sinA*sinB*cosC - cosA*sinC) + cubeZ*(cosA*sinB*cosC + sinA*sinC)
    y := cubeX*(cosB*sinC) + cubeY*(sinA*sinB*sinC + cosA*cosC) + cubeZ*(cosA*sinB*sinC - sinA*cosC)
    z := cubeX*(-sinB)     + cubeY*(sinA*cosB)               + cubeZ*(cosA*cosB)

    return Vec3{x, y, z}
}