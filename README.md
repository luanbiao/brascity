# Brascity Server Scripts

![Brascity](https://desesquecedor.com.br/img/logo2.webp)

Alguns scripts criados para o servidor de FiveM Brascity

## Status
🚧 Cancelado

----------------------------------------------------------------
-- |  _ \|  __ \     /\    / ____|/ ____|_   _|__   __\ \   / /
-- | |_) | |__) |   /  \  | (___ | |      | |    | |   \ \_/ / 
-- |  _ <|  _  /   / /\ \  \___ \| |      | |    | |    \   /  
-- | |_) | | \ \  / ____ \ ____) | |____ _| |_   | |     | |   
-- |____/|_|  \_\/_/    \_\_____/ \_____|_____|  |_|     |_|   
----------------------------------------------------------------
--		:: Brascity Mineiro Cars and Garage System ::
-----------------------------------------------------------------

-- Funções:
-- 
-- ** Carros **
-- 
-- /addcarros [nomedoveiculo] [jogadorID] (checa max garagem)
-- /remcarros [nomedoveiculo] [jogadorID]
-- /limparcarros [jogadorID] (exibe confirmação)
-- /listarcarros [jogadorID]
-- 
-- ** Garagem **
-- 
-- /addgaragem [jogadorID] [Removido: Não existe porque depende da permissão / aqui daria para vender o slot separado, mas ai precisaria persistir]
-- /remgaragem [jogadorID] [Removido: Não existe porque depende da permissão]
-- /listarslotsgaragem [jogadorID] (Usa o ChecarMaxGaragem())
-- 
-- ** Utility **
-- 
-- /checarmaxgaragem [jogadorID]
-- /listarslotsgaragem [jogadorID]
-- /contarcarros [jogadorID]

--------------------------------------------------------------------
---- ADICIONAR CARRO
---- Adicionar carro /addcarro [nomedoveiculo] [iddojogador]
---- Desc: O comando é usado por admin para adicionar um carro para um jogador, esse carro vai para a garagem [OK]
---- É necessário verificar se o jogador possui espaço na garagem para receber esse carro [Função: ChecarMaxGaragem()] [OK]
---- Essa verificação consulta a permissão do jogador, que define a quantidade maxima de slots da garagem [Função: QuantidadeCarros <= ChecarMaxGaragem()] [OK]
---- Verifica também quantos carros o jogador tem na garagem, para saber se ele já atingiu o limite [OK]
---- Não precisa persistir os dados [OK]
