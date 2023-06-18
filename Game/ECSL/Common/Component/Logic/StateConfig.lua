StateConfig = {}

StateConfig.FSM = Enum.New({
    State = "StateFSM",
    Move = "MoveFSM",
    Fight = "FightFSM",
})

StateConfig.FSMState = Enum.New({
    Idle = "IdleFSMState",
    Move = "MoveFSMState",
    Run = "RunFSMState",

    Fight = "FightFSMState",
})

StateConfig.FSMConfig = {
    [StateConfig.FSM.State] = {
        States = {
            StateConfig.FSMState.Move,
            StateConfig.FSMState.Fight,
        },
        ExitTo = {}
    },
    [StateConfig.FSM.Move] = {
        States = {
            StateConfig.FSMState.Idle,
            StateConfig.FSMState.Move,
            StateConfig.FSMState.Run,
        },
        ExitTo = {
            [StateConfig.FSMState.Move] = StateConfig.FSMState.Idle,
            [StateConfig.FSMState.Run] = StateConfig.FSMState.Move,
        }
    },
    [StateConfig.FSM.Fight] = {
        States = {
            StateConfig.FSMState.Fight,
        },
        ExitTo = {}
    },
}

return StateConfig
