# Projet Processeur
 Création et simulation d'un processeur Arm-7
 
 PROCESSEUR_V1 : Fonctionnel sans la gestion de MEM
    PROBLEME : -Les LW et SW ne fonctionne pas
               -Branchement excuté et branchement suivant cause 1 cycle de gel en plus 

 PROCESSEUR_V2 : Ajout de l'étage MEM
    PROBLEME : -Les Bypass de Mem à Exe fonctionné pas après 1 cycle de gel
               -Les LW juste après un Branchement ne fonction pas
               -Branchement excuté et branchement suivant cause 1 cycle de gel en plus

 PORCESSEUR_V3 : Déplacement de la gestion des bypass de DECOD à REG
    A AJOUTER : -Les Mtrans et Multiplication