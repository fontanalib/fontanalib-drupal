ARG TARGET_PHP_VERSION=7.3-fpm
FROM php:${TARGET_PHP_VERSION}-alpine
# USER root
RUN set -ex; \
	\
  apk update; \
  apk add --no-cache openssl wget; \
  \
# # download helper script
# @see https://github.com/mlocati/docker-php-extension-installer/
wget -q -O /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
    || (echo "Failed while downloading php extension installer!"; exit 1); \
  \
chmod uga+x /usr/local/bin/install-php-extensions && sync && install-php-extensions \
    gd \
    imagick \
    opcache \
    pdo_mysql \
		pdo_pgsql \
    zip \
    xdebug \
    yaml \
;
# npm install -g gulp gulp-cli
RUN apk update && apk add --no-cache \
    sudo \
    tzdata \
    autoconf \
    automake \
    bash \
    bind-tools \
    curl \
    g++ \
    gcc \
    gdb \
    git \
    gnupg \
    grep \
    htop \
    libstdc++ \
    libgcc \
    ltrace \
    make \
    procps \
    python \
    shadow \
    strace \
    sysstat \
    unzip \
    zlib \
;
ENV NODE_VERSION 12.14.1

RUN apk add --no-cache --virtual .build-deps \
        curl \
    && ARCH= && alpineArch="$(apk --print-arch)" \
      && case "${alpineArch##*-}" in \
        x86_64) \
          ARCH='x64' \
          CHECKSUM="6906577d7b15cc940f47fc88436ac45f73e5abecd15f09d8f2a9ea337fc2fe5e" \
          ;; \
        *) ;; \
      esac \
  && if [ -n "${CHECKSUM}" ]; then \
    set -eu; \
    curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
    echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
    echo "Building from source" \
    # backup build
    && apk add --no-cache --virtual .build-deps-full \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    && for key in \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
      gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps-full \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && apk del .build-deps

# ENV YARN_VERSION 1.21.1

# RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
#   && for key in \
#     6A010C5166006599AA17F08146C2130DFD2497F5 \
#   ; do \
#     gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
#     gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
#     gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
#   done \
#   && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
#   && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
#   && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
#   && mkdir -p /opt \
#   && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
#   && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
#   && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
#   && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
#   && apk del .build-deps-yarn
# set timezone
ARG TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
# # RUN dpkg-reconfigure -f noninteractive tzdata
# RUN echo ${TZ} >/etc/timezone && dpkg-reconfigure -f noninteractive tzdata
# set timezone
# RUN printf "%s\n"                                              \
#        "tzdata  tzdata/Areas    select America"            \
#        "tzdata  tzdata/Zones/America    select New_York"   \
#        | debconf-set-selections
# RUN DEBIAN_FRONTEND=noninteractive apt-get install --reinstall tzdata
# RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
ARG ARG_APP_USER=www-data
ARG ARG_APP_GROUP=www-data
ARG ARG_APP_USER_ID=82
ARG ARG_APP_GROUP_ID=82

COPY ./php/scripts/  /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

RUN /tmp/scripts/create_user.sh ${ARG_APP_USER} ${ARG_APP_GROUP} ${ARG_APP_USER_ID} ${ARG_APP_GROUP_ID}

# php config
COPY ./config/php/conf.d/*  /usr/local/etc/php/conf.d/

# php-fpm pool config
COPY ./config/php/php-fpm.d/* /usr/local/etc/php-fpm.d
RUN /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_USER" \
    "${ARG_APP_USER}" \
 && /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_GROUP" \
    "${ARG_APP_GROUP}" \
;
# RUN printf "\nopcache.enable = 0" >> /usr/local/etc/php/conf.d/zz-drupal.ini
ARG DRUPAL_USER=drupal
ARG DRUPAL_USER_ID=828

RUN useradd -m -g users -G ${ARG_APP_GROUP} ${DRUPAL_USER}

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chown -R drupal:users /usr/local/bin/composer

# workdir
ARG APP_CODE_PATH="/var/www/html"
ENV APP_ROOT="${APP_CODE_PATH}"
COPY ./composer.json $APP_CODE_PATH
WORKDIR "$APP_CODE_PATH"


#mkdir -p /project/drupal && mkdir -p /project/production && 


RUN chown drupal:${ARG_APP_GROUP} composer.json

USER drupal
RUN composer install

RUN mkdir -p $APP_CODE_PATH/web/sites/default/files
# RUN chown -R drupal:nginx web
RUN mkdir -p $APP_CODE_PATH/web/modules/custom && mkdir -p $APP_CODE_PATH/web/themes/custom
RUN chown -R drupal:${ARG_APP_GROUP} ${APP_CODE_PATH}/web && chmod g+s ${APP_CODE_PATH}/web
RUN chmod 775 $APP_CODE_PATH/web/sites/default/files
USER root


RUN rm -rf /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/* \
       /var/log/lastlog \
       /var/log/faillog
RUN npm install --global gulp-cli@latest

USER drupal
COPY ./php/docker-entrypoint.sh /
EXPOSE 9000 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]