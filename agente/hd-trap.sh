#!/bin/bash

COMMUNITY="mypublic"
TRAP_RECEIVER="192.168.4.50"
LAST_USAGE_FILE="/tmp/last_hd_usage"

# OID para obter o espaço usado do HD (pode variar dependendo da configuração SNMP)
OID_USED=".1.3.6.1.2.1.25.2.3.1.6.42"
OID_TOTAL=".1.3.6.1.2.1.25.2.3.1.5.42"

# Obtém valores via SNMP
USED=$(snmpwalk -v 2c -c $COMMUNITY localhost $OID_USED | awk '{print $4}')
TOTAL=$(snmpwalk -v 2c -c $COMMUNITY localhost $OID_TOTAL | awk '{print $4}')

# Calcula percentual de uso
if [[ -n "$USED" && -n "$TOTAL" && "$TOTAL" -ne 0 ]]; then
    HD_USAGE=$(( 100 * USED / TOTAL ))

    # Lê o último valor armazenado (se existir)
    LAST_USAGE=0
    if [[ -f $LAST_USAGE_FILE ]]; then
        LAST_USAGE=$(cat $LAST_USAGE_FILE)
    fi

    if [[ "$HD_USAGE" -gt 80 && "$HD_USAGE" -gt "$LAST_USAGE" ]]; then
        echo "Uso do HD acima de 80%! Enviando trap..."
        snmptrap -v 2c -c $COMMUNITY $TRAP_RECEIVER '' \
        .1.3.6.1.4.1.8072.2.3.0.1 \
        .1.3.6.1.4.1.8072.2.3.2.2 s "🚨 Uso do HD acima de 80%! Uso atual: ${HD_USAGE}%"
    fi

    # Atualiza o arquivo com o novo valor
    echo "$HD_USAGE" > "$LAST_USAGE_FILE"
else
    echo "Erro ao obter dados SNMP."
fi

