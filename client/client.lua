local points       = {}
local isCollecting = false

--
-- Threads
--

function startCollectionThread()
    points = {}

    AddTextEntry('pointDevAlert', 'Press ~INPUT_PICKUP~ (E) for vector3 or ~INPUT_DETONATE~ (G) for vector4.')

    CreateThread(function()
        while true do
            Wait(0)

            if not isCollecting then
                return
            end

            BeginTextCommandDisplayHelp('pointDevAlert')
            EndTextCommandDisplayHelp(0, false, false, -1)
        
            -- Save vector3 with E
                if IsControlJustReleased(0, 38) then
                local playerCoordinates = GetEntityCoords(PlayerPedId())

                playerCoordinates = (playerCoordinates - vector3(0.0, 0.0, 1.0))
        
                table.insert(points, {coords = playerCoordinates, heading = nil})
        
                TriggerEvent('chat:addMessage', {
                    color     = { 255, 0, 0 },
                    multiline = true,
                    args      = {"PointDev", ("Saved Point #%s: vector3(%s, %s, %s)"):format(
                        #points,
                        mathRound(playerCoordinates.x, 2),
                        mathRound(playerCoordinates.y, 2),
                        mathRound(playerCoordinates.z, 2)
                    )}
                })
            end
                
            -- Save vector4 with G
            if IsControlJustReleased(0, 47) then
                local playerCoordinates = GetEntityCoords(PlayerPedId())
                playerCoordinates = (playerCoordinates - vector3(0.0, 0.0, 1.0))
                local heading = GetEntityHeading(PlayerPedId())

                table.insert(points, {coords = playerCoordinates, heading = heading})

                TriggerEvent('chat:addMessage', {
                    color     = { 0, 255, 0 },
                    multiline = true,
                    args      = {"PointDev", ("Saved Point #%s: vector4(%s, %s, %s, %s)"):format(
                        #points,
                        mathRound(playerCoordinates.x, 2),
                        mathRound(playerCoordinates.y, 2),
                        mathRound(playerCoordinates.z, 2),
                        mathRound(heading, 2)
                    )}
                })
            end
        end
    end)
end

--
-- Functions
--

function mathRound(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

--
-- Commands
--

RegisterCommand('pointdev', function()
    if not isCollecting then
        isCollecting = true

        startCollectionThread()

        return
    end

    isCollecting = false

    TriggerServerEvent('encore_pointdev:points', points)
end)
