FROM cptactionhank/atlassian-confluence:6.13.23
USER root

ENV TZ="Asia/Shanghai"

RUN chmod +x /docker-entrypoint.sh

# 将代理破解包加入容器
COPY "atlassian-agent.jar" /opt/atlassian/confluence/
# 设置启动加载代理包
RUN echo 'export CATALINA_OPTS="-javaagent:/opt/atlassian/confluence/atlassian-agent.jar ${CATALINA_OPTS}"' >> /opt/atlassian/confluence/bin/setenv.sh
