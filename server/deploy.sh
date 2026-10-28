#!/bin/bash
# Richtet nginx + SSL fuer bauu-sanierung.de ein (als root ausfuehren)
set -e
cd /var/www/bauu-sanierung
git pull --ff-only
cp server/nginx-bauu-sanierung.conf /etc/nginx/sites-available/bauu-sanierung
ln -sf /etc/nginx/sites-available/bauu-sanierung /etc/nginx/sites-enabled/bauu-sanierung
nginx -t
systemctl reload nginx
if [ ! -d /etc/letsencrypt/live/bauu-sanierung.de ]; then
  certbot --nginx -d bauu-sanierung.de -d www.bauu-sanierung.de --non-interactive --redirect
fi
echo "---- TEST ----"
curl -sI https://bauu-sanierung.de | head -1
curl -sI https://www.bauu-sanierung.de/server/deploy.sh | head -1
echo "FERTIG"
