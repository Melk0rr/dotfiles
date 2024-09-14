import re
from typing import Union, Tuple

HEX_REG = r'^(?:#?)(?:[0-9A-Fa-f]{3}){1,2}$'

def validate_hex_color(hex_str: str) -> str:
  """ Check if the given hex is valid """
  if "#" not in hex_str:
    hex_str = f"#{color}"
    
  if not re.match(HEX_REG, hex_str):
    raise ValueError(f"Invalid hex string provided: {hex_str}")

  return hex_str

def validate_rgb_color(rgb: Tuple[int, int, int]) -> Tuple[int, int, int]:
  """ Check if the given rgb is valid """
  if len(rgb) != 3:
    raise ValueError(f"Invalid RGB tuple provided: {rgb}. Please provide a tuple with 3 values")

  if not all(0 < n <= 255 for n in rgb):
    raise ValueError(f"Invalid RGB tuple provided: {rgb}. RGB value must be like 0 < v < 255")

  return rgb

def hex_2_rgb(hex_str: str) -> Tuple[int, int, int]:
  """ Converts an hex string to rgb """
  hex_str = validate_hex_color(hex_str)
  hex_str = hex_str.lstrip('#')

  return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))

def rgb_2_hex(rgb: Tuple[int, int, int]) -> str:
  """ Converts an RGB tuple to an hex string """
  rgb = validate_rgb_color(rgb)
  
  return '#%02x%02x%02x' % rgb

def rgb_percentages(rgb: Tuple[int, int, int]) -> Tuple[float, float, float]:
  """ Get RGB percentages """
  return tuple(round(rgb[i] / 255, 2) for i in (0, 1, 2))

def rgb_2_hsl(rgb: Tuple[int, int, int]) -> Tuple[float, float, float]:
  """ Converts an RGB tuple into a HSL tuple """
  p = rgb_percentages(rgb=rgb)

  min_rgb = min(p)
  max_rgb = max(p)
  
  # L
  l = (min_rgb + max_rgb) / 2

  # S
  if min_rgb == max_rgb:
    s = 0
    
  elif l < 0.5:
    s = (max_rgb - min_rgb) / (max_rgb + min_rgb)
    
  else:
    s = (max_rgb - min_rgb) / (2 - max_rgb - min_rgb)

  # H
  if s == 0:
    h = 0

  elif p[0] >= max(p[1], p[2]):
    h = (p[1] - p[2]) / (max_rgb - min_rgb)
    
  elif p[1] >= max(p[0], p[2]):
    h = 2 + (p[2] - p[0]) / (max_rgb - min_rgb)
    
  else:
    h = 4 + (p[0] - p[1]) / (max_rgb - min_rgb)
    
  h = h * 60
  
  if h < 0:
    h = h + 360

  return (h, round(s, 2), round(l, 2))

def hsl_2_rgb(hsl: Tuple[float, float, float]) -> Tuple[int, int, int]:
  """ Converts an HSL tuple into an RGB tuple """
  h, s, l = hsl
  if s == 0:
    return tuple(h * 255, s * 255, l * 255)

  if l < 0.5:
    tmp1 = l * (1 + s)
    
  else:
    tmp1 = l + s - l * s
    
  tmp2 = 2 * l - tmp1
  
  h = h / 360
  
  tmpR = h + 0.333
  tmpG = h
  tmpB = h - 0.333

  def rgb_res(tmpV: float) -> float:
    v = None
    
    if tmpV < 0:
      tmpV = tmpV + 1
    
    if tmpV > 1:
      tmpV = tmpV - 1
      
    if 6 * tmpV < 1:
      v = tmp2 + (tmp1 - tmp2) * 6 * tmpV
      
    else:
      if 2 * tmpV < 1:
        v = tmp1
      
      else:
        if 3 * tmpV < 2:
          v = tmp2 + (tmp1 - tmp2) * (0.666 - tmpV) * 6
          
        else:
          v = tmp2

    return v
  
  r = rgb_res(tmpR) * 255
  g = rgb_res(tmpG) * 255
  b = rgb_res(tmpB) * 255
  
  return (round(r), round(g - 1), round(b))

def max_saturation(color: Union[str, Tuple[int, int, int]]) -> str:
  """ Maxes given color saturation """
  if type(color) == str:
    color = hex_2_rgb(color)

  hsl = rgb_2_hsl(color)
  
  tmp = list(hsl)
  tmp[1] = 1
  
  hsl = tuple(tmp)
  
  new_hex = rgb_2_hex(hsl_2_rgb(hsl))
  
  return new_hex

def openrgb_color(hex_str: str) -> None:
  """ Adjust the given color for openrgb """
  sat = max_saturation(hex_str)
  print(print(new_hex))
  


if __name__ == "__main__":
    max_saturation()