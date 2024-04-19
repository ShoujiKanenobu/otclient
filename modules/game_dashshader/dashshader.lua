--Had to implement character set shader via this OTLand post: https://otland.net/threads/otclient-showoff-show-off-your-otclient-project-module-ui-and-other.254460/post-2618184
--Red outline shader ripped directly from https://otland.net/threads/help-with-shader-outline.283875/

function init()
    testshader = g_shaders.createFullShader("TestFrag", "dashshader.vert", "dashshader.frag" )
end

function terminate()
end


function exectuteShader()
    player = g_game.getLocalPlayer()
    player:setShader(g_shaders.getShader("TestFrag"))
end

function resetShader()
    player = g_game.getLocalPlayer()
    player:clearShader()
end

--Sending ExtendedOpcode from server. Using Opcode as value to save on buffer
function ProtocolGame:onExtendedOpcode(protocol, opcode, buffer)
    if opcode == "1" then
        exectuteShader()
    else
        resetShader()
    end
end