local State = {}

export type State = "Idle" | "Attacking" | "Defending" | "Moving" | "Running" | "Stunned"

export type StateTable = {[State]: boolean}

local Character = script.Parent.Parent
local Humanoid = Character:WaitForChild("Humanoid")

local STATE_TABLE: StateTable = {
    Idle = true,
    Attacking = false,
    Defending = false,
    Moving = false,
    Running = false,
    Stunned = false
}

local function isAlive()
    return Humanoid.Health > 0
end

local function isState(stateName: State): boolean
    return STATE_TABLE[stateName]
end

local function setState(stateName: State, value: boolean): ()
    STATE_TABLE[stateName] = value
end

function State.isIdle(): boolean
    return isState("Idle")
end

function State.isAttacking(): boolean
    return isState("Attacking")
end

function State.isDefending(): boolean
    return isState("Defending")
end

function State.isMoving(): boolean
    return isState("Moving")
end

function State.isRunning(): boolean
    return isState("Running")
end

function State.isStunned(): boolean
    return isState("Stunned")
end

function State.isAlive(): boolean
    return isAlive()
end

function State.update()
    if not isAlive() then
        setState("Idle", false)
        setState("Attacking", false)
        setState("Defending", false)
        setState("Moving", false)
        setState("Running", false)
        setState("Stunned", true)
    end
end

return State