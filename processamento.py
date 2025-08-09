import pandas as pd
from IPython.display import display

path = r"data\001.csv"

df = pd.read_csv(path, sep=',')

valores = df['idNaturezaDivida'].isin([64,65,66,69]).sum()

print(valores)