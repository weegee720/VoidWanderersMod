-----------------------------------------------------------------------------
-- Save mission report
-----------------------------------------------------------------------------
function CF_SaveMissionReport(c, rep)
	-- Dump mission report to config to be saved 
	for i = 1, CF_MaxMissionReportLines do
		c["MissionReport"..i] = nil
	end					
	
	for i = 1, #rep do
		c["MissionReport"..i] = rep[i]
	end
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
