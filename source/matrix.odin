package main

rows :: 4
cols :: 4

Matrix4 :: struct{
    mat : [cols][rows]i32
}

newMatrix4 :: proc() -> Matrix4{
    return Matrix4{
        mat = 0
    }
} 

mulMatrix :: proc(mat1,mat2 : ^Matrix4) -> Matrix4{
    newMat := newMatrix4() 
    for row := 0; row < 4; row += 1 {
        for col := 0; col < 4; col += 1 {
            sum : i32 = 0
            for k := 0; k < 4; k += 1 {
                sum += mat1.mat[row][k] * mat2.mat[k][col]
            }
            newMat.mat[row][col] = sum
        }
    }

    return  newMat
}