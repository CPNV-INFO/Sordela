# Sordela



## Comment lancer le site en mode kiosk

Pour lancer le site web en mode kiosk, il faut commencer par ajouter un paramètre au démarrage de Chrome.

1. Créer un raccourci de Google Chrome
2. Clic droit puis propriétés
3. Dans le champ "Cible", rajouter à la fin le paramètre suivant (un espace après le guillement) : 
> -kiosk http://urldusite.com/
4. Lancer Disable_Hotkeys_Sordela.exe qui se trouve dans le projet Sordela/Niels. Cet exécutable permet de bloquer les raccourcis suivants: 
    - Alt-Tab
    - Touches Windows
    - Alt-F4
    - Alt-Esc
    - Ctrl-T
    - Ctrl-N
    - Ctrl-Shift-N
    
5. Double cliquer sur le raccourci de Chrome
6. Pour désactiver le script, affichez les icônes cachés de la barre des tâches, en bas à droite, puis faite un clic droit sur <img src="http://image.noelshack.com/fichiers/2018/48/4/1543499446-telechargement.jpeg" alt="drawing" width="30"/>, puis "exit". 

Attention, les raccourcis comme Ctrl-Alt-Del et Ctrl-Shift-Esc ne peuvent pas être désactivé par un script AutoHotKey
