#!/bin/bash

if [ -f /etc/nginx/default.d/roboshop.conf ]; then
  sed -i -e "s/ENV/${ENV}/" /etc/nginx/default.d/roboshop.conf /etc/filebeat/filebeat.yml
  systemctl restart nginx
  systemctl restart filebeat
  exit
fi
MEM=$(echo $(free -m  | grep ^Mem | awk '{print $2}')*0.8 |bc | awk -F . '{print $1}')
sed -i -e "s/ENV/${ENV}/" -e "s/DOCDB_ENDPOINT/${MONGODB_ENDPOINT}/" -e "/java/ s/MEM/$MEM/" -e "/java/ s/1439/$MEM/" /etc/systemd/system/${COMPONENT}.service /etc/filebeat/filebeat.yml

systemctl daemon-reload
systemctl restart ${COMPONENT}
systemctl enable ${COMPONENT}
systemctl restart filebeat
