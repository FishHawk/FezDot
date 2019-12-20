//#version 330 core
//
//in vec4 color;
////varying mediump vec4 color;
//
//void main(void) {
//    gl_FragColor = color;
//}

#version 330 core

in vec4 bColor;

void main()
{
    gl_FragColor = bColor;
}