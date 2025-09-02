Config = {}

-- HUD color indices (vanilla)
Config.Colors = {
  RED = 6, GREEN = 184, YELLOW = 190, BLUE = 206, ORANGE = 17, PURPLE = 145, CYAN = 210, WHITE = 0, BLACK = 1
}

-- Default sound to play with notifications (nil to disable)
Config.Sound = {
  name = 'SELECT', -- e.g. SELECT / BACK / ERROR
  set  = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
}

-- Dev quick tests (commands): /grl_test_on, /grl_test_off, /grl_test
Config.EnableDevCommands = false
