package main

main :: proc(){
    ren := newRender()
    renderLoop(&ren)
}