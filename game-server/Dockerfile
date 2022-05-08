FROM ubuntu:xenial as builder

ENV GODOT_VERSION "3.4.4"
RUN apt update -y && apt install curl unzip -y
RUN curl -l https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip -o g_h.zip &&\
	unzip g_h.zip -d tools/ &&\
	mv tools/* tools/godot_headless &&\
	rm -rf g_h.zip

RUN curl -l https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -o templates.tpz && \
    mkdir ~/.local/share/godot/templates/3.4.4.stable -p && \
    unzip -j templates.tpz -d ~/.local/share/godot/templates/3.4.4.stable && \
    rm -rf templates.tpz

RUN mkdir -p /data/builds/linux && mkdir -p /data/game

COPY . /data/game
RUN tools/godot_headless --path /data/game --export-pack --quiet server /data/builds/linux/server.pck

FROM ubuntu:xenial
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxcursor1 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /data/builds/linux/server.pck /data/game-server.pck
COPY --from=builder /tools/godot_headless /data/godot_headless
WORKDIR /data
ENTRYPOINT ["./godot_headless", "--main-pack", "game-server.pck"]

