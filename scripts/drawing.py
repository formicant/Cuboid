import numpy as np
from math import tau
from transforms3d import axangles
import cv2

def polygon_area_2d(points: np.ndarray):
    xs = points[:, 0]
    ys = points[:, 1]
    return 0.5 * (np.dot(xs, np.roll(ys, 1)) - np.dot(ys, np.roll(xs, 1)))

class Body:
    def __init__(self, facets: list[np.ndarray]):
        self.facets = facets
    
    def get_visible_facets(self, camera: np.ndarray) ->  list[np.ndarray]:
        return [f for f in self.facets if self.is_facet_visible(f, camera)]
    
    def is_facet_visible(self, facet: np.ndarray, camera: np.ndarray) -> bool:
        points = np.matmul(facet, camera)
        area = polygon_area_2d(points)
        return area > 0

def rotate(body: Body, axis_base: np.ndarray, axis_direction: np.ndarray, revolutions: float) -> Body:
    transform = axangles.axangle2aff(axis_direction, tau * revolutions, axis_base).transpose()
    facets = [np.matmul(f, transform) for f in body.facets]
    return Body(facets)

def rotate_camera(camera: np.ndarray, axis_base: np.ndarray, axis_direction: np.ndarray, revolutions: float) -> np.ndarray:
    transform = axangles.axangle2aff(axis_direction, tau * revolutions, axis_base).transpose()
    rotated_camera = np.matmul(transform, camera)
    return np.round(rotated_camera)


def cuboid(x: float, y: float, z: float) -> Body:
    return Body([
        np.array([[0, 0, 0, 1], [0, 0, z, 1], [0, y, z, 1], [0, y, 0, 1]]),
        np.array([[0, 0, 0, 1], [x, 0, 0, 1], [x, 0, z, 1], [0, 0, z, 1]]),
        np.array([[0, 0, 0, 1], [0, y, 0, 1], [x, y, 0, 1], [x, 0, 0, 1]]),
        np.array([[x, y, z, 1], [x, 0, z, 1], [x, 0, 0, 1], [x, y, 0, 1]]),
        np.array([[x, y, z, 1], [x, y, 0, 1], [0, y, 0, 1], [0, y, z, 1]]),
        np.array([[x, y, z, 1], [0, y, z, 1], [0, 0, z, 1], [x, 0, z, 1]]),
    ])



def draw_grid(img: np.ndarray, cell_width: int, cell_height: int) -> None:
    for y in range(img.shape[0] // cell_height):
        for x in range(img.shape[1] // cell_width):
            color = 144 if (x + y) % 2 != 0 else 128
            img[cell_height * y : cell_height * (y + 1), cell_width * x : cell_width * (x + 1)] = color

def draw_body(img: np.ndarray, camera: np.ndarray, body: Body) -> None:
    body_points = [np.matmul(facet, camera).astype(int) for facet in body.get_visible_facets(camera)]
    
    cv2.fillPoly(img, body_points, 255)
    cv2.polylines(img, body_points, True, 0)
    

# ------------------------

camera = np.array([
    [16, -4],
    [-8, -8],
    [0, -16],
    [32.5, 55.5]])

cases = [
    (cuboid(2, 1, 1), np.array([0, 0, 0]), np.array([2, 0, 0]), np.array([0, 1, 0])),
    (cuboid(2, 1, 1), np.array([1, 0, 0]), np.array([1, 0, 0]), np.array([0, 1, 0])),
    (cuboid(2, 1, 1), np.array([0, 0, 0]), np.array([0, 1, 0]), np.array([-1, 0, 0])),
    (cuboid(1, 2, 1), np.array([0, 0, 0]), np.array([1, 0, 0]), np.array([0, 1, 0])),
    (cuboid(1, 2, 1), np.array([0, 0, 0]), np.array([0, 2, 0]), np.array([-1, 0, 0])),
    (cuboid(1, 2, 1), np.array([0, 1, 0]), np.array([0, 1, 0]), np.array([-1, 0, 0])),
    (cuboid(1, 1, 2), np.array([0, 0, 0]), np.array([1, 0, 0]), np.array([0, 1, 0])),
    (cuboid(1, 1, 2), np.array([0, 0, 1]), np.array([1, 0, 1]), np.array([0, 1, 0])),
    (cuboid(1, 1, 2), np.array([0, 0, 0]), np.array([0, 1, 0]), np.array([-1, 0, 0])),
    (cuboid(1, 1, 2), np.array([0, 0, 1]), np.array([0, 1, 1]), np.array([-1, 0, 0])),
]

sprite_w = 80
sprite_h = 80
steps = 4

img_w = sprite_w * (2 * steps + 1)
img_h = sprite_h * len(cases)
img = np.full((img_h, img_w), 128, 'uint8')

draw_grid(img, 8, 4)

angle_delta = 1 / 4 / (2 * steps + 1)

for j, (body, axis_base_neg, axis_base_pos, axis_dir) in enumerate(cases):
    y = sprite_h * j
    
    for i in range(-steps, steps + 1):
        x = sprite_w * (steps + i)
        roi = img[y : y + sprite_h, x : x + sprite_w]
        cv2.rectangle(roi, (0, 0), (sprite_w, sprite_h), 112)
        
        axis_base = axis_base_neg if i < 0 else axis_base_pos
        rotated_camera = rotate_camera(camera, axis_base, axis_dir, angle_delta * i)
        draw_body(roi, rotated_camera, body)

cv2.imwrite('graphics/mat.png', img)
