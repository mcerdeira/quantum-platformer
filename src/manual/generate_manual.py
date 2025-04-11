from PIL import Image
from fpdf import FPDF

# Crear PDF en orientación horizontal
pdf = FPDF(orientation='L', unit='mm', format='A4')
pdf.set_auto_page_break(auto=False)

# Lista de imágenes
imagenes = ["Manual1.png", "Manual2.png", "Manual3.png", "Manual4.png", "Manual5.png", "Manual6.png"]

# Tamaño A4 horizontal
a4_width_mm = 297
a4_height_mm = 210

for imagen in imagenes:
    img = Image.open(imagen)
    pdf.add_page()

    img_width_px, img_height_px = img.size
    img_ratio = img_width_px / img_height_px
    page_ratio = a4_width_mm / a4_height_mm

    if img_ratio > page_ratio:
        # Imagen más ancha, ajustar por ancho
        width = a4_width_mm
        height = width / img_ratio
    else:
        # Imagen más alta, ajustar por alto
        height = a4_height_mm
        width = height * img_ratio

    x = (a4_width_mm - width) / 2
    y = (a4_height_mm - height) / 2

    pdf.image(imagen, x=0, y=0, w=a4_width_mm, h=a4_height_mm)

pdf.output("manual-horizontal.pdf")
