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