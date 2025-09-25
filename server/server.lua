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
-- Events
--

RegisterNetEvent('encore_pointdev:points')
AddEventHandler('encore_pointdev:points', function(points)
    local textString = ''

    for k,v in pairs(points) do
            if v.heading then
            textString = textString .. ("vector4(%s, %s, %s, %s),\n"):format(
                mathRound(v.coords.x, 2),
                mathRound(v.coords.y, 2),
                mathRound(v.coords.z, 2),
                mathRound(v.heading, 2)
            )
        else
        textString = textString .. ("vector3(%s, %s, %s),\n"):format(
                mathRound(v.coords.x, 2),
                mathRound(v.coords.y, 2),
                mathRound(v.coords.z, 2)
            )
        end
    end

    local time = os.time(os.date('*t'))

    SaveResourceFile(GetCurrentResourceName(), 'files/' .. time .. '.txt', textString)
end)
