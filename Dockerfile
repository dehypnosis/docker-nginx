# Custom Nginx build with the bunch of 3rd party modules
# VERSION 1.0

FROM phusion/baseimage:0.9.18

MAINTAINER Pavel Derendyaev <dddpaul@gmail.com>

ENV NGINX_VERSION 1.9.9
ENV LANG=en_US.utf8

RUN apt-get update && apt-get -y install build-essential libpcre3-dev zlib1g-dev libssl-dev libgeoip-dev libluajit-5.1-dev liblua5.1-iconv0

# Install Nginx (configure options is taken mostly from ppa:nginx/stable)
ADD nginx-${NGINX_VERSION}.tar.gz /tmp/
ADD ngx_devel_kit /tmp/ngx_devel_kit/
ADD lua-nginx-module /tmp/lua-nginx-module/
ADD nginx_upstream_check_module /tmp/nginx_upstream_check_module/
ADD echo-nginx-module /tmp/echo-nginx-module/

RUN cd /tmp/nginx-${NGINX_VERSION} \
    && patch -p0 < /tmp/nginx_upstream_check_module/check_1.9.2+.patch \
	&& ./configure --with-cc-opt='-g -O2 -fPIE -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
	   --with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf \
	   --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid \
	   --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy \
	   --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module \
	   --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_addition_module --with-http_geoip_module \
	   --with-http_gunzip_module --with-http_gzip_static_module --with-http_v2_module --with-http_sub_module \
	   --add-module=/tmp/ngx_devel_kit \
	   --add-module=/tmp/lua-nginx-module \
	   --add-module=/tmp/nginx_upstream_check_module \
	   --add-module=/tmp/echo-nginx-module \
   	&& make && make install \
	&& mkdir -p /etc/nginx/sites-available \
	&& mkdir -p /etc/nginx/sites-enabled \
	&& mkdir -p /var/lib/nginx \
	&& chown -R www-data:www-data /var/lib/nginx

ADD nginx.conf /etc/nginx/
ADD lua /etc/nginx/lua
ADD lua-example.conf /etc/nginx/sites-available

# Runit Nginx service
RUN ln -snf /usr/share/nginx/sbin/nginx /usr/sbin/nginx
ADD nginx.sh /etc/service/nginx/run

# Disable IPv6 (require privileged mode)
ADD ipv6off.sh /etc/rc.local

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
