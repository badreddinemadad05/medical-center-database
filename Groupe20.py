import mysql.connector
import time
from datetime import datetime


# Fonction principale pour insérer un patient et sa visite
def inserer_patient_et_visite(cursor, conn):
    # Informations du patient
    nom = input("Entrer le  nom du patient : ")
    

    prenom = input("Entrer le prenom du patient : ")
    sexe = input("Entrer le  sexe (F/M): ")
    adresse = input("entrer l'adresse du patient: ")
    e_mail = input("email : ")

    # Informations sur la visite
    motif = input("C'est quoi le motif du patient (consultation C/ hospitalisation H) : ").strip().lower()
    date_visite = datetime.today().strftime('%Y-%m-%d')


    nom_dep=input("entrer le nom de departement : ")


       # à adapter si nécessaire
    now = datetime.now()
    heure_visite=now.strftime("%H:%M:%S")



    if motif == "C":
        duree = 20
        type_chambre = "Bloc Consultation"
    elif motif == "H":
        duree = 60
        type_chambre = "Bloc Hospitalisation"
    else:
        print("❌ Motif invalide.")
        return True

    # Trouver une chambre disponible
    cursor.execute("SELECT num_chambre FROM chambre WHERE Occupation = TRUE AND Type = %s LIMIT 1", (type_chambre,))
    result = cursor.fetchone()

    if not result:
        print("❌ Aucune chambre disponible.")
        return True

    num_chambre = result[0]
    cursor.execute("UPDATE chambre SET Occupation = FALSE WHERE num_chambre = %s", (num_chambre,))

    # Insérer le patient
    cursor.execute("""
        INSERT INTO patient (nom, prenom, sexe, adresse, e_mail)
        VALUES (%s, %s, %s, %s, %s)
    """, (nom, prenom, sexe, adresse, e_mail))
    id_patient = cursor.lastrowid

    # Insérer la visite
    cursor.execute("""
        INSERT INTO visite (duree, date_visite,time_of_visite ,motif, id_patient, num_chambre, NOM_DEP)
        VALUES (%s, %s,%s ,%s, %s, %s, %s)
    """, (duree, date_visite,heure_visite ,motif, id_patient, num_chambre, nom_dep))
    num_visite = cursor.lastrowid

    print(f"✅ Visite {num_visite} ajoutée avec succès pour le patient {nom} {prenom}.")

    conn.commit()
    return True

# Fonction pour retrouver le médecin du patient
def medecin_du_patient(cursor, id_patient):
    cursor.execute("""select id_medecin , nom_medecin from vue_visites_medecins *
                   where id_patient= %s;""",(id_patient))
    
    result = cursor.fetchone()
    if result:
        return f"👨‍⚕️ Médecin du patient : Dr. {result[1]} {result[0]}"
    else:
        return "⚠️ Aucun médecin trouvé pour ce patient."


def embaucher_medecin(conn):
    cursor = conn.cursor()

    # Demander les infos du médecin
    nom = input("Nom du médecin : ")
    prenom = input("Prénom du médecin : ")
    tel = input("Téléphone : ")
    email = input("Email : ")
    dep = input("Département (Cardiologie / Pédiatrie / Urgences) : ")
    type_med = input("Type (Consultation / Hospitalisation) : ")

    # Insertion dans PERSONNEL (num_personnel sera auto-généré)
    cursor.execute("""
        INSERT INTO PERSONNEL (telephone, date_embauche, e_mail, prenom, nom, NOM_DEP)
        VALUES (%s, CURDATE(), %s, %s, %s, %s)
    """, (tel, email, prenom, nom, dep))

    # Récupérer le num_personnel généré automatiquement
    nouveau_num = cursor.lastrowid

    # Insertion dans MEDECIN
    cursor.execute("""
        INSERT INTO MEDECIN (num_personnel, Type, Disponibilite)
        VALUES (%s, %s, TRUE)
    """, (nouveau_num, type_med.capitalize()))

    conn.commit()
    print(f"✅ Médecin {nom} {prenom} (ID: {nouveau_num}) ajouté avec succès.")

    cursor.close()

def embaucher_infirmiere(conn):
    cursor = conn.cursor()

    # Demander les infos de l'infirmier(e)
    nom = input("Nom de l'infirmier(e) : ")
    prenom = input("Prénom de l'infirmier(e) : ")
    tel = input("Téléphone : ")
    email = input("Email : ")
    dep = input("Département (Cardiologie / Pédiatrie / Urgences) : ")

    # Trouver le dernier num_personnel
    cursor.execute("SELECT num_personnel FROM PERSONNEL ORDER BY num_personnel")
    resultats = cursor.fetchall()
    dernier_num = resultats[-1][0] if resultats else 0
    nouveau_num = dernier_num + 1

    # Étape 1 : insérer dans PERSONNEL
    cursor.execute("""
        INSERT INTO PERSONNEL (num_personnel, telephone, date_embauche, e_mail, prenom, nom, NOM_DEP)
        VALUES (%s, %s, CURDATE(), %s, %s, %s, %s)
    """, (nouveau_num, tel, email, prenom, nom, dep))

    # Étape 2 : insérer dans INFIRMIERE
    cursor.execute("""
        INSERT INTO INFIRMIERE (num_personnel, Disponibilite)
        VALUES (%s, TRUE)
    """, (nouveau_num,))

    conn.commit()
    print(f"✅ Infirmier(e) {nom} {prenom} (ID: {nouveau_num}) ajouté(e) avec succès.")

    cursor.close()


def afficher_visites_patient(cursor):
    id_patient = int(input("Entrer l'ID du patient à rechercher : "))

    cursor.execute("""
        SELECT v.num_visite, v.date_visite, v.motif, v.NOM_DEP, p.nom, p.prenom
        FROM VISITE v
        JOIN PATIENT p ON p.id_patient = v.id_patient
        WHERE p.id_patient = %s
        ORDER BY v.date_visite DESC
    """, (id_patient,))

    visites = cursor.fetchall()

    if not visites:
        print(f"⚠️ Aucun historique trouvé pour l'ID patient {id_patient}.")
    else:
        print(f"\n📋 Historique des visites pour {visites[0][4]} {visites[0][5]} (ID: {id_patient}) :\n")
        for visite in visites:
            print(f"- Visite #{visite[0]} | Date : {visite[1]} | Motif : {visite[2]} | Département : {visite[3]}")

    



# Connexion MySQL
time.sleep(3)
quit=False
try:
    conn = mysql.connector.connect(
        host="localhost",
        user="youssef",
        password="youssef0000",
        database="hospital_database"
    )
    cursor = conn.cursor()

    print("=== Gestion des visites hospitalières ===")
    while True:

        choix=input("c'est quoi votre demande (nouveau patient 'N', embauche 'E', autre 'A'):")
        if choix == 'N':
            inserer_patient_et_visite(cursor, conn)
            quit=False
            
        elif choix=='E':
            m_ou_f=input("embaucher un medecin ou un einfirmiere(M/I):")
            if m_ou_f == 'M':
                embaucher_medecin(conn)
                quit=False
            else: 
                embaucher_infirmiere(conn)
                quit=False

        elif choix=='A':
            h_ou_t=input("Tapez 'H' pour afficher l'historique des visites d'un patient ou 'T' pour afficher une Table :")
            if h_ou_t == 'H' :
                afficher_visites_patient(cursor)
                quit=False
            else :
                choix_de_table=input("Choisi une des tables (EFFECTUE E/ PARTICIPE PAR/ ANALYSE_MEDICAL A/ CONSULTATION CON/ HOSPITALISATION H/ VISITE V/ INFIRMIERE I/ MEDECIN M/ PERSONNEL PER/ DEPARTEMENT D/ CHAMBRE CH/ PATIENT PAT) :")
                tables = {
                    'E': 'EFFECTUE',
                    'PAR': 'PARTICIPE',
                    'A': 'ANALYSE_MEDICAL',
                    'CON': 'CONSULTATION',
                    'H': 'HOSPITALISATION',
                    'V': 'VISITE',
                    'I': 'INFIRMIERE',
                    'M': 'MEDECIN',
                    'PER': 'PERSONNEL',
                    'D': 'DEPARTEMENT',
                    'CH': 'CHAMBRE',
                    'PAT': 'PATIENT'
                }
        
                # Vérifier si le choix est valide
                if choix_de_table in tables:
                    table_name = tables[choix_de_table]
                    try:
                        # Exécuter la requête pour récupérer toutes les données de la table
                        cursor.execute(f"SELECT * FROM {table_name}")
                        
                        # Récupérer les noms des colonnes
                        columns = [desc[0] for desc in cursor.description]
                        
                        # Récupérer toutes les lignes
                        rows = cursor.fetchall()
                        
                        # Afficher les résultats
                        print(f"\nContenu de la table {table_name}:\n")
                        print("\t".join(columns))  # Afficher les noms des colonnes
                        for row in rows:
                            print("\t".join(str(value) for value in row))  # Afficher chaque ligne
                        
                    except mysql.connector.Error as err:
                        print(f"❌ Erreur lors de l'affichage de la table {table_name}: {err}")
                else:
                    print("❌ Choix de table invalide.")

except mysql.connector.Error as err:
    print(f"❌ Erreur : {err}")

finally:
    if 'conn' in locals() and conn.is_connected():
        cursor.close()
        conn.close()