shader_type canvas_item;

uniform float offset : hint_range(0.0, 1.0);

void fragment() {
    // Modificar las coordenadas UV para crear el efecto de desplazamiento hacia arriba
    vec2 uv = UV;
    uv.y += offset; // Desplaza la textura hacia arriba

    // Solo dibuja los fragmentos que estén dentro de las coordenadas UV válidas
    if (uv.y > 1.0) {
        discard; // No dibujar fragmentos por encima del límite
    }

    // Renderizar la textura original desplazada
    COLOR = texture(TEXTURE, uv);
}
