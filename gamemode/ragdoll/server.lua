minUnconscious = CreateConVar("hrp_minunconscious", 25, FCVAR_ARCHIVE)

hook.Add("EntityTakeDamage", "HRP_Ragdoll", function (target, dmg)
	if !target:IsPlayer() then
		return
	end

    if (target:Health() / target:GetMaxHealth()) * 100 <= minUnconscious:GetInt() then
        local rag = ents.Create("prop_ragdoll")
        rag:SetPos(target:GetPos())
        rag:SetModel(target:GetModel())
        rag:SetVelocity(target:GetVelocity())
        rag:Spawn()
        rag:Activate()
        rag:SetNWString("owner", target:SteamID64())

        target:SetParent(target)
        target:SetNoDraw(true)
        target:DrawViewModel(false)
        target:Spectate(OBS_MODE_CHASE)
        target:SpectateEntity(rag)

        timer.Create(target:SteamID64() .. "_ragdoll", 10, 1, function ()
            target:SetParent()
            target:UnSpectate()
            --target:Spawn()
            target:DrawViewModel(true)
            target:Spawn()
            target:SetPos(rag:GetPos())
            rag:Remove()
            target:SetNoDraw(false)
        end)
    end
end)