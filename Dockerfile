FROM java:8-jre
MAINTAINER Christophe Augello <christophe@augello.be>

#Variables
ENV YOUTRACK_VERSION=6.5.17015
ENV YOUTRACK_HOME /opt/youtrack/

#Create path/user/group
RUN mkdir -p "$YOUTRACK_HOME"{bin,data,backup} && \
    groupadd youtrack -g 55 && \
    useradd youtrack -u 55 -g 55 -G youtrack -s /sbin/nologin -d "$YOUTRACK_HOME" && \
    test "$(id youtrack)" = "uid=55(youtrack) gid=55(youtrack) groups=55(youtrack)" $$ \

RUN curl https://download.jetbrains.com/charisma/youtrack-$YOUTRACK_VERSION.jar -O /opt/youtrack/bin/youtrack-$YOUTRACK_VERSION.jar

# Loosen permission bits to avoid problems running container with arbitrary UID
RUN chown -R youtrack.0 $YOUTRACK_HOME && chmod -R g+rwx $YOUTRACK_HOME

EXPOSE 8080

WORKDIR $YOUTRACK_HOME
VOLUME ["/opt/youtrack/data", "/opt/youtrack/backup"]
USER 55
CMD ["java -Xmx1g -XX:MaxPermSize=512m -Djava.awt.headless=true -Duser.home=/opt/youtrack -Ddatabase.location=/opt/youtrack/data -Ddatabase.backup.location=/opt/youtrack/backup -jar youtrack-${YOUTRACK_VERSION}.jar 8080"]
