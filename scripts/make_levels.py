from typing import Any
import json

block_dict = {
    '.': 0,
    'd': 1,
    'l': 3,
    'o': 5,
    'b': 7,
}

def parse_layer_string(layer: str) -> list[list[int]]:
    rows = layer.strip().split()
    return [[block_dict[b] for b in row] for row in rows]

def get_level_bytes(level: dict[str, Any]) -> bytes:
    layers = [parse_layer_string(layer) for layer in level['blocks']]
    height = len(layers)
    width = max(len(layer) for layer in layers)
    length = max(len(row) for layer in layers for row in layer)
    cz = 8 - height // 2
    cy = 8 - width // 2
    cx = 8 - length // 2
    array = [0] * 4096
    for z in range(height):
        for y in range(width):
            start = 256 * (16 - cz - z) + 16 * (cy + y) + cx
            row = layers[z][y]
            array[start : start + len(row)] = row[::-1]
    return bytes(array)
    

def process_levels() -> None:
    with open('data/levels.json', 'r') as json_file:
        levels = json.load(json_file)
        bytes = get_level_bytes(levels[0])
        with open('data/level.bin', 'wb') as level_file:
            level_file.write(bytes)

if __name__ == '__main__':
    process_levels()
