# SNMP Trap Bot

Este projeto é um sistema de monitoramento que utiliza **SNMP (Simple Network Management Protocol)** para verificar o status de interfaces de rede e o espaço de armazenamento de discos rígidos. Quando um problema é detectado (como uma interface cair ou o espaço em disco atingir um limite), o sistema envia notificações via **Telegram** para alertar os administradores.

## Funcionalidades

### 1. **Monitoramento de Interfaces de Rede**
   - Verifica o status de interfaces de rede (por exemplo, `enp3s0`, `eth0`, `wlan0`).
   - Envia uma notificação via Telegram se uma interface cair (status `down`).

### 2. **Monitoramento de Espaço de Armazenamento**
   - Verifica o espaço utilizado em discos rígidos.
   - Envia uma notificação via Telegram se o espaço em disco atingir um limite configurável (por exemplo, 80% de uso).

### 3. **Notificações via Telegram**
   - Notificações em tempo real para alertar sobre problemas.
   - Configuração fácil usando um bot do Telegram.

## Configuração do Ambiente

Para rodar este projeto, você precisa configurar as seguintes variáveis de ambiente no arquivo `.env`:

- `BOT_TOKEN`: Token do bot do Telegram (obtido via [BotFather](https://core.telegram.org/bots#botfather)).
- `CHAT_ID`: ID do chat onde as notificações serão enviadas.

### Exemplo de `.env`:

```bash
BOT_TOKEN=seu_token_aqui
CHAT_ID=seu_chat_id_aqui
```

## Documentação

Para um guia detalhado de configuração do SNMP, consulte o [Relatório de Configuração do SNMP](https://github.com/Talita-Izabel/snmp-trap-bot/relatorio-snmp-trap.pdf).

## Projetos Relacionados

- [shellbot](https://github.com/shellscriptx/ShellBot.git)

## Colaboradores

- [Talita](https://github.com/Talita-Izabel)
- [Vitor](https://github.com/VitorST1)
- [Igor](https://github.com/IgorAuguusto)