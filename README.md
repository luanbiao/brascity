# Brascity Server Scripts

![Brascity](https://raw.githubusercontent.com/luanbiao/brascity/main/bclogo/ui/img/logo.png)

Alguns scripts criados para o servidor de FiveM Brascity

## Status
🚧 Cancelado

# BCCarros
 
## Carros
 
- /addcarros [nomedoveiculo] [jogadorID] (checa max garagem)
- /remcarros [nomedoveiculo] [jogadorID]
- /limparcarros [jogadorID] (exibe confirmação)
- /listarcarros [jogadorID]
 
## Garagem
 
- /addgaragem [jogadorID] [Removido: Não existe porque depende da permissão / aqui daria para vender o slot separado, mas ai precisaria persistir]
- /remgaragem [jogadorID] [Removido: Não existe porque depende da permissão]
- /listarslotsgaragem [jogadorID] (Usa o ChecarMaxGaragem())
 
## Utility
 
- /checarmaxgaragem [jogadorID]
- /listarslotsgaragem [jogadorID]
- /contarcarros [jogadorID]

## Adicionar Carro

-Adicionar carro /addcarro [nomedoveiculo] [iddojogador]
-Desc: O comando é usado por admin para adicionar um carro para um jogador, esse carro vai para a garagem [OK]
-É necessário verificar se o jogador possui espaço na garagem para receber esse carro [Função: ChecarMaxGaragem()] [OK]
-Essa verificação consulta a permissão do jogador, que define a quantidade maxima de slots da garagem [Função: QuantidadeCarros <= ChecarMaxGaragem()] [OK]
-Verifica também quantos carros o jogador tem na garagem, para saber se ele já atingiu o limite [OK]
-Não precisa persistir os dados [OK]

# BCGrupos

O sistema de grupo deve: 
- Adiciona grupo player
- Remove grupo player
- Lista grupo player
- Mostrar todos os cargos hospital
- Mostrar todos os cargos policia

## Comando
gruposadd [id_do_player] [nomedogrupo]

# BCLogo

Adiciona logo personalizado centralizado no topo da tela do jogador

# BCInstagram

Snippet de gerenciamento de permissão para celular vRP
