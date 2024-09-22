# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM elixir:1.17.2-otp-27-alpine

## XXX: Might require `ENV LANG=en_US.utf8` instead according to
## https://github.com/docker-library/postgres/blob/master/16/alpine3.19/Dockerfile#L49-L51
ENV LANG=en_US.UTF-8

RUN apk add --update --no-cache gcc g++ make postgresql openrc

EXPOSE 5432

## HACK: Start postgresql as secondary service
## https://github.com/gliderlabs/docker-alpine/issues/437#issuecomment-662501986
RUN rc-update add postgresql
RUN mkdir /run/openrc
RUN touch /run/openrc/softlevel
## FIXME: FATAL: postgresql is already starting
RUN rc-service postgresql start

WORKDIR /app
COPY . .

ENV MIX_ENV=dev
ENV DATABASE_URL=postgres://postgres:postgres@localhost:5432/app
RUN mix deps.get
RUN mix ecto.setup

CMD ["mix", "phx.server"]
