# Include the spritesheet in the build, make the data available to Nim
{.compile: "../gfx/catto.s".}
var cattoTiles* {.importc: "cattoTiles".}: array[512, uint32]
var cattoPal* {.importc: "cattoPal".}: array[16, uint16]