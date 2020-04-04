# SKIPPY/RENDERER

This is a GIF renderer for SKIPPY.

## Reason

The issue of rendering a GIF file is that every single GIF frame can - for
compression purposes - only update a single part of the resulting image. For
instance, the first frame can be 100x100px, but the second frame can be 4x4
and only update a part that is 20px from the top and 84px from the left. The
third frame can again be 40x40 and update a yet different part of the image,
the fourth frame can *reverse* the effects of the third frame, etc., etc..
This is why, even if you have the GIF frames alone, it is non-trivial to get
a series of 100x100 images ARGB that you can then convert e.g. into a video
file.

SKIPPY-RENDERER is a library existing to solve this very problem. No matter
what the original frames of the image look like, the RENDER function gives you
a "decompressed" series of 100x100px ARGB frames that you can then e.g. encode
into a different file format.

My personal use case for this library: converting GIF animations into another
file format that required raw ARGB data for each frame.

## Interface

The only exported function is `RENDER` which accepts a SKIPPY data stream and a
`BYTE-ORDER` keyword argument that states the endianness of bytes in the
resulting vector (ARGB or BGRA).
It returns three values - a list of vectors containing ARGB data in row-major
order, a list of integer values for frame delays in milliseconds, and a list
containing three values: image width, image height and a boolean signifying if
the GIF should loop.

```lisp
CL-USER> (skippy:load-data-stream "~/Downloads/cat_picture.gif")
#<SKIPPY::DATA-STREAM geometry 100x100, 5 images {100D53C843}>
CL-USER> (skippy-renderer:render *)
(#(0 0 0 0 0 ...)
 ...)
(3 3 3 3 3)
(100 100 T)
```

## License

MIT, or whatever the original SKIPPY is licensed under.
