# https://blog.adoptium.net/2021/08/using-jlink-in-dockerfiles/

FROM eclipse-temurin:17-alpine AS jre-build

RUN apk add binutils

# Create a custom Java runtime using JLink
RUN $JAVA_HOME/bin/jlink \
         --add-modules java.base,java.desktop,java.instrument,java.logging,java.management,java.management.rmi,java.naming,java.net.http,java.prefs,java.rmi,java.security.jgss,java.security.sasl,java.sql,java.transaction.xa,java.xml,java.xml.crypto,jdk.unsupported,jdk.crypto.ec \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /java-runtime

FROM alpine:3.14
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /java-runtime $JAVA_HOME
