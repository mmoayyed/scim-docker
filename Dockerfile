FROM centos:centos7

MAINTAINER Misagh Moayyed

ENV PATH=$PATH:$JRE_HOME/bin

RUN yum -y install maven wget tar unzip git \
    && yum -y clean all

# Download Azul Java, verify the hash, and install \
RUN set -x; \
    java_version=8.0.131; \
    zulu_version=8.21.0.1; \
    java_hash=1931ed3beedee0b16fb7fd37e069b162; \
    cd / \
    && wget http://cdn.azul.com/zulu/bin/zulu$zulu_version-jdk$java_version-linux_x64.tar.gz \
    && echo "$java_hash  zulu$zulu_version-jdk$java_version-linux_x64.tar.gz" | md5sum -c - \
    && tar -zxvf zulu$zulu_version-jdk$java_version-linux_x64.tar.gz -C /opt \
    && rm zulu$zulu_version-jdk$java_version-linux_x64.tar.gz \
    && ln -s /opt/zulu$zulu_version-jdk$java_version-linux_x64/jre/ /opt/jre-home;

RUN cd / \
	&& wget http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip \
    && unzip ZuluJCEPolicies.zip \
    && mv -f ZuluJCEPolicies/*.jar /opt/jre-home/lib/security \
    && rm ZuluJCEPolicies.zip;

ENV JAVA_HOME /opt/jre-home
ENV PATH $PATH:$JAVA_HOME/bin:.

RUN git clone --depth 1 --single-branch --branch develop https://github.com/apache/directory-scimple.git scimple

RUN cd scimple \
    && mvn clean install -T 10 -DskipTests

RUN mvn --version \
    && echo $MAVEN_HOME \
    && echo $M2_HOME

COPY run.sh scimple

RUN chmod 750 /opt/jre-home/bin/java \
    && chmod 750 /scimple/run.sh;

EXPOSE 8080

WORKDIR /scimple/scim-server/scim-server-example/scim-server-memory

CMD ["/scimple/run.sh"]