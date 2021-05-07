# Rapport laboratoire HTTP infrastructure RES 2021
## Auteurs
- Forestier Quentin
- Herzig Melvyn

---
## Étape 1) Mise en place d'un site statique avec apache httpd
Cette étape consiste à mettre un place une image Docker permettant de créer 
des conteneurs avec php:7.2 et déployer un site statique.

### Apache-php-image
Le répertoire (<i> Docker/apache-php-image</i>) contient le dockerfile permettant
la création du conteneur décrit plus haut.

Contenu du dockerfile:
```
FROM php:7.2-apache
COPY content/ /var/www/html/
```

Il indique la version de php sur laquelle construire l'image. Ensuite il copie le répertoire <i>content/</i> (local)
dans le répertoire <i>/var/www/html/</i> (du container). Ce dernier est utilisé pour la recherche des pages du site. Il est configurable dans
<i>/etc/apache2/sites-available/000-default.conf</i>.

### Template
Le template a été téléchargé sur: <a>https://startbootstrap.com/theme/agency</a>

![site1](figures/site1.png)

### État de l'infrastructure
Un navigateur est capable de consulter les sites des deux conteneurs fabriqués à partir de Apache-php-image.
![étape1](figures/infra1.png)

---
## Étape 2) Mise en place d'un site dynamique avec expresse
Cette étape consiste à mettre un place une image Docker permettant de créer 
des conteneurs avec node:14.16 et déployer un site dynamique

### Expresse-image
Le répertoire (<i> Docker/expresse-image</i>) contient le dockerfile permettant
la création du conteneur décrit plus haut.

Contenu du dockerfile:
```
FROM node:14.16
COPY src/ /opt/app
CMD ["node", "/opt/app/index.js"]
```

Il indique la version de node.js sur laquelle construire l'image. Ensuite il copie le répertoire <i>src/</i> (local)
dans le répertoire <i>/opt/app</i> (du container). La seconde commande effectue un transfert de l'applicatif local dans le conteneur. Finalement, on définit
qu'il faut démarrer node.js sur notre application, au démarrage du conteneur.  

### Contenu dynamique
À l'aide d'expresse.js , le site utilise la dépendance [sentencer](https://kylestetz.github.io/Sentencer/) pour générer des adjectifs et des noms
aléatoires. Nous formons ensuite des pseudos aléatoires formés de la façon suivante: <adjectif1> <adjectif2> <nom>
  
Les pseudos (entre 1 et 10) sont ensuite encapsulé un payload Json depuis la fonction <i>generateCoolNames()</i>.

L'application accepte des requêtes sur le port 3000
```
var Sentencer = require('sentencer');
var express = require('express');
var app = express();


/**
 * When we get a request we send an array of cool names.
 */
app.get('/', function(req, res){
    res.send(generateCoolNames());
});

/**
 * Accept request on port 3000.
 */
app.listen(3000, function(){
    console.log("Accepting HTTP requests on port 3000!");
});

/**
 * This functions generates between 0 and 10 names (adj adj noun)
 * @returns Array containing the names.
 */
function generateCoolNames()
{
    var numberOfNames = Math.floor((Math.random() * 10) + 1);

    var names = [];

    for(var i = 0; i < numberOfNames; ++i)
    {
        names.push({coolName: Sentencer.make("{{ adjective }} {{ adjective }} {{ noun }}")})
    }

    return names;
}
```

### Résultat d'une connexion
Voici le résultat d'une connexion avec postman.

![connexion](figures/connexion2.png)

### État de l'infrastructure
Il est possible d'effectuer des requêtes avec un navigateur, un client telnet ou postman.
![étape2](figures/infra2.png)
