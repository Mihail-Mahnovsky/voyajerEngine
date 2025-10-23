package main

confType :: enum{
    OBJ,
    CUBE,
}

ObjConfig :: struct{
    type : confType,
    vertices : [dynamic]Vec3,
    incrementSpeed : f64,
    distance : i32,
    backgroundChar : byte,
    size : f64,
    width : f64,
}

CubeConfig :: struct{
    type : confType,
    size : f64,
    width : f64,
    incrementSpeed : f64,
    distance : i32,
    backgroundChar : byte
}