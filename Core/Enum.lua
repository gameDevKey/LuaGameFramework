local GetAutoIndex = GetAutoIncreaseFunc()
ERedPointState = {
    Inactive = GetAutoIndex(),
    Active = GetAutoIndex(),
}

local GetAutoIndex = GetAutoIncreaseFunc()
EFSMState = {
    StateA = GetAutoIndex(),
    StateB = GetAutoIndex(),
}

local GetAutoIndex = GetAutoIncreaseFunc()
EEventType = {
    EventA = GetAutoIndex(),
    EventB = GetAutoIndex(),
}