# Utilise une image Python officielle
FROM python:3.11-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires
COPY requirements.txt ./
COPY Groupe20.py ./

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Commande par défaut
CMD ["python", "Groupe20.py"]
