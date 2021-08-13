#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World!</h1>
<p>Database Address: ${db_address}</p>
<p>Database Port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &
