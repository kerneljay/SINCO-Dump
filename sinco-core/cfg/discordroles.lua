cfg = {
	Guild_ID = '1511049123519004784',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '1511049123519004784', 
		  ['Police'] = '1538506918585303071', 
		  ['NHS'] = '1388486010622443702',
		-- ['HMP'] = '1166683694602391602',
		-- ['LFB'] = '1151013382217007174',
		-- ['UKBF'] = '1220060099335422033',
  	},
	RoleList = {},

	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 1511474850324156647, -- 12
		['Lead Developer'] = 1538255328699744336, -- 11
		['Developer'] = 1538255326048948264, -- 10
		['Spawn Perms'] = 1431610843426193555, -- 10
		['Community Manager'] = 1515658335880483006, -- 9
		['Staff Manager'] = 1515658339474997278, -- 8
		['Head Administrator'] = 1515658340099686470, -- 7
		['Senior Administrator'] = 1515658340695539823, -- 6
		['Administrator'] = 1515658341358239774, -- 5
		['Senior Moderator'] = 1515658342008225832, -- 4
		["Homie"] = 1431610843325403136, -- Homie Role
		['Moderator'] = 1515658342628982875, -- 3
		['Support Team'] = 1515658343304269834, -- 2
		['Trial Staff'] = 1538255272592674866, -- 1
		['Car Developer'] = 1541860545505001482, -- car dev
		--['Border Force'] = , 
		['Cinematic'] = 1541913720643649558,
	},
	 ['Police'] = {
        ['Commissioner'] = 1538511231483248690,
        ['Deputy Commissioner'] = 1538511295899500614,
        ['Assistant Commissioner'] = 1538514757278109846, 
        ['Dep. Asst. Commissioner'] = 1538511374110433290,
        ['Commander'] = 1538511374601162862,
        ['Chief Superintendent'] =1538511375171719229 ,
        ['Superintendent'] = 1538511528674992198,
        ['Chief Inspector'] = 1538511533615620126,
        ['Inspector'] = 1538511535985659974,
        ['Sergeant'] = 1538511537046687754,
         ['Special Constable'] =1538511537587888159 ,
        ['Senior Constable'] = 1538511713228554261,
        ['PC'] = 1538511714033860688,
        ['PCSO'] = 1538511714499305582,
         ['Large Arms Access'] = 1538511714922799185,
        ['Police Horse Trained'] = 1538511844677918853,
        ['Drone'] = 1538511845214785587,
        ['NPAS'] = 1538511845835673680,
        ['Trident Command'] = 1538511846451978320,
         ['Trident Officer'] =1538511967625416774 , 
        ['K9 Trained'] = 1538511969827684402,
	 },
['NHS'] = {
        ['NHS Head Chief'] = 1388486094944735272,
        ['NHS Assistant Chief'] = 1388486917347082324,
        ['NHS Deputy Chief'] = 1388486984036515962,
        --['NHS Captain'] = 1388487047467110471,
        ['NHS Combat Medic'] = 1388487141901733969,
        ['NHS Consultant'] = 1388487185845588109,
        ['NHS Specialist'] = 1388487236466638958,
        ['NHS Senior Doctor'] = 1388487290392805567,
        ['NHS Doctor'] = 1388487366439735317,
        ['NHS Junior Doctor'] = 1388487417136152607,
        ['NHS Critical Care Paramedic'] = 1388487468092756120,
        ['NHS Paramedic'] = 1388487510539108553,
        ['NHS Trainee Paramedic'] = 1388487582786129931,
        ['Drone'] = 1388487614583148675,
        ['HEMS'] = 1388487663857831986,
    },
	-- ['HMP'] = {
	-- 	['Governor'] = 1093990155360161952,
	-- 	['Deputy Governor'] = 1093990155360161950,
	-- 	['Divisional Commander'] = 1093990155360161949,
	-- 	['Custodial Supervisor'] = 1093990155347562531,
	-- 	['Custodial Officer'] = 1093990155347562530,
	-- 	['Honourable Guard'] = 1093990155330781228,
	-- 	['Supervising Officer'] = 1093990155347562526,
	-- 	['Principal Officer'] = 1093990155330781233,      
	-- 	['Specialist Officer'] = 1093990155330781232,
	-- 	['Senior Officer'] = 1093990155330781231,
	-- 	['Prison Officer'] = 1093990155330781230,
	-- 	['Trainee Prison Officer'] = 1093990155330781229,
	-- },
	-- ['LFB'] = {
	-- 	['Chief Fire Command'] = 1151013476634992662,
	-- 	['Chief Fire Officer'] = 1151013467684356169,
	-- 	['Deputy Chief Fire Officer'] = 1151013470406463498,
	-- 	['Assistant Chief Fire Officer'] = 1151013472319053824,
	-- 	['Fire Command Advisor'] = 1151013476634992662,
	-- 	['Divisional Command'] = 1151013494121041930,
	-- 	['Firefighter'] = 1151013529143476254,
	-- 	['Crew Manager'] = 1151013526777909298,
	-- 	['Watch Manager'] = 1151013523707678773,
	-- 	['Station Manager'] = 1151013520801009775,
	-- 	['Group Manager'] = 1151013518930362388,
	-- 	['Area Manager'] = 1151013516363431966,
	-- 	['Sector Command'] = 1151013500051787878,
	-- 	['Divisional Officer'] = 1151013497128370278,
	-- 	['Honourable Firefighter'] = 1151013505504378951,
	-- },
	-- ['UKBF'] = {
	-- 	['Director General'] = 1220060380789739671,
	-- 	['Regional Director'] = 1220060382404546601,
	-- 	['Assistant Director'] = 1220060384266813520,
	-- 	['HM Inspector'] = 1220060396207996950,
	-- 	['Chief Immigration Officer'] = 1220060397382668370,
	-- 	['Tactical Command'] = 1220060397961347134,
	-- 	['Senior Immigration Officer'] = 1220060404558991461,
	-- 	['Higher Immigration Officer'] = 1220060405792116767,
	-- 	['Immigration Officer'] = 1220060406593355957,
	-- 	['Assistant Immigration Officer'] = 1220060410833797150,
	-- 	['Administrative Assistant'] = 1220060411618005116,
	-- 	['Special Officer'] = 1220060412242821191,
	-- 	['Cutters Specialist'] = 1220060424989446235,
	-- 	['Cutters Instructor'] = 1220060425832632504,
	-- 	['Chief Captain'] = 1220060426780283020,
	-- 	['Captain'] = 1220060427619401738,
	-- 	['Coxswain'] = 1220060428478972038,
	-- 	['Senior Deckhand'] = 1220060429120962591,
	-- 	['Deckhand'] = 1220060430769193131,
	-- },
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end





return cfg
