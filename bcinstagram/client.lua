-- instagramadd [id_do_player]
RegisterCommand("instagramadd", function(source, args, rawCommand)
    if args[1] then
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "admin.permissao") then
    if user_id then
        local groupToAdd = "instagram.permissao" -- The group name to add
		local usuario = parseInt(args[1])
		local usuario_source = vRP.getUserSource(usuario) 

        if groupToAdd then
            vRP.addUserGroup(usuario, groupToAdd)
            TriggerClientEvent("Notify",source,"sucesso","Verificado do Instagram \n" .. args[1] .. " adicionado <br/>Para o player ID " .. args[1])
			TriggerClientEvent("Notify",usuario_source,"importante","Parabéns! Você recebeu o verificado no Instagram!", 10000)
        else
            TriggerClientEvent("chatMessage", source, "^1Comando: /instagramadd [id_player]")
        end
    else
        TriggerClientEvent("chatMessage", source, "^Erro: Não foi possível adicionar o verificado do instagram.")
    end
end
end)

-- instagramadd [id_do_player]
RegisterCommand("instagramrem", function(source, args, rawCommand)
    if args[1] then
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "admin.permissao") then
    if user_id then
        local groupToAdd = "instagram.permissao" -- The group name to add
		local usuario = parseInt(args[1])
		local usuario_source = vRP.getUserSource(usuario) 

        if groupToAdd then
            vRP.removeUserGroup(usuario, groupToAdd)
            TriggerClientEvent("Notify",source,"sucesso","Verificado do Instagram removido <br/>Para o player ID " .. args[1])
			TriggerClientEvent("Notify",usuario_source,"importante","Que pena! O verificado do Instagram <br/>Foi removido \n", 10000)
        else
            TriggerClientEvent("chatMessage", source, "^1Comando: /instagramadd [id_player]")
        end
    else
        TriggerClientEvent("chatMessage", source, "^Erro: Não foi possível adicionar o verificado do instagram.")
    end
end
end)
