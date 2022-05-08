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

ENTRYPOINT ["tools/godot_headless"]

