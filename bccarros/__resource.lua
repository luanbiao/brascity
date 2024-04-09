local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

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
--------------------------------------------------------------------

function AdicionarCarro(source, carro, jogador_id)
	local max_garagem = ChecarMaxGaragem(source, jogador_id)
	local slots_garagem = QuantidadeCarros(source,jogador_id)
	
	if tonumber(slots_garagem) < max_garagem then

	  local admin_id = vRP.getUserId(source)
	  local jogador_source = vRP.getUserSource(jogador_id)
	  
	  vRP.prepare("vRP/adicionarCarro", [[
		INSERT IGNORE INTO vrp_user_vehicles (user_id, vehicle, detido, time, engine, body, fuel, ipva)
		VALUES (@user_id, @vehicle, @detido, @time, @engine, @body, @fuel, @ipva)
	  ]])
  
	  vRP.execute("vRP/adicionarCarro", {
		user_id = jogador_id,
		vehicle = carro,
		detido = 0,
		time = 0,
		engine = 1000,
		body = 1000,
		fuel = 100,
		ipva = os.time()
	  })
  
	 
	  slots_garagem = math.floor(slots_garagem + 1)
	  TriggerClientEvent("Notify", source, "sucesso", "Você adicionou o veículo <b>"..carro.."</b> para o Jogador ID: <b>"..jogador_id.."</b>.<br/>Ele possui "..slots_garagem.."/"..max_garagem .. " slots de garagem" , 10000)	
	  TriggerClientEvent("Notify", jogador_source, "msg", "Opa! Acaba de chegar um <b>"..carro.."</b> na sua garagem", 10000)
	else
	  TriggerClientEvent("Notify", source, "msg", "O jogador não possui mais slots: <b>"..slots_garagem.."/"..max_garagem, 5000)
	end
  end


RegisterCommand('addcarros', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id, "admin.permissao") then
		if args[1] and args[2] then
			AdicionarCarro(source, args[1], tonumber(args[2]))
		end
	end

end)

--------------------------------------------------------------------
---- REMOVER CARRO
---- Remover carro /remcarro [nomedoveiculo] [iddojogador]
---- Desc: O comando é usado por admin para remover um carro para um jogador, esse carro vai ser removido da garagem
--------------------------------------------------------------------

function RemoverCarro(source, carro, jogador_id)
	vRP.prepare("vRP/removerCarros",[[
		DELETE FROM vrp_user_vehicles WHERE user_id = @user_id and vehicle = @vehicle;
	]])
	
	local admin_id = vRP.getUserId(source)
	local jogador_source = vRP.getUserSource(jogador_id)
	vRP.execute("vRP/removerCarros", {
		user_id = jogador_id, vehicle = carro
	})

	TriggerClientEvent("Notify",source,"sucesso","Voce removeu o veículo <b>"..carro.."</b> para o Jogador ID: <b>"..jogador_id.."</b>.", 5000)	
	TriggerClientEvent("Notify",jogador_source,"msg","Opa! O veículo <b>"..carro.."</b>\n foi removido da sua garagem", 10000)	
end
	
RegisterCommand('remcarros', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if args[1] and args[2] then
		if vRP.hasPermission(user_id, "admin.permissao") then
				RemoverCarro(source, args[1], tonumber(args[2]))
		else
			TriggerClientEvent("Notify",source,"msg","Comando correto: <br/>/remcarros [nomedoveiculo] [iddojogador]", 5000)	
		end
	end
end)

--------------------------------------------------------------------
---- LIMPAR CARROS
---- Limpar carros /limparcarros [iddojogador] (exibe confirmação)
---- Desc: O comando é usado por admin para limpar todos os carros de um jogador
--------------------------------------------------------------------

  function LimparCarros(source, user_id)
	vRP.prepare("vRP/countVehicles", "DELETE FROM vrp_user_vehicles WHERE user_id = @user_id")
	vRP.execute("vRP/countVehicles", {user_id = user_id})
	TriggerClientEvent("Notify", source, "sucesso", "Todos os carros do jogador ID " .. user_id .. " foram removidos")
	--	listarCarros(source, tonumber(user_id))
  end
  
  RegisterCommand('limparcarros', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id, "admin.permissao") then
		if args[1] then
			if vRP.request(source,"Limpar carros do jogador ID:" .. user_id .. "?", 30) then
				LimparCarros(source, args[1])
				else 
					TriggerClientEvent("Notify", source, "ann", "Operação cancelada<br/>Nenhum carro excluído")
				end
		end
	end
end)

----------------------------------------------------------------------------------------
---- CONTAR CARROS
---- Contar carros /contarcarros [iddojogador]
---- Desc: O comando é usado por admin para mostrar a quantidade de carros de um jogador
----------------------------------------------------------------------------------------


function QuantidadeCarros(source, user_id)
	vRP.prepare("vRP/countVehicles", "SELECT COUNT(*) as quantidade_veiculos FROM vrp_user_vehicles WHERE user_id = @user_id")
	local quantidade = vRP.query("vRP/countVehicles", {user_id = user_id})
	local quantidadeString = ""
  
	for key, value in pairs(quantidade) do
	  local valueString = ""
	  for k, v in pairs(value) do
		valueString = tostring(v) .. ", "
	  end
	  valueString = string.sub(valueString, 1, -3) -- Remove the trailing comma and space
	  quantidadeString = valueString
	end
	return quantidadeString
	--TriggerClientEvent("Notify", source, "aviso", "<h1>Carros</h1><br/>Jogador ID: " .. user_id .. "<br/> <b>Quantidade:</b> " .. quantidadeString .. " carros", 10000)
  end


RegisterCommand('contarcarros', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	
	if vRP.hasPermission(user_id, "admin.permissao") then
	  if args[1] then
		local qtd_carros = QuantidadeCarros(source, tonumber(args[1]))
		TriggerClientEvent("Notify", source, "aviso", "<p style='font-size: 14px;margin-top:10px;background-color: yellow;color: black;'>Carros</p><br/>Jogador ID: " .. user_id .. "<br/> <b>Quantidade:</b> " .. qtd_carros .. " carros", 10000)
		else
		TriggerClientEvent("Notify",source,"msg","Comando correto: <br/>/contarcarros [iddojogador]", 5000)	
		end
	end
  end)

----------------------------------------------------------------------------------------
---- LISTAR CARROS
---- Contar carros /listarcarros [iddojogador]
---- Desc: O comando é usado por admin para mostrar os carros de um jogador
----------------------------------------------------------------------------------------

  
  function ListarCarros(source, user_id)
	vRP.prepare("vRP/countVehicles", "SELECT vehicle as veiculos FROM vrp_user_vehicles WHERE user_id = @user_id")
	local quantidade = vRP.query("vRP/countVehicles", {user_id = user_id})
	local quantidadeString = "<br/>"
	
	for key, value in pairs(quantidade) do
	  local valueString = ""
	  for k, v in pairs(value) do
		valueString = valueString .. "🚗 " .. tostring(v) .. "<br/>"
	  end
	  quantidadeString = quantidadeString .. valueString
	end
	
	TriggerClientEvent("Notify", source, "aviso", "<p style='font-size: 14px;margin-top:10px;background-color: yellow;color: black;'>Carros</p><br/><p style='font-size: 12px;'>Jogador ID: " .. user_id .. "</p><br/> <p style='font-size: 12px; margin-bottom: 20px;'>Carros do Jogador:<br/> " .. quantidadeString .. "</p>", 20000)
  end
  
  RegisterCommand('listarcarros', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	
	if vRP.hasPermission(user_id, "admin.permissao") then
	  if args[1] then
		ListarCarros(source, tonumber(args[1]))
		else
		TriggerClientEvent("Notify",source,"msg","Comando correto: <br/>/listarcarros [iddojogador]", 5000)	
		end
	end
  end)

 
----------------------------------------------------------------------------------------
---- LISTAR SLOTS GARAGEM
---- Contar carros /listarslotsgaragem [iddojogador]
---- Desc: O comando é usado por admin para mostrar os carros de um jogador
----------------------------------------------------------------------------------------

function ListarSlotsGaragem(source, jogador_id)
	local valor = QuantidadeCarros(source, jogador_id)
	local max_garagem = ChecarMaxGaragem(source, jogador_id)
	TriggerClientEvent("Notify",source,"msg","O jogador ID: " .. jogador_id .. "<br/>Possui "..valor.."/"..max_garagem.." slots de garagem", 5000)	
end

RegisterCommand('listarslotsgaragem', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if args[1] then
		if vRP.hasPermission(user_id, "admin.permissao") then
			ListarSlotsGaragem(source, tonumber(args[1]))
		end
	else
	TriggerClientEvent("Notify",source,"msg","Comando correto: <br/>/listarslotsgaragem [idodojogador]", 5000)	
	end
end)

	--------------------------------
	------ Checar permissao para slot

function ChecarMaxGaragem(source, jogador_id)

	local permissoes = {
		"prata-vip.permissao",
		"ouro-vip.permissao",
		"platina-vip.permissao",
		"rubi-vip.permissao",
		"diamante-vip.permissao",
		"brascity-vip.permissao"
	}

	local maxSlots = 0

		if vRP.hasPermission(jogador_id, "admin.permissao") then
			maxSlots = 3
			end

		for _, permissao in ipairs(permissoes) do
			if vRP.hasPermission(jogador_id, permissao) then
			maxSlots = 11
			break
			end
		end

	--  TriggerClientEvent("Notify",st/tource,"msg","Garagem Máxima: <b>"..maxSlots.."</b>", 5000)	
	return maxSlots
end

RegisterCommand('checarmaxgaragem', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

		if args[1] then
			if vRP.hasPermission(user_id, "admin.permissao") then
				local maxSlots ChecarMaxGaragem(source, tonumber(args[1]))
				TriggerClientEvent("Notify",source,"msg","Garagem Máxima: <b>"..maxSlots.."</b>", 5000)
			end
		else
		TriggerClientEvent("Notify",source,"msg","Comando correto: <br/>/checarmaxgaragem [idodojogador]", 5000)	
		end
end)

--[[
	-- ADD SLOT GARAGEM 

function AddGaragem(source,jogador_id)
			-- Atualiza slots de garagem
			local key = "garagem_slots"
			local slots_garagem = vRP.getUData(jogador_id, key)
			if slots_garagem then
				slots_garagem = slots_garagem + 1
			else
				slots_garagem = 1
			end

			vRP.setUData(jogador_id, key, tostring(slots_garagem))
			TriggerClientEvent("Notify",source,"sucesso","+1 slot de garagem<br>Adicionado para o jogador ID: " .. jogador_id, 5000)	
end

RegisterCommand('addslotgaragem', function(source, args, rawCommand)
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
	
		if args[1] then
			if vRP.hasPermission(user_id, "admin.permissao") then
				AddGaragem(source, tonumber(args[1]))
			end
		else
		TriggerClientEvent("Notify",source,"msg","Comando correto: <br/>/addslotgaragem [idodojogador]", 5000)	
		end
end)

-- REMOVER SLOT GARAGEM 

function RemGaragem(source,jogador_id)
		-- Atualiza slots de garagem
		local key = "garagem_slots"
		local slots_garagem = vRP.getUData(jogador_id, key)
		if slots_garagem then
			slots_garagem = slots_garagem - 1
		else
			slots_garagem = 0
		end

		vRP.setUData(jogador_id, key, tostring(slots_garagem))
		TriggerClientEvent("Notify",source,"sucesso","-1 slot de garagem<br>Adicionado para o jogador ID: " .. jogador_id, 5000)	
end

RegisterCommand('remslotgaragem', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if args[1] then
		if vRP.hasPermission(user_id, "admin.permissao") then
			RemGaragem(source, tonumber(args[1]))
		end
	else
	TriggerClientEvent("Notify",source,"msg","Comando correto: <br/>/remslotgaragem [idodojogador]", 5000)	
	end
end)
--]]
exports("ChecarMaxGaragem", ChecarMaxGaragem)
exports("ListarCarros", ListarCarros)

