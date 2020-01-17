#version 330 core

in vec4 bColor;
layout(location = 0) out vec4 frag_color;

void main() {
    frag_color = bColor;
}