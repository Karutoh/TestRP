function GM:ShowSpare2(ply)
	net.Start("HRP_OpenF4Menu")

		local table = GetJobsTable()
		local skills = GetSkills()

		if !table then
			table = {}
		end

		if !skills then
			skills = {}
		end

		net.WriteTable(table)
		net.WriteTable(skills)

	net.Send(ply)
end

net.Receive("HRP_F4MenuSetJob", function(len, ply)
	local category = net.ReadString()
	local title = net.ReadString()
	local rank = net.ReadString()

	if ply:GetNWString("jobTitle") != title then
		if SetPlayerJob(ply, category, title, rank) then
			ply:PrintMessage(HUD_PRINTTALK, "You have successfully switched jobs to " .. title)
		else
			ply:PrintMessage(HUD_PRINTTALK, "There was an error switching to that job!")
		end		
	else
		ply:PrintMessage(HUD_PRINTTALK, "You are already set to that job!")
	end
end)