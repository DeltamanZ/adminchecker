script_author("Deltaman")
script_dependencies("moonloader")
script_description("Admin checker, a Martin Show Pidoras")
script_version(1)

local folder = getWorkingDirectory().."/deltaman/adminChecker/" -- õóÿðèì ïåðåìåííóþ, ÷òîá ýòîò ïóòü êàæäûé ðàç íå ïèñàòü 
local adminlist = folder.."/admins.txt" -- òîæå ñàìîå

local admins = {}  -- ìàññèâ â êîòîðûé çàêèíåì àäìèíîâ
local online_admins = {} -- ìàñèñâ â êîòîðûé êàæäûé ðàç çàêèäûâàòü àíëàéí àäìèíîâ

function main()
    while not isSampAvailable() do wait(0) end -- æä¸ì çàãðóçêè èãðû
    sampRegisterChatCommand("admins", checkIt) -- ðåãèñòðèðóåì êîìàíäó è ïðèâÿçûâàåì ê ôóíêöèè checkIt
    createDirectory(folder) -- ñîçäàåì ïàïêó, à òî io.open íå óìååò
    local file = io.open(adminlist, "a+") -- îòêðûâàåì (ïûòàåìñÿ) ôàéë ñ àäìèíàìè
    if file == nil then -- åñëè ôàéëà íåò
        if not doesDirectoryExist(folder) then createDirectory(folder) end -- ïðîâåðèì íà âñÿêèé ñëó÷àé, âäðóã ïàïêà íå ñîçäàëàñü -_-
        file = io.open(adminlist, "w") -- ñîçäàåì ôàéë â ðåæèìå çàïèñè
        file:close() -- Çàêðûâàåì åãî, íàõóé îí íàì ïóñòîé òî íóæåí
    else-- åñëè åñòü
        local fileData = file:read("*a") -- ÷èòàåì ôàéëèê, çàïèñûâàåì âñå â ïàðåìåííóþ
        file:close()
        admins = split(fileData, "\n") -- ðàçáèâàåì íà ìàññèâ ïî ñèìâîëó ïåðåíîñà ñòðîêè
        print("{B22222}[AdminChecker]: {FFFFFF}Àäìèíîâ çàãðóæåíî: {008800}"..#admins) -- ïàëèìñÿ ñ àäìèí ÷åêåðîì â êîíñîëü (ìîæíî óäàëèòü)
    end
    wait(-1) -- çàñòàâëÿåì ïëàãèí æäàòü âå÷íî, ÷òîá íå çàâåðøèëñÿ
    
end

function checkIt() -- òà ñàìàÿ ôóíêöèÿ

    local file = io.open(adminlist, "a+") -- îòêðûâàåì (ïûòàåìñÿ) ôàéë ñ àäìèíàìè
    if file == nil then -- åñëè ôàéëà íåò
        if not doesDirectoryExist(folder) then createDirectory(folder) end -- ïðîâåðèì íà âñÿêèé ñëó÷àé, âäðóã ïàïêà íå ñîçäàëàñü -_-
        file = io.open(adminlist, "w") -- ñîçäàåì ôàéë â ðåæèìå çàïèñè
        file:close() -- Çàêðûâàåì åãî, íàõóé îí íàì ïóñòîé òî íóæåí
    else-- åñëè åñòü
        local fileData = file:read("*a") -- ÷èòàåì ôàéëèê, çàïèñûâàåì âñå â ïàðåìåííóþ
        file:close()
        admins = split(fileData, "\n") -- ðàçáèâàåì íà ìàññèâ ïî ñèìâîëó ïåðåíîñà ñòðîêè
        print("{B22222}[AdminChecker]: {FFFFFF}Àäìèíîâ çàãðóæåíî: {008800}"..#admins) -- ïàëèìñÿ ñ àäìèí ÷åêåðîì â êîíñîëü (ìîæíî óäàëèòü)
    end
    
    for k, val in pairs(online_admins) do online_admins[k] = nil end -- ÷èñòèì îíëàéí àäìèíîâ ñ ïðîøëîãî ðàçà

    for i=0, 999 do -- öèêë, ïåðåáèðàåì âñå àéäèøíèêè ñåðâåðà
        if sampIsPlayerConnected(i) then -- ïðîâåðÿåì ïîäêëþ÷åíî ëè òåëî ñ äàííûì àéäè
            for k, val in pairs(admins) do -- çàïîëçàåì â åùå îäèí öèêë (äà, î÷åíü ðàöèîíàëüíî), ïåðåáèðàåì âñåõ àäìèíîâ
                if val:find(sampGetPlayerNickname(i)) then -- äåëàåì ïîèñê ïî ñòðîêå, à íå åå ïîëíîå ñðàâíåíèå, ïîòîìó ÷òî òàì ìîãóò áûòü ïðîáåëû
                    online_admins[#online_admins+1] = sampGetPlayerNickname(i).." [ID: "..i.."]" -- äîáàâëÿåì â ìàññèâ îíëàéí àäìèíîâ íà ñåðâåðå 
                end
            end
        end
    end

    sampAddChatMessage(" Àäìèíû Online:", 0xffff00) -- ñîîáùåíèå
    for k, val in pairs(online_admins) do  -- öèêë îíëàéí àäìèíîâ
        sampAddChatMessage(" "..val, 0xf5deb3) -- âûâîäèì àäìèíà
    end

end


function split(inputstr, sep)  -- ñïèçæåííàÿ ôóíêöèÿ ñïëèòà ñ èíòåðíåòà https://stackoverflow.com/questions/1426954/split-string-in-lua
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
