shader_type canvas_item;

// texture de l’écran 
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;

// taille du bloc en pixels (1 = pas de pixelisation, 4 = bloc 4x4 pixels, ...)
uniform float pixel_size_pixels : hint_range(1, 256) = 1.0;

// force du pixelate (0 = aucun, 1 = full pixel)
uniform float strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // calcule le nombre de blocs (largeur/hauteur)
    vec2 blocks = vec2(1.0) / (SCREEN_PIXEL_SIZE * pixel_size_pixels);

    // pixelated UV
    vec2 uv_pixel = floor(SCREEN_UV * blocks) / blocks;

    // lecture des deux versions
    vec4 orig = texture(screen_tex, SCREEN_UV);
    vec4 pixel = texture(screen_tex, uv_pixel);

    // mélange progressif
    COLOR = mix(orig, pixel, strength);
}