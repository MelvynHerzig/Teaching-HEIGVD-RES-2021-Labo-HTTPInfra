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
Write-Output "--- Demarrage des conteneurs apache static"
docker run -d --name apache_static1 res/apache_php
docker run -d --name apache_static2 res/apache_php


Write-Output "--- Demarrage des conteneurs expresse dynamic"
docker run -d --name express_dynamic1 res/express_names
docker run -d --name express_dynamic2 res/express_names


Write-Output "--- Demarrage du conteneur apache reverse proxy"
$static_app1 = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache_static1 
$static_app2 = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache_static2 
$dynamic_app1 = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' express_dynamic1
$dynamic_app2 = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' express_dynamic2
 

docker run -d -p 8080:80 -e STATIC_APP1=$($static_app1 + ':80') -e STATIC_APP2=$($static_app2 + ':80') -e DYNAMIC_APP1=$($dynamic_app1 + ':3000') -e DYNAMIC_APP2=$($dynamic_app2 + ':3000') --name apache_rp res/apache_rp