_G["ChecarMaxGaragem"] = ChecarMaxGaragem

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

	--  TriggerClientEvent("Notify",source,"msg","Garagem Máxima: <b>"..maxSlots.."</b>", 5000)	
	return maxSlots
end