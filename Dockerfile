FROM haproxy:latest
USER root
RUN apt-get update
RUN apt-get remove lua5.1 lua5.3 -y
RUN apt-get install -y lua5.4 luarocks libmaxminddb0 libmaxminddb-dev liblua5.4-dev

RUN apt-get install -y cmake make gcc g++
RUN luarocks --lua-version=5.4 install geoip2
#RUN luarocks install lua-mmdb
#COPY build/geolocate.lua /var/lib/haproxy/geolocate.lua
#COPY code/isp/GeoIP2-ISP.mmdb /var/lib/haproxy/GeoIP2-ISP.mmdb
USER haproxy
