# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM elixir:1.17.2-otp-27-alpine

ENV LANG=en_US.UTF-8
RUN apk add --update --no-cache gcc g++ make sqlite

WORKDIR /app
COPY . .

ENV MIX_ENV=dev
RUN mix deps.get
RUN mix ecto.setup

## FIXME: (Exqlite.Error) Database busy error
## https://github.com/elixir-sqlite/exqlite/issues/42
#RUN mix test

EXPOSE 4000

CMD ["mix", "phx.server"]
