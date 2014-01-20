if ! grep -Fxq 'Europe/Amsterdam' /etc/timezone; then
  echo "Europe/Amsterdam" >/etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
  echo 'LANGUAGE="en_US.UTF-8"' >>/etc/default/locale
  echo 'LC_ALL="en_US.UTF-8"' >>/etc/default/locale
fi

if ! id -u couchdb >/dev/null 2>&1
then
  # http://wiki.apache.org/couchdb/Installing_on_Ubuntu
  # http://docs.couchdb.org/en/latest/install/unix.html

  apt-get update
  apt-get install -y g++ make curl \
    erlang-dev erlang-manpages erlang-base-hipe erlang-eunit erlang-nox erlang-xmerl erlang-inets \
    libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool

  wget -q http://ftp.tudelft.nl/apache/couchdb/source/1.5.0/apache-couchdb-1.5.0.tar.gz
  tar xfz apache-couchdb-1.5.0.tar.gz
  cd apache-couchdb-1.5.0
  ./configure
  make
  make install

  adduser --system \
          --home /usr/local/var/lib/couchdb \
          --no-create-home \
          --shell /bin/bash \
          --group --gecos \
          "CouchDB Administrator" couchdb

  chown -R couchdb:couchdb /usr/local/etc/couchdb
  chown -R couchdb:couchdb /usr/local/var/lib/couchdb
  chown -R couchdb:couchdb /usr/local/var/log/couchdb
  chown -R couchdb:couchdb /usr/local/var/run/couchdb

  chmod 0770 /usr/local/etc/couchdb
  chmod 0770 /usr/local/var/lib/couchdb
  chmod 0770 /usr/local/var/log/couchdb
  chmod 0770 /usr/local/var/run/couchdb

  ln -s /usr/local/etc/logrotate.d/couchdb /etc/logrotate.d/couchdb
  ln -s /usr/local/etc/init.d/couchdb /etc/init.d
  update-rc.d couchdb defaults

  echo -e "\n[httpd]\nbind_address = 0.0.0.0" >>/usr/local/etc/couchdb/local.ini

  service couchdb start
fi
