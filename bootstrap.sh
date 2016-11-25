# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-add-repository -y ppa:webupd8team/java >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential
install 'libgmp-dev' libgmp-dev
# rvm and ruby
echo installing ruby-1.8.7
su - vagrant -c 'rvm install ruby-1.8.7-head' >/dev/null 2>&1

install Git git
install SQLite sqlite3 libsqlite3-dev
#install memcached memcached
install Redis redis-server
#install RabbitMQ rabbitmq-server

#PostgreSQL
install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
sudo -u postgres createdb -O vagrant activerecord_unittest
sudo -u postgres createdb -O vagrant activerecord_unittest2

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE USER 'rails'@'localhost';
CREATE DATABASE activerecord_unittest  DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE activerecord_unittest2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.* to 'rails'@'localhost';
SQL
echo installing MongoDb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
#MongoDb 3
#echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
#sudo apt-get update >/dev/null 2>&1
#sudo apt-get install -y mongodb-org
#MongoDb 2
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y mongodb-org=2.6.9 mongodb-org-server=2.6.9 mongodb-org-shell=2.6.9 mongodb-org-mongos=2.6.9 mongodb-org-tools=2.6.9 --force-yes


install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'Imagemagick' imagemagick libmagickwand-dev libmagickcore-dev
install 'Qt Libs' libqt4-dev libqtwebkit-dev
echo installing Java JDK8
echo debconf shared/accepted-oracle-license-v1-1 select true | \
    sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
    sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
# Needed for docs generation.
#update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
echo installing aptitude
sudo apt-get install -y aptitude >/dev/null 2>&1
echo installing latex and pdflatex
aptitude install -y texlive-latex-base texlive-latex3 texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra libxml2-dev libxslt-dev
echo 'all set, rock on!'
