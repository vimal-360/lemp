
#define variable as current dir as root
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# install php 8.2 with all the extentions in ubuntu 20.04
# Update the system
sudo apt update -y
sudo apt upgrade -y

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker Compose
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
docker compose version

# install nginx
sudo apt install nginx -y
# symlink config/nginx.conf
# sudo ln -s /var/www/html/config/nginx.conf /etc/nginx/sites-available/nginx.conf

## remove folder
sudo rm -rf /etc/nginx/sites-enabled
sudo ln -s {$DIR}/config/nginx.conf /etc/nginx/sites-enabled
# Start Nginx
sudo systemctl start nginx
# Enable Nginx
sudo systemctl enable nginx

# Check Nginx Status
sudo systemctl status nginx

# create folder /var/www/html and give permission
sudo mkdir -p /var/www/html
sudo chown -R $USER:$USER /var/www/html
sudo chmod -R 755 /var/www/html

# also var/www/
sudo chown -R $USER:$USER /var/www
sudo chmod -R 755 /var/www


# Install PHP 8.2
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install php8.2 -y

# Install PHP 8.2 Extensions
sudo apt install php8.2-common php8.2-mysql php8.2-xml php8.2-xmlrpc php8.2-curl php8.2-gd php8.2-imagick php8.2-cli php8.2-dev php8.2-imap php8.2-mbstring php8.2-opcache php8.2-soap php8.2-zip php8.2-intl -y

sudo apt remove apache2 -y
sudo apt purge apache2 -y
# Check PHP-FPM Status
sudo systemctl status php8.2-fpm
# Check PHP-FPM Configuration
# sudo cat /etc/php/8.2/fpm/php-fpm.conf
# # Check PHP-FPM Pool Configuration
# sudo cat /etc/php/8.2/fpm/pool.d/www.conf
# install supervisor and symlink config/supervisor.conf
sudo apt update -y
sudo apt install cron

sudo apt install supervisor -y
# sudo ln -s /config/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# remove folder
sudo rm -rf /etc/supervisor/conf.d
sudo ln -s {$DIR}/config/supervisor.conf /etc/supervisor/conf.d
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start all

