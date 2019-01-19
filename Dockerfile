FROM node:11-alpine AS build

ADD . /src
WORKDIR /src

RUN yarn install
RUN yarn build

FROM node:11-alpine
LABEL appname="GithubHooksDocker"
LABEL author="Larry Schirmer"
LABEL twitter="@larryschirmer"

ENV PORT=5000
EXPOSE $PORT

ENV DIR=/usr/src/service
WORKDIR $DIR

COPY --from=build /src/package.json package.json
COPY --from=build /src/yarn.lock yarn.lock
COPY --from=build /src/node_modules node_modules
COPY --from=build /src/build build

RUN yarn global add serve
CMD ["serve", "-s", "build"]