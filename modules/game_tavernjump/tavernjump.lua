mainWindow = nil
jumpButton = nil

moveSpeed = 10
startingRightMargin = 10
heightMin = 0
heightMax = 200
windowWidthMax = 200


currentRightMargin = nil


function init()
    --Standard initilization
    mainWindow = g_ui.displayUI('tavernjump.otui')
    jumpButton = mainWindow:getChildById('jumpButton')
    jumpButton.onClick = resetJumpButton
    currentRightMargin = startingRightMargin

    --I don't like this implementation, but I couldn't find a better "tick" event
    g_game.setPingDelay(100)
    connect(g_game, {
    onPingBack = update
  })
end

function terminate()
  mainWindow:hide()

  --Set the ping delay back to default value
  g_game.setPingDelay(1000)
  disconnect(g_game, {
    onPingBack = update
  })
end

function resetJumpButton()
    jumpButton:setMarginTop(math.random(heightMin, heightMax))
    jumpButton:setMarginRight(startingRightMargin)
    currentRightMargin = startingRightMargin
end

function update()
    if mainWindow:isVisible() then
        currentRightMargin = currentRightMargin + moveSpeed
        if(currentRightMargin >= windowWidthMax) then
            resetJumpButton() --The video doesn't show what happens if the button reaches the other end of the menu, so I'll just reset it.
        else
            jumpButton:setMarginRight(currentRightMargin)
        end
    end
end
