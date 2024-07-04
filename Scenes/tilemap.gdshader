shader_type canvas_item;

uniform vec4 color : hint_color;

void fragment() {
    vec4 texColor = texture(TEXTURE, UV);
    COLOR = texColor * color;
}