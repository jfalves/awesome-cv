FROM alpine:latest

ARG FILE

RUN adduser --disabled-password --ingroup wheel awesome
RUN apk add sudo
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel

USER awesome

RUN sudo apk -U  upgrade
RUN sudo apk add fontconfig \
                 make \
                 patch \
                 perl \
                 texmf-dist \
                 wget \
                 xz

WORKDIR /usr/share/texmf-dist/

COPY config/texlive.profile .
RUN sudo ./install-tl -profile texlive.profile

RUN sudo tlmgr install adjustbox \
                       amsmath \
                       collectbox \
                       enumitem \
                       environ \
                       etoolbox \
                       everysel \
                       fancyhdr \
                       fontawesome \
                       fontspec \
                       geometry \
                       hyperref \
                       ifmtarg \
                       infwarerr \
                       kvoptions \
                       kvsetkeys \
                       ltxcmds \
                       parskip \
                       pgf \
                       ragged2e \
                       setspace \
                       sourcesanspro \
                       subfigure \
                       tcolorbox \
                       tools \
                       unicode-math \
                       wrapfig \
                       xcolor \
                       xetex \
                       xifthen \
                       xkeyval

RUN sudo mkdir /usr/share/fonts
RUN sudo ln -s /usr/local/texlive/2020/texmf-dist/fonts/opentype/ /usr/share/fonts/

COPY --chown=awesome:root Awesome-CV /opt/Awesome-CV
WORKDIR /opt/Awesome-CV

COPY config/awesome-cv.cls.patch .
RUN patch < awesome-cv.cls.patch
RUN rm awesome-cv.cls.patch

#COPY input/ .

ENV PATH="/usr/local/texlive/2020/bin/x86_64-linuxmusl:${PATH}"

