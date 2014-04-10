FROM ubuntu:12.04
MAINTAINER Michael Neale <mneale@cloudbees.com

# First, let us install Jenkins - as per aespinosa/docker-jenkins
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe >> /etc/apt/sources.list
RUN apt-get update && apt-get clean
RUN apt-get install -q -y openjdk-7-jre-headless && apt-get clean
ADD http://mirrors.jenkins-ci.org/war/1.558/jenkins.war /opt/jenkins.war
RUN ln -sf /jenkins /root/.jenkins
EXPOSE 8080
VOLUME ["/jenkins"]

# now we install docker in docker - thanks to https://github.com/jpetazzo/dind
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list
RUN apt-get update -qq
RUN apt-get install -qqy iptables ca-certificates lxc
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker
VOLUME /var/lib/docker



CMD wrapdocker & java -jar /opt/jenkins.war
