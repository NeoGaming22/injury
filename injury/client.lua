local display = false
local ragdoll = false
local hp

function setRagdoll(flag)
    ragdoll = flag
end

RegisterNetEvent("nic_injury:on")
AddEventHandler(
    "nic_injury:on",
    function()
        SendNUIMessage(
            {
                type = "ui",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_injury:off")
AddEventHandler(
    "nic_injury:off",
    function()
        SendNUIMessage(
            {
                type = "ui",
                display = false
            }
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            Citizen.InvokeNative(0xF5F6378C4F3419D3, PlayerPedId(), 100)
            local dead = Citizen.InvokeNative(0x3317DEDB88C95038, PlayerPedId(), true)
            local hp = Citizen.InvokeNative(0x82368787EA73C0F7, PlayerPedId())
            if dead then
                TriggerEvent("nic_injury:off")
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            hp = Citizen.InvokeNative(0x82368787EA73C0F7, PlayerPedId())
            local dead = Citizen.InvokeNative(0x3317DEDB88C95038, PlayerPedId(), true)
            local health
            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
            if (hp == false or hp >= 41) then
                TriggerEvent("nic_injury:off")
            elseif (hp == false or hp <= 40) then
                TriggerEvent("nic_injury:on")
                Citizen.Wait(2000)
                Citizen.InvokeNative(0xF0A4F1BBF4FA7497, PlayerPedId(), 1, 0, 0)
                Citizen.Wait(30000)
                Blackout()
            end
            if ragdoll then
                Blackout(x, y, z, hp)
            end
        end
    end
)

function Blackout()
    local hp = Citizen.InvokeNative(0x82368787EA73C0F7, PlayerPedId())
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    DoScreenFadeOut(1000)
    Citizen.InvokeNative(0xAE99FB955581844A, PlayerPedId(), 8000, 0, 0, 0, 0, 0)
    Wait(2000)
    DoScreenFadeIn(1000)
    --TriggerEvent("redemrp_notification:start", "You Blackout", 2, "error")
end

ragdoll = false
