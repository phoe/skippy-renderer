# SKIPPY/RENDERER

This is a GIF renderer for SKIPPY.

The only exported function is `RENDER` which accepts a SKIPPY data stream and
returns three values - a list of vectors containing ARGB data in row-major
order, a list of integer values for frame delays in milliseconds, and a list
containing three values: image width, image height and a boolean signifying if
the GIF should loop.

LICENSE: MIT, or whatever the original SKIPPY is licensed under.
