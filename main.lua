local vEnemy = {}

local function enemy (xPos, yPos)
    local x = xPos
    local y = yPos
    local mp = function(mx, my, button,istouch)
      while true do
          click =  false -- Clique fora do inimigo
          if button == 1 then -- nao ESTÁ ENTRANDO AQUI
              print("x/y:",mx,xPos,xPos + 210,"/",my,yPos,yPos+136,
                (mx > xPos) and (mx < xPos + 210) and (my>yPos) and (my<yPos+136))
              if  (mx > xPos) and (mx< xPos +210) and (my>yPos) and (my<yPos+136) then
                  print("clicado")
                  click= true -- Inimigo foi clicado
              end
          end
          mx, my, button,istouch = coroutine.yield (click)
      end
    end


    local dr = function()
      while true do
        --love.graphics.setColor(1, 1, 1)  -- nao necessaria para desenhar imagens.
        enemyImage = love.graphics.newImage("enemy.png")
        love.graphics.draw(enemyImage, x, y)   -- Se por x, y no final ele desenha so 1            
        coroutine.yield()
      end
    end
    
    -- Funcao moverá imagem estilo coroutine na diagonal esquerda direita.
    local updt = function(dt) -- dt é o param que sempre atualiza com o tempo
      while true do  -- classico para fazer coroutine
        x = x + (10*dt)  -- move horizontalmente
        y = y+ (10*dt)   -- move verticalmente
        dt = coroutine.yield() -- para coroutine salvando argumento passado nessa função 
        end
    end

    return {
        mousepressed = coroutine.wrap(mp),
        
        draw = coroutine.wrap(dr),
        
        update = coroutine.wrap(updt),
            
    }
end

function love.load()
    love.window.setTitle("HonorNDuty")
    
    imageMenu   = love.graphics.newImage("menu.jpg")  -- Initial image
    imageCombat = love.graphics.newImage("combat.jpg")  -- Image after 3 seconds
    table.insert(vEnemy, enemy(50,50) )  
    table.insert(vEnemy, enemy(250,250) ) 
    table.insert(vEnemy, enemy(50,350) ) 
    table.insert(vEnemy, enemy(350,35) ) 
    table.insert(vEnemy, enemy(350,450) ) 
    table.insert(vEnemy, enemy(450,350) ) 

end

-- Função que lida com cliques do mouse
function love.mousepressed(x, y, button, istouch)
    print("bt",button,"|") -- parece q sem essa linha a funcao se recusa a agir
    -- Itera sobre a lista de inimigos e verifica se algum foi clicado
    local i = 1
    while true do
      if i > #vEnemy then break end
      status = vEnemy[i].mousepressed(x, y, button, istouch)
      if status then
        print("Remove")
        table.remove(vEnemy, i) -- Remove o inimigo clicado da lista
      else
        i= i + 1
      end
    end
end

function love.update(dt) 
    for i, enemy in ipairs(vEnemy) do
        vEnemy[i].update(dt)
    end      
  
end


function love.draw()
  
  for i, enemy in ipairs(vEnemy) do
    enemy.draw()
  end      
end