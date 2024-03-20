docker compose down --rmi all
docker compose up -d

# refresh supervisor
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start all
# refresh nginx
sudo systemctl restart nginx
sudo systemctl restart php8.2-fpm