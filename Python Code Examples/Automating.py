#https://pypi.org/project/PyPDF2/
#python3 -m pip install PyPDF2
#https://packaging.python.org/en/latest/tutorials/installing-packages/

import PyPDF2
import os

merger = PyPDF2.PdfMerger()
print(f"Current dir: {os.getcwd()}/")

fpath = "/Users/federp/Downloads/test/"
if os.path.isfile(f"{fpath}combined.pdf"):
    os.remove(f"{fpath}combined.pdf")
    print(f"Removed: {fpath}combined.pdf")
for file in os.listdir(fpath):
    if file.endswith(".pdf"):
        file_path = fpath + file
        reader = PyPDF2.PdfReader(file_path)
        number_of_pages = len(reader.pages)
        print(f'Appending {file_path} which contains {number_of_pages} pages')
        merger.append(file_path)
merger.write(f"{fpath}combined.pdf")
