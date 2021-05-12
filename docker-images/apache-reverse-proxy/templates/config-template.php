<?php
  $DYNAMIC_APP = getenv('DYNAMIC_APP');
  $STATIC_APP = getenv('STATIC_APP');
?>

<VirtualHost *:80>

    ServerName demo.res.ch

    # ErrorLog ${APACHE_LOG_DIR}/error.log
    # CustomLog ${APACHE_LOG_DIR}/access.log combined
  
    ProxyPass '/api/names/' 'http://<?php print "$DYNAMIC_APP"?>/'
    ProxyPassReverse '/api/names/' 'http://<?php print "$DYNAMIC_APP"?>/'

    ProxyPass '/' 'http://<?php print "$STATIC_APP"?>/'
    ProxyPassReverse '/' 'http://<?php print "$STATIC_APP"?>/'

</VirtualHost>