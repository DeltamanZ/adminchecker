script_author("Deltaman")
script_dependencies("moonloader")
script_description("Admin checker, a Martin Show Pidoras")
script_version(1)

local folder = getWorkingDirectory().."/deltaman/adminChecker/" -- хуярим переменную, чтоб этот путь каждый раз не писать 
local adminlist = folder.."/admins.txt" -- тоже самое

local admins = {}  -- массив в который закинем админов
local online_admins = {} -- масисв в который каждый раз закидывать анлайн админов

function main()
    while not isSampAvailable() do wait(0) end -- ждём загрузки игры
    sampRegisterChatCommand("admins", checkIt) -- регистрируем команду и привязываем к функции checkIt
    createDirectory(folder) -- создаем папку, а то io.open не умеет
    local file = io.open(adminlist, "a+") -- открываем (пытаемся) файл с админами
    if file == nil then -- если файла нет
        if not doesDirectoryExist(folder) then createDirectory(folder) end -- проверим на всякий случай, вдруг папка не создалась -_-
        file = io.open(adminlist, "w") -- создаем файл в режиме записи
        file:close() -- Закрываем его, нахуй он нам пустой то нужен
    else-- если есть
        local fileData = file:read("*a") -- читаем файлик, записываем все в паременную
        file:close()
        admins = split(fileData, "\n") -- разбиваем на массив по символу переноса строки
        print("{B22222}[AdminChecker]: {FFFFFF}Админов загружено: {008800}"..#admins) -- палимся с админ чекером в консоль (можно удалить)
    end
    wait(-1) -- заставляем плагин ждать вечно, чтоб не завершился
    
end

function checkIt() -- та самая функция

    local file = io.open(adminlist, "a+") -- открываем (пытаемся) файл с админами
    if file == nil then -- если файла нет
        if not doesDirectoryExist(folder) then createDirectory(folder) end -- проверим на всякий случай, вдруг папка не создалась -_-
        file = io.open(adminlist, "w") -- создаем файл в режиме записи
        file:close() -- Закрываем его, нахуй он нам пустой то нужен
    else-- если есть
        local fileData = file:read("*a") -- читаем файлик, записываем все в паременную
        file:close()
        admins = split(fileData, "\n") -- разбиваем на массив по символу переноса строки
        print("{B22222}[AdminChecker]: {FFFFFF}Админов загружено: {008800}"..#admins) -- палимся с админ чекером в консоль (можно удалить)
    end
    
    for k, val in pairs(online_admins) do online_admins[k] = nil end -- чистим онлайн админов с прошлого раза

    for i=0, 999 do -- цикл, перебираем все айдишники сервера
        if sampIsPlayerConnected(i) then -- проверяем подключено ли тело с данным айди
            for k, val in pairs(admins) do -- заползаем в еще один цикл (да, очень рационально), перебираем всех админов
                if val:find(sampGetPlayerNickname(i)) then -- делаем поиск по строке, а не ее полное сравнение, потому что там могут быть пробелы
                    online_admins[#online_admins+1] = sampGetPlayerNickname(i).." [ID: "..i.."]" -- добавляем в массив онлайн админов на сервере 
                end
            end
        end
    end

    sampAddChatMessage(" Админы Online:", 0xffff00) -- сообщение
    for k, val in pairs(online_admins) do  -- цикл онлайн админов
        sampAddChatMessage(" "..val, 0xf5deb3) -- выводим админа
    end

end


function split(inputstr, sep)  -- спизженная функция сплита с интернета https://stackoverflow.com/questions/1426954/split-string-in-lua
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end