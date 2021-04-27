FROM madnificent/ember:3.25.3 as ember

MAINTAINER Arnaud SJongers <arnaud.sjongers@tenforce.com>

COPY package.* bower.* /app/
# Let's remove the .git in case it's linking to outside the container
RUN rm -rf .git && git init
RUN if [ -f "/app/bower.json" ]; then export GIT_DIR=/app; bower install; fi
RUN npm install
COPY . /app
RUN ember build --production

FROM nginx:1
RUN ln -s /usr/share/nginx/html /app
COPY --from=ember /app/dist /app
COPY nginx.conf /etc/nginx/conf.d/default.conf
