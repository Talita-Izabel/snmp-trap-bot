#!/bin/bash
# 
# INICIO
# bot_script

# Obtém o diretório do script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Obtém o diretório do projeto (um nível acima do script)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")

#source ShellBot.sh
source ./ShellBot.sh
source "$PROJECT_DIR/.env"

# Token do bot
bot_token=$BOT_TOKEN

# Chat grupo
chat_id=$CHAT_ID

# Inicializando o bot
ShellBot.init --token "$bot_token"

# Imprime o username do bot.
ShellBot.username

# Envia mensagem para o chat informado
ShellBot.sendMessage --chat_id ${chat_id} \
                                        --text "$1" \
                                        --parse_mode markdown
