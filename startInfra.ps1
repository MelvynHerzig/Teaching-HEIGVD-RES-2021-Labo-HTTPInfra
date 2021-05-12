# Nettoyage des conteneurs
Write-Output "--- Kill des conteneurs"
docker kill $(docker ps -qa)

Write-Output "--- Retrait des conteneurs"
docker rm $(docker ps -qa)

# Vérification de l'existence des images
$existApachePhp = docker images -q res/apache_php
if($null -eq $existApachePhp)
{
    Write-Output "--- Build apache_static"
    docker build -t res/apache_php ./docker-images/apache-php-image/
}

$existExpressDynamic = docker images -q res/express_names
if($null -eq $existExpressDynamic)
{
    Write-Output "--- Build express_dynamic"
docker build -t res/express_names ./docker-images/express-image/    
}

$existApacheRP = docker images -q res/apache_rp
if($null -eq $existApacheRP)
{
    Write-Output "--- Build apache_rp"
    docker build -t res/apache_rp ./docker-images/apache-reverse-proxy/
}

# Démarrage des conteneurs
Write-Output "--- Demarrage du conteneur apache static"
docker run -d --name apache_static res/apache_php


Write-Output "--- Demarrage du conteneur expresse dynamic"
docker run -d --name express_dynamic res/express_names


Write-Output "--- Demarrage du conteneur apache reverse proxy"
$static_app = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache_static 
$dynamic_app = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' express_dynamic
 

docker run -d -p 8080:80 -e STATIC_APP=$($static_app + ':80') -e DYNAMIC_APP=$($dynamic_app + ':3000') --name apache_rp res/apache_rp