script_author("Deltaman")
script_dependencies("moonloader")
script_description("Admin checker, a Martin Show Pidoras")
script_version(1)

local folder = getWorkingDirectory().."/deltaman/adminChecker/" -- ������ ����������, ���� ���� ���� ������ ��� �� ������ 
local adminlist = folder.."/admins.txt" -- ���� �����

local admins = {}  -- ������ � ������� ������� �������
local online_admins = {} -- ������ � ������� ������ ��� ���������� ������ �������

function main()
    while not isSampAvailable() do wait(0) end -- ��� �������� ����
    sampRegisterChatCommand("admins", checkIt) -- ������������ ������� � ����������� � ������� checkIt
    createDirectory(folder) -- ������� �����, � �� io.open �� �����
    local file = io.open(adminlist, "a+") -- ��������� (��������) ���� � ��������
    if file == nil then -- ���� ����� ���
        if not doesDirectoryExist(folder) then createDirectory(folder) end -- �������� �� ������ ������, ����� ����� �� ��������� -_-
        file = io.open(adminlist, "w") -- ������� ���� � ������ ������
        file:close() -- ��������� ���, ����� �� ��� ������ �� �����
    else-- ���� ����
        local fileData = file:read("*a") -- ������ ������, ���������� ��� � ����������
        file:close()
        admins = split(fileData, "\n") -- ��������� �� ������ �� ������� �������� ������
        print("{B22222}[AdminChecker]: {FFFFFF}������� ���������: {008800}"..#admins) -- ������� � ����� ������� � ������� (����� �������)
    end
    wait(-1) -- ���������� ������ ����� �����, ���� �� ����������
    
end

function checkIt() -- �� ����� �������

    local file = io.open(adminlist, "a+") -- ��������� (��������) ���� � ��������
    if file == nil then -- ���� ����� ���
        if not doesDirectoryExist(folder) then createDirectory(folder) end -- �������� �� ������ ������, ����� ����� �� ��������� -_-
        file = io.open(adminlist, "w") -- ������� ���� � ������ ������
        file:close() -- ��������� ���, ����� �� ��� ������ �� �����
    else-- ���� ����
        local fileData = file:read("*a") -- ������ ������, ���������� ��� � ����������
        file:close()
        admins = split(fileData, "\n") -- ��������� �� ������ �� ������� �������� ������
        print("{B22222}[AdminChecker]: {FFFFFF}������� ���������: {008800}"..#admins) -- ������� � ����� ������� � ������� (����� �������)
    end
    
    for k, val in pairs(online_admins) do online_admins[k] = nil end -- ������ ������ ������� � �������� ����

    for i=0, 999 do -- ����, ���������� ��� ��������� �������
        if sampIsPlayerConnected(i) then -- ��������� ���������� �� ���� � ������ ����
            for k, val in pairs(admins) do -- ��������� � ��� ���� ���� (��, ����� �����������), ���������� ���� �������
                if val:find(sampGetPlayerNickname(i)) then -- ������ ����� �� ������, � �� �� ������ ���������, ������ ��� ��� ����� ���� �������
                    online_admins[#online_admins+1] = sampGetPlayerNickname(i).." [ID: "..i.."]" -- ��������� � ������ ������ ������� �� ������� 
                end
            end
        end
    end

    sampAddChatMessage(" ������ Online:", 0xffff00) -- ���������
    for k, val in pairs(online_admins) do  -- ���� ������ �������
        sampAddChatMessage(" "..val, 0xf5deb3) -- ������� ������
    end

end


function split(inputstr, sep)  -- ���������� ������� ������ � ��������� https://stackoverflow.com/questions/1426954/split-string-in-lua
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end