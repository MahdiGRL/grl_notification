local M = {}

-- Basic ticker
function M.ticker(msg, opts)
  opts = opts or {}
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(msg or "")
  GRL_UTIL.playDefaultSound()
  return EndTextCommandThefeedPostTicker(opts.flash or false, opts.saveToBrief or false)
end

-- Advanced with picture + headers
function M.advanced(args)
  args = args or {}
  if args.bgColor then ThefeedSetNextPostBackgroundColor(args.bgColor) end
  if not GRL_UTIL.ensureTxd(args.txd) then
    -- Fallback if TXD failed
    args.txd, args.txn = 'CHAR_SOCIAL_CLUB', 'CHAR_SOCIAL_CLUB'
  end
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(args.msg or "")
  GRL_UTIL.playDefaultSound()
  if args.durationMul then
    return EndTextCommandThefeedPostMessagetextTu(
      args.txd or "", args.txn or "", args.flash or false, args.iconType or 0,
      args.sender or "", args.subject or "", args.durationMul
    )
  else
    return EndTextCommandThefeedPostMessagetext(
      args.txd or "", args.txn or "", args.flash or false, args.iconType or 0,
      args.sender or "", args.subject or ""
    )
  end
end

-- Advanced with crew tag
function M.advancedCrew(args)
  args = args or {}
  if args.bgColor then ThefeedSetNextPostBackgroundColor(args.bgColor) end
  if not GRL_UTIL.ensureTxd(args.txd) then
    args.txd, args.txn = 'CHAR_SOCIAL_CLUB', 'CHAR_SOCIAL_CLUB'
  end
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(args.msg or "")
  GRL_UTIL.playDefaultSound()
  return EndTextCommandThefeedPostMessagetextWithCrewTag(
    args.txd or "", args.txn or "", args.flash or false, args.iconType or 0,
    args.sender or "", args.subject or "", args.clanTag or "___RP",
    args.r or 255, args.g or 255, args.b or 255
  )
end

-- Award notification (above minimap)
function M.award(titleLabel, msg, hudColorOverlay)
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(msg or "")
  GRL_UTIL.playDefaultSound()
  return EndTextCommandThefeedPostAwards(hudColorOverlay or 0, titleLabel or "")
end

-- Ped headshot icon
function M.headshot(msg, ped)
  ped = ped or PlayerPedId()
  local h = RegisterPedheadshot(ped)
  local timeout = GetGameTimer() + 2000
  while not IsPedheadshotReady(h) or not IsPedheadshotValid(h) do
    if GetGameTimer() > timeout then break end
    Wait(0)
  end
  local txd = GetPedheadshotTxdString(h)
  local handle = M.advanced({
    msg = msg or "Headshot",
    txd = txd, txn = txd, iconType = 1, sender = GetPlayerName(PlayerId()), subject = "",
    bgColor = Config.Colors.WHITE
  })
  UnregisterPedheadshot(h)
  return handle
end

-- Remove by handle
function M.remove(handle) if handle then RemoveNotification(handle) end end

-- Exports
exports("Ticker", M.ticker)
exports("Advanced", M.advanced)
exports("AdvancedCrew", M.advancedCrew)
exports("Award", M.award)
exports("Headshot", M.headshot)
exports("Remove", M.remove)

-- Preset passthroughs (handy)
exports("Success", function(msg) return GRL_PRESET.success(msg) end)
exports("Info",    function(msg) return GRL_PRESET.info(msg) end)
exports("Warning", function(msg) return GRL_PRESET.warning(msg) end)
exports("Error",   function(msg) return GRL_PRESET.error(msg) end)
exports("Bank",    function(amount,msg) return GRL_PRESET.bank(amount,msg) end)
exports("Bill",    function(amount,issuer) return GRL_PRESET.bill(amount,issuer) end)
exports("Police",  function(msg) return GRL_PRESET.police(msg) end)
exports("EMS",     function(msg) return GRL_PRESET.ems(msg) end)
exports("Job",     function(jobName,msg) return GRL_PRESET.job(jobName,msg) end)
exports("Item",    function(label,count) return GRL_PRESET.item(label,count) end)
exports("LevelUp", function(level) return GRL_PRESET.levelup(level) end)

-- Optional dev commands
if Config.EnableDevCommands then
  local ui = true
  RegisterCommand('grl_test_on', function() ui = true;  print('[grl] test ON') end)
  RegisterCommand('grl_test_off',function() ui = false; print('[grl] test OFF') end)
  RegisterCommand('grl_test', function()
    if not ui then return end
    exports.grl_notification:Success('Saved successfully')
    Wait(500)
    exports.grl_notification:Info('New mail received')
    Wait(500)
    exports.grl_notification:Warning('Low fuel')
    Wait(500)
    exports.grl_notification:Error('Action not allowed')
    Wait(500)
    exports.grl_notification:Bank(25000)
    Wait(500)
    exports.grl_notification:Bill(750, 'Mechanic')
    Wait(500)
    exports.grl_notification:Police('10-31 in progress')
    Wait(500)
    exports.grl_notification:EMS('Patient needs assistance')
    Wait(500)
    exports.grl_notification:Job('Taxi', 'You are on duty')
    Wait(500)
    exports.grl_notification:Item('Bandage', 2)
    Wait(500)
    exports.grl_notification:LevelUp(12)
    Wait(500)
    exports.grl_notification:Headshot('Nice shot')
  end)
end
