#!/bin/bash

LOG_FILE="/var/log/snmp_trap.log"

# Captura toda a entrada do snmptrapd e salva no log
echo "$(date): Recebido do snmptrapd" >> "$LOG_FILE"

# Ler a entrada linha por linha
while read line; do
    # Filtrar a linha que contém a mensagem
    if [[ "$line" == *"NET-SNMP-EXAMPLES-MIB::netSnmpExampleHeartbeatName"* ]]; then
        # Extrair a mensagem real (após o último espaço)
        MESSAGE=$(echo "$line" | awk -F 'NET-SNMP-EXAMPLES-MIB::netSnmpExampleHeartbeatName ' '{print $2}')
        echo "$(date): $MESSAGE" >> "$LOG_FILE"
    fi

    if [[ "$line" == *"Uso do HD acima de 80%"* ]]; then 
        MESSAGE=$(echo "$line" | awk -F 'Uso do HD acima de 80%' '{print $2}') 
        /root/gerencia/bot-telegram.sh "🚨 Uso do HD acima de 80%! ${MESSAGE}" 
    fi 
done

#sudo /root/trabalho-gerencia/bot-telegram.sh "$MESSAGE"
/root/trabalho-gerencia/bot-telegram.sh "$MESSAGE" >> /var/log/bot-telegram.log 2>&1

