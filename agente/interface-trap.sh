#!/bin/bash

COMMUNITY="mypublic"
TRAP_RECEIVER="192.168.0.121"
# Arquivo temporário para registrar o status da interface
STATUS_FILE="/tmp/interface_status.txt"

# Obtém todas as interfaces ativas (excluindo 'lo')
INTERFACES=$(snmpwalk -v2c -c $COMMUNITY localhost .1.3.6.1.2.1.2.2.1.2 | awk -F': ' '{print $2}')

echo "$INTERFACES"

# Se não houver interfaces, sai do script
if [ -z "$INTERFACES" ]; then
    echo "Nenhuma interface encontrada via SNMP!"
    exit 1
fi

# Criar arquivo de status caso não exista
[ ! -f "$STATUS_FILE" ] && touch "$STATUS_FILE"

echo "Teste 1"

# Loop para verificar o status de cada interface
while IFS= read -r INTERFACE; do
    # Obtém o índice SNMP da interface
    INDEX=$(snmpwalk -v2c -c $COMMUNITY localhost .1.3.6.1.2.1.2.2.1.2 | grep "$INTERFACE" | awk -F'.' '{print $2}' | awk '{print $1}')

    # Se não encontrou o índice, pula para a próxima interface
    if [ -z "$INDEX" ]; then
        continue
    fi

    # Obtém o status operacional da interface
    STATUS=$(snmpget -v2c -c $COMMUNITY localhost .1.3.6.1.2.1.2.2.1.8.$INDEX | awk -F' = ' '{print $2}' | grep -o '[0-9]\+')

    # Verifica se a interface já tem um status registrado no arquivo, ^ no regex significa "início da linha"
    PREV_STATUS=$(grep "^$INTERFACE " "$STATUS_FILE" | awk '{print $2}')

    # Se o status mudou, envia notificação e atualiza o arquivo
    if [[ "$STATUS" == "2" && "$PREV_STATUS" != "2" ]]; then
        echo "Interface $INTERFACE caiu! Enviando trap..."
        snmptrap -v 2c -c $COMMUNITY $TRAP_RECEIVER '' .1.3.6.1.4.1.8072.2.3.0.1 .1.3.6.1.4.1.8072.2.3.2.2 s "🚨 Interface $INTERFACE caiu!"
        sed -i "/^$INTERFACE /d" "$STATUS_FILE"
        echo "$INTERFACE 2" >> "$STATUS_FILE"

    elif [[ "$STATUS" == "1" && "$PREV_STATUS" != "1" ]]; then
        echo "Interface $INTERFACE voltou! Enviando trap..."
        snmptrap -v 2c -c $COMMUNITY $TRAP_RECEIVER '' .1.3.6.1.4.1.8072.2.3.0.1 .1.3.6.1.4.1.8072.2.3.2.2 s "✅ Interface $INTERFACE está ativa novamente!"
        sed -i "/^$INTERFACE /d" "$STATUS_FILE"
        echo "$INTERFACE 1" >> "$STATUS_FILE"
    fi

done <<< "$INTERFACES"
