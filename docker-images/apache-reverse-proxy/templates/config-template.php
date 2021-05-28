<?php
  # Récupération des adresses des serveurs apache dynamiques
  $DYNAMIC_APP1 = getenv('DYNAMIC_APP1');
  $DYNAMIC_APP2 = getenv('DYNAMIC_APP2');

  # Récupération des adresses des serveurs apache "statiques"
  $STATIC_APP1 = getenv('STATIC_APP1');
  $STATIC_APP2 = getenv('STATIC_APP2');
?>

<VirtualHost *:80>

    ServerName demo.res.ch

    # Configuration du load balancing

    <Proxy "balancer://dynamic_cluster">
	    BalancerMember "http://<?php print "$DYNAMIC_APP1"?>"
	    BalancerMember "http://<?php print "$DYNAMIC_APP2"?>"
	</Proxy>

	Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED
    <Proxy "balancer://static_cluster">
	    BalancerMember "http://<?php print "$STATIC_APP1"?>" route=1
	    BalancerMember "http://<?php print "$STATIC_APP2"?>" route=2
		ProxySet stickysession=ROUTEID
	</Proxy>

    ProxyPass "/api/names/" "balancer://dynamic_cluster/"
    ProxyPassReverse "/api/names/" 'balancer://dynamic_cluster/"
      
    ProxyPass "/" "balancer://static_cluster/"
    ProxyPassReverse "/" "balancer://static_cluster/"

</VirtualHost>