-- Outline shader code
local outlineShaderCode = [[
    extern number outlineWidth;  // Width of the outline
    extern vec4 outlineColor;    // Color of the outline

    vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
        // Sample the original texture
        vec4 originalColor = Texel(texture, textureCoords);

        // Check if the pixel is non-transparent and not already part of the character sprite
        if (originalColor.a > 0.0) {
            // Check neighboring pixels to detect transparent ones
            bool isOutlinePixel = false;
            for (float dx = -outlineWidth; dx <= outlineWidth; dx++) {
                for (float dy = -outlineWidth; dy <= outlineWidth; dy++) {

                    vec2 neighborCoords = textureCoords + vec2(dx, dy) / love_ScreenSize.xy;
                    vec4 neighborColor = Texel(texture, neighborCoords);
                    // If any neighboring pixel is transparent and not part of the character sprite, mark the current pixel as outline
                    if (neighborColor.a == 0.0 && originalColor.a > 0.0) {
                        isOutlinePixel = true;
                        break;
                    }

                }
            }
            // If the pixel is marked as outline, color it with the outline color
            if (isOutlinePixel) {
                return outlineColor * color;
            }
        }

        return originalColor * color;
    }
]]

return outlineShaderCode
