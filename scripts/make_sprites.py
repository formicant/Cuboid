import numpy as np
import cv2

tile_w = 8
tile_h = 4
sprite_w = 80
sprite_h = 80
sprite_cx = 4
sprite_cy = 10
steps = 4
cases_count = 10


class Sprite:
    def __init__(self, sprite_tiling: np.ndarray) -> None:
        (non_zero_cols,) = np.nonzero(sprite_tiling.max(axis=0))
        (non_zero_rows,) = np.nonzero(sprite_tiling.max(axis=1))
        x: int = non_zero_cols.min()
        y: int = non_zero_rows.min()
        self.x = x - sprite_cx
        self.y = y - sprite_cy
        self.w: int = 1 + non_zero_cols.max() - x
        self.h: int = 1 + non_zero_rows.max() - y
        self.tiling = sprite_tiling[y : y + self.h, x : x + self.w]
        self.length = 4 + 2 * self.w * self.h
    
    def get_bytes(self, tiles_org: int) -> bytes:
        bs = [self.y % 256, self.x % 256, self.h, self.w]
        for y in range(self.h):
            for x in range(self.w):
                addr = tiles_org + 8 * self.tiling[y, x]
                bs.append(addr % 256)
                bs.append(addr // 256)
        return bytes(bs)


def tile_row_to_byte(row: np.ndarray, thresh: int) -> int:
    b = 0
    for i in range(8):
        b = b * 2 + (1 if row[i] > thresh else 0)
    return b

def get_tile_bytes(tile: np.ndarray) -> bytes:
    bs : list[int] = []
    for j in range(tile_h):
        bs.append(tile_row_to_byte(tile[j], 16))  # pixel mask
        bs.append(tile_row_to_byte(tile[j], 240)) # actual pixels
    return bytes(bs)


img = cv2.imread('graphics/mat.png', cv2.IMREAD_GRAYSCALE)

tiles = [get_tile_bytes(np.full((tile_h, tile_w), 128, 'uint8'))]
tiling = np.zeros((img.shape[0] // tile_h, img.shape[1] // tile_w), 'int32')

for j in range(tiling.shape[0]):
    for i in range(tiling.shape[1]):
        roi = img[tile_h * j : tile_h * (j + 1), tile_w * i : tile_w * (i + 1)]
        tile = get_tile_bytes(roi)
        existing = next((n for n in range(len(tiles)) if tiles[n] == tile), None)
        if existing is not None:
            tiling[j, i] = existing
        else:
            tiling[j, i] = len(tiles)
            tiles.append(tile)
        
tiles_org = 0xE300
sprites_org = 0xB900

print(f'tiles.bin:   {tiles_org}, {8 * len(tiles)}')
with open('data/tiles.bin', 'wb') as tiles_file:
    for tile in tiles:
        tiles_file.write(tile)

sprites: list[Sprite] = []
sprite_table: list[int] = []

sprite_addr = sprites_org + 2 * cases_count * (2 * steps + 1)
sprite_tiles_w = sprite_w // tile_w
sprite_tiles_h = sprite_h // tile_h
for sj in range(cases_count):
    for si in range(2 * steps + 1):
        sprite_tiling = tiling[
            sprite_tiles_h * sj : sprite_tiles_h * (sj + 1),
            sprite_tiles_w * si : sprite_tiles_w * (si + 1)]
        
        sprite = Sprite(sprite_tiling)
        sprites.append(sprite)
        sprite_table.append(sprite_addr % 256)
        sprite_table.append(sprite_addr // 256)
        sprite_addr += sprite.length

sprite_bytes = bytes(sprite_table)
for sprite in sprites:
    sprite_bytes += sprite.get_bytes(tiles_org)

print(f'sprites.bin: {sprites_org}, {len(sprite_bytes)}')
with open('data/sprites.bin', 'wb') as sprites_file:
    sprites_file.write(sprite_bytes)
