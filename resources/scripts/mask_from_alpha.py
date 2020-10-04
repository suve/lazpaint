# Mask > Mask from alpha channel
# (fr) Masque > Masque depuis canal alpha
# (es) Máscara > Máscara desde canal alpha
# (de) Maske > Maske vom Alphakanal
from lazpaint import image, layer, filters, selection

image.do_begin()

selection.deselect()
layer.duplicate()
layer.set_name("Mask")
filters.filter_function(red="alpha", green="alpha", blue="alpha", alpha=255, gamma_correction=False)
layer.set_blend_op(layer.BLEND_MASK)

image.do_end()
