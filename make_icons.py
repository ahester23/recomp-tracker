import struct, zlib, os

INK = (0x16, 0x17, 0x1A)
GOLD = (0xC8, 0x9B, 0x3C)
STEEL_DIM = (0x56, 0x5B, 0x62)

def lerp(a, b, t):
    return a + (b - a) * t

def blend(c1, c2, t):
    return tuple(round(lerp(c1[i], c2[i], t)) for i in range(3))

def render(size, ss=4):
    n = size * ss
    cx = cy = n / 2
    outer_r = n * 0.46
    ring_r = n * 0.43
    hole_r = n * 0.155
    px = bytearray(n * n * 3)

    for y in range(n):
        dy = y + 0.5 - cy
        for x in range(n):
            dx = x + 0.5 - cx
            d = (dx * dx + dy * dy) ** 0.5
            if d <= hole_r:
                c = INK
            elif d <= ring_r:
                c = GOLD
            elif d <= outer_r:
                c = STEEL_DIM
            else:
                c = INK
            i = (y * n + x) * 3
            px[i], px[i+1], px[i+2] = c

    # box downsample n x n (ss x ss blocks) -> size x size
    out = bytearray(size * size * 3)
    for by in range(size):
        for bx in range(size):
            r = g = b = 0
            for j in range(ss):
                sy = by * ss + j
                row = sy * n * 3
                for k in range(ss):
                    sx = (bx * ss + k) * 3
                    idx = row + sx
                    r += px[idx]; g += px[idx+1]; b += px[idx+2]
                    idx += 0
            count = ss * ss
            oi = (by * size + bx) * 3
            out[oi] = r // count
            out[oi+1] = g // count
            out[oi+2] = b // count
    return out

def write_png(path, size, rgb):
    def chunk(tag, data):
        c = tag + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)

    raw = bytearray()
    stride = size * 3
    for y in range(size):
        raw.append(0)  # filter type 0
        raw.extend(rgb[y*stride:(y+1)*stride])

    sig = b'\x89PNG\r\n\x1a\n'
    ihdr = struct.pack('>IIBBBBB', size, size, 8, 2, 0, 0, 0)
    idat = zlib.compress(bytes(raw), 9)
    with open(path, 'wb') as f:
        f.write(sig)
        f.write(chunk(b'IHDR', ihdr))
        f.write(chunk(b'IDAT', idat))
        f.write(chunk(b'IEND', b''))

if __name__ == '__main__':
    out_dir = os.path.dirname(os.path.abspath(__file__))
    for size in (180, 192, 512):
        rgb = render(size)
        write_png(os.path.join(out_dir, f'icon-{size}.png'), size, rgb)
        print('wrote', size)
