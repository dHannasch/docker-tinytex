FROM alpine:3.12 AS build

WORKDIR /root

RUN apk update \
    && apk --no-cache add \
        gcc \
        make \
        libc-dev \
        cairo-dev \
        poppler-dev

RUN \
    wget -O - https://github.com/dawbarton/pdf2svg/archive/v0.2.3.tar.gz | tar xzv && \
    cd pdf2svg-0.2.3 && \
    ./configure && \
    make && \
    make install



FROM alpine:3.12 AS runtime

RUN apk update && \
    apk --no-cache add \
        perl \
        wget \
        cairo-gobject \
        poppler-glib

WORKDIR /root

RUN wget -qO- "https://yihui.org/gh/tinytex/tools/install-unx.sh" | sh

COPY --from=build /usr/local/bin/pdf2svg /usr/local/bin
RUN ln -s /root/bin/* /usr/local/bin
RUN /root/.TinyTeX/bin/*/tlmgr path add