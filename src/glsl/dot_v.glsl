//#version 330 core
//
//layout (location = 0) in vec4 vertex;
//layout (location = 1) in vec4 color_in;
//out vec4 color;
//
////attribute highp vec3 vertex;
////attribute mediump vec3 normal;
////uniform mediump mat4 matrix;
////varying mediump vec4 color;
//
//void main(void) {
//    gl_Position = vertex;
//    color = color_in;
////    vec3 toLight = normalize(vec3(0.0, 0.3, 1.0));
////    float angle = max(dot(normal, toLight), 0.0);
////    vec3 col = vec3(0.40, 1.0, 0.0);
////    color = vec4(col * 0.2 + col * 0.8 * angle, 1.0);
////    color = clamp(color, 0.0, 1.0);
////    gl_Position = matrix * vec4(vertex,1.0);
//}


#version 330 core
layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec4 aColor;

out vec4 bColor;

uniform mat4 rotate;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    vec4 position = rotate * aPosition;
    float factor = (3 - 2) / (3 - position.w);
    gl_Position = projection * view * vec4(factor * position.xyz, 0.7);
    bColor = aColor;
}