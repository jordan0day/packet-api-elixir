FROM elixir:1.7.4-alpine

WORKDIR /opt/packet_api_elixir

# Install git
RUN set -xe \
  && apk --update add git openssh

# Install hex, rebar

RUN set -xe \
  && mix local.hex --force \
  && mix local.rebar --force

# Fetch deps
COPY mix.exs .
COPY mix.lock .
COPY deps deps
RUN set -xe \
  && mix deps.get

# Copy code
COPY config config
COPY test test
COPY lib lib

#  compile
RUN set -xe \
  && mix compile

# Run the tests
RUN set -xe \
  && mix test

# Fire up the IEx session...
CMD [ "iex", "-S", "mix" ]
