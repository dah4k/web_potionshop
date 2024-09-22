# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM elixir:1.17.2-otp-27-alpine

## XXX: Might require `ENV LANG=en_US.utf8` instead according to
## https://github.com/docker-library/postgres/blob/master/16/alpine3.19/Dockerfile#L49-L51
ENV LANG=en_US.UTF-8

RUN apk add --update --no-cache gcc g++ make postgresql postgresql-contrib openrc

EXPOSE 5432

## HACK: Start postgresql as secondary service
## https://github.com/gliderlabs/docker-alpine/issues/437#issuecomment-662501986
VOLUME [ "/sys/fs/cgroup" ]
RUN rc-update add postgresql
RUN mkdir /run/openrc
RUN touch /run/openrc/softlevel
## HACK: Workaround `postgresql is already starting` error
## https://github.com/gliderlabs/docker-alpine/issues/437#issuecomment-667456518
RUN rc-status && rc-service postgresql start

WORKDIR /app
COPY . .

ENV MIX_ENV=dev
ENV DATABASE_URL=postgres://postgres:postgres@localhost:5432/app
RUN mix deps.get
## FIXME: postgresql crashed before arriving here
RUN mix ecto.setup

CMD ["mix", "phx.server"]
