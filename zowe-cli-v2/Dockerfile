FROM --platform=linux/amd64 node:18

# Directory where Zowe CLI settings and plug-ins will be stored:
RUN mkdir /zowe
WORKDIR /zowe
ENV ZOWE_CLI_HOME=/zowe

# Install Zowe CLI:
RUN npm install -g @zowe/cli@zowe-v2-lts

# Install Zowe CLI plug-ins:
RUN zowe plugins install @broadcom/endevor-for-zowe-cli@next

# Enable daemon mode:
RUN zowe daemon enable
ENV PATH=/zowe/bin:${PATH}

# Working directory for the users of the image:
RUN mkdir /workspace
WORKDIR /workspace

# Use entry point that starts Zowe CLI daemon:
COPY docker-entrypoint.sh /zowe/
COPY imperative.json /zowe/settings/imperative.json
RUN chmod a+x /zowe/docker-entrypoint.sh
ENTRYPOINT [ "/zowe/docker-entrypoint.sh" ]
CMD ["zowe-init"]
