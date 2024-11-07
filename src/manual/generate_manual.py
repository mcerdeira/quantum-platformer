from PIL import Image
from fpdf import FPDF

# Crea el objeto PDF
pdf = FPDF(orientation='L', unit='mm', format='A4')
pdf.set_auto_page_break(auto=True, margin=15)

# Lista de archivos PNG
imagenes = ["Manual1.png", "Manual2.png", "Manual3.png", "Manual4.png", "Manual5.png", "Manual6.png"]

for imagen in imagenes:
    img = Image.open(imagen)
    pdf.add_page()

    # Convierte la imagen al tamaño A4
    pdf.image(imagen, x = 0, y = 0, w = 297, h = 210)  # Ajusta el tamaño si es necesario

# Guarda el PDF
pdf.output("manual-es.pdf")
