-----------------------------------------------------------------------------------------------------------------------------------------
--[ vRP ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

----------------------------------------------------------------
-- |  _ \|  __ \     /\    / ____|/ ____|_   _|__   __\ \   / /
-- | |_) | |__) |   /  \  | (___ | |      | |    | |   \ \_/ / 
-- |  _ <|  _  /   / /\ \  \___ \| |      | |    | |    \   /  
-- | |_) | | \ \  / ____ \ ____) | |____ _| |_   | |     | |   
-- |____/|_|  \_\/_/    \_\_____/ \_____|_____|  |_|     |_|   
----------------------------------------------------------------
--		          :: Sistema de Grupos ::
-----------------------------------------------------------------
-- O sistema de grupo deve: 
-- Adicionar grupo player
-- Remover grupo player
-- Listar grupo player

-- Depois ele deve:
-- Mostrar todos os cargos hospital
-- Mostrar todos os cargos policia

-- Testar se dá para remover o owner

-- gruposadd [id_do_player] [nomedogrupo]

RegisterCommand("gruposadd", function(source, args, rawCommand)
    if args[1] and args[2] then
        local user_id = vRP.getUserId(source)
        if vRP.hasPermission(user_id, "admin.permissao") then
            if user_id then
            local groupToAdd = args[2] -- The group name to add
            local usuario = parseInt(args[1])
            local usuario_source = vRP.getUserSource(usuario) 

                if groupToAdd then
                    vRP.addUserGroup(usuario, groupToAdd)
                    TriggerClientEvent("Notify",source,"sucesso","Grupo: " .. args[2] .. " adicionado <br/>Para o player ID " .. args[1])
                    TriggerClientEvent("Notify",usuario_source,"sucesso","Agora você faz parte do grupo: " .. args[2])
                else
                    TriggerClientEvent("Notify",usuario_source,"negado","^1Comando: /gruposadd [id_player] [nomedogrupo]", 10000)
                end
            else
                TriggerClientEvent("Notify",usuario_source,"att","Você não tem permissão para esse comando.", 5000)
            end
        end
    end
end)

-- gruposremover [id_do_player] [nomedogrupo]
RegisterCommand("gruposremover", function(source, args, rawCommand)
    if args[1] and args[2] then
        local user_id = vRP.getUserId(source)
        if vRP.hasPermission(user_id, "admin.permissao") then
            if user_id then
            local groupToAdd = args[2] -- The group name to add
            local usuario = parseInt(args[1])
            local usuario_source = vRP.getUserSource(usuario) 

                if groupToAdd then
                    vRP.removeUserGroup(usuario, groupToAdd)
                    TriggerClientEvent("Notify",source,"sucesso","Grupo: " .. args[2] .. " removido <br/>Para o player ID " .. args[1])
                    TriggerClientEvent("Notify",usuario_source,"sucesso","Você não faz mais parte do grupo: " .. args[2])
                else
                    TriggerClientEvent("Notify",usuario_source,"negado","^1Comando: /gruposremover [id_player] [nomedogrupo]", 10000)
                end
            else
                TriggerClientEvent("Notify",usuario_source,"att","Você não tem permissão para esse comando.", 5000)
            end
        end
    end
end)

-- gruposremover [id_do_player] 
RegisterCommand("gruposlistar", function(source, args, rawCommand)
    if args[1] then
        local user_id = vRP.getUserId(source)
        if vRP.hasPermission(user_id, "admin.permissao") then
            if user_id then
                local usuario = parseInt(args[1])
                local usuario_source = vRP.getUserSource(usuario)

                
      local user_data = vRP.getUserDataTable(parseInt(args[1])) -- Obtém os dados do usuário
      if user_data then
       local groupList = ""
            for k,v in pairs(user_data.groups) do
                groupList = groupList .. k .. "<br/>" -- Concatenar cada nome de grupo na string
            end
            TriggerClientEvent("Notify", source, "sucesso", "Grupos do jogador ID " .. args[1] .. ":<br/>" .. groupList)
       else
           TriggerClientEvent("Notify", source, "negado", "Nenhum grupo encontrado para esse jogador.")
       end
       
       
           else
              TriggerClientEvent("Notify", source, "att", "Você não tem permissão para esse comando.", 5000)
            end
        end
    end
end)

    