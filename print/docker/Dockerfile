FROM camptocamp/mapfish_print:3.29

COPY root /
RUN update-ca-certificates
RUN keytool -importcert -file /usr/local/share/ca-certificates/RCJU-Issuing-1.crt -alias RCJU-Issuing-1 -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -noprompt
RUN keytool -importcert -file /usr/local/share/ca-certificates/RCJU-Issuing-2.crt -alias RCJU-Issuing-2 -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -noprompt
RUN keytool -importcert -file /usr/local/share/ca-certificates/RCJU-Root-CA.crt -alias RCJU-Root-CA -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -noprompt

