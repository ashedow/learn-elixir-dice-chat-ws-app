#===========
# Build Stage
#===========
FROM elixir:1.10

EXPOSE 8080

COPY . /build

ARG APP
ENV MIX_ENV prod

WORKDIR /build/apps/$APP

# Install dependencies and build Release
RUN export MIX_ENV=prod && \
    mix deps.get && \
    mix release

RUN mix deps.get --only prod
RUN mix compile
RUN echo y | mix release.clean --implode
RUN mix release

WORKDIR /build

CMD ["/bin/sh"]