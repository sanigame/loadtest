# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.10

ARG JMETER_VERSION="5.1.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_LIB_CMDRUNNER_URL https://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar
ENV JMETER_LIB_CMN_JMETER_URL https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-cmn-jmeter/0.4/jmeter-plugins-cmn-jmeter-0.4.jar
ENV JMETER_LIB_JSON_LIB_URL https://search.maven.org/remotecontent?filepath=net/sf/json-lib/json-lib/2.4/json-lib-2.4-jdk15.jar
ENV JMETER_LIB_RANDOM_CSV_URL https://search.maven.org/remotecontent?filepath=com/blazemeter/jmeter-plugins-random-csv-data-set/0.6/jmeter-plugins-random-csv-data-set-0.6.jar

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Asia/Bangkok"
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& curl -L --silent ${JMETER_LIB_CMDRUNNER_URL} >  /tmp/dependencies/cmdrunner-2.2.jar  \
	&& curl -L --silent ${JMETER_LIB_CMN_JMETER_URL} >  /tmp/dependencies/jmeter-plugins-cmn-jmeter-0.4.jar  \
	&& curl -L --silent ${JMETER_LIB_JSON_LIB_URL} >  /tmp/dependencies/json-lib-2.4-jdk15.jar  \
	&& curl -L --silent ${JMETER_LIB_RANDOM_CSV_URL} >  /tmp/dependencies/jmeter-plugins-random-csv-data-set-0.6.jar  \
	&& cp /tmp/dependencies/cmdrunner-2.2.jar /opt/apache-jmeter-${JMETER_VERSION}/lib \
	&& cp /tmp/dependencies/jmeter-plugins-cmn-jmeter-0.4.jar /opt/apache-jmeter-${JMETER_VERSION}/lib \
	&& cp /tmp/dependencies/json-lib-2.4-jdk15.jar /opt/apache-jmeter-${JMETER_VERSION}/lib \
	&& cp /tmp/dependencies/jmeter-plugins-random-csv-data-set-0.6.jar /opt/apache-jmeter-${JMETER_VERSION}/lib/ext \
	&& rm -rf /tmp/dependencies

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
