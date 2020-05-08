# DSFonts

This is a set of shaders and materials for the distance field font for [Defold engine](http://www.defold.com) .

## Installation

You can use the DSFonts library in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/).
Open your game.project file and in the dependencies field under project add:

>https://github.com/sergeysinyavsky/dsfonts/archive/master.zip

## Example
![screenshot](https://raw.githubusercontent.com/sergeysinyavsky/dsfonts/master/example/scrins/full.png)

## Shaders

#### Bevel shader
Parameters:

`step.x` - change bevel level. Default 1024.<br />
`step.y` - change brightness. Default 2.<br />

![screenshot](https://raw.githubusercontent.com/sergeysinyavsky/dsfonts/master/example/scrins/bevel.png)

#### Bevel normal shader
Parameters:

`step.x` - change bevel level. Default 1024.<br />

![screenshot](https://raw.githubusercontent.com/sergeysinyavsky/dsfonts/master/example/scrins/bevel-normal.png)

#### Gradient shader
Parameters:

`color` - Normal color will be **left** in x direction and **top** in y direction.<br />
`next_color` - Second color will be **right** in x direction and **bottom** in y direction.. Default (1, 1, 1, 1).<br />
`direction.x` - Specifies the direction for the x coordinate. From -1 to 1. Default 1.<br />
`direction.y` - Specifies the direction for the y coordinate. From -1 to 1. Default 0.<br />

![screenshot](https://raw.githubusercontent.com/sergeysinyavsky/dsfonts/master/example/scrins/gradient.png)

#### Glow shader
Parameters:

`glow_color` - Color for glow. Default (1, 1, 1, 1).<br />
`strength.x` - Outer strength. Default 0.<br />
`strength.y` - Inner strength. Default 2.<br />
`strength.z` - Sharpness strength. Default 30.<br />

![screenshot](https://raw.githubusercontent.com/sergeysinyavsky/dsfonts/master/example/scrins/glow.png)

#### Gradient bevel shader
Parameters:

`step.x` - change bevel level. Default 1024.<br />
`step.y` - change brightness. Default 2.<br />
`color` - Normal color will be **left** in x direction and **top** in y direction.<br />
`next_color` - Second color will be **right** in x direction and **bottom** in y direction.. Default (1, 1, 1, 1).<br />
`direction.x` - Specifies the direction for the x coordinate. From -1 to 1. Default 0.<br />
`direction.y` - Specifies the direction for the y coordinate. From -1 to 1. Default 1.<br />

![screenshot](https://raw.githubusercontent.com/sergeysinyavsky/dsfonts/master/example/scrins/gradient-bevel.png)

---