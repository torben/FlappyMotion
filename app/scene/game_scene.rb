class GameScene < SKScene
  def self.unarchive_from_file(file)
    path = NSBundle.mainBundle.pathForResource(file, ofType: "sks")

    scene_data = NSData.dataWithContentsOfFile(path, options: NSDataReadingMappedIfSafe, error: nil)
    archiver = NSKeyedUnarchiver.alloc.initForReadingWithData scene_data

    archiver.setClass(classForKeyedUnarchiver, forClassName: "SKScene")
    scene = archiver.decodeObjectForKey NSKeyedArchiveRootObjectKey
    archiver.finishDecoding

    scene
  end

  def didMoveToView(view)
    self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
    
    self.backgroundColor = UIColor.colorWithRed(81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    
    ground_texture = SKTexture.textureWithImageNamed "land"
    ground_texture.filteringMode = SKTextureFilteringNearest

    move_ground_sprite = SKAction.moveByX(-ground_texture.size.width, y: 0, duration: 0.02 * ground_texture.size.width)
    reset_ground_sprite = SKAction.moveByX(ground_texture.size.width, y: 0, duration: 0.0)
    move_ground_sprites_forever = SKAction.repeatActionForever(SKAction.sequence([move_ground_sprite, reset_ground_sprite]))

    limit = 2.0 + size.width / ground_texture.size.width
    for i in 0..limit.ceil
      sprite = SKSpriteNode.alloc.initWithTexture ground_texture
      sprite.position = [i * sprite.size.width, sprite.size.height / 2.0]
      sprite.runAction move_ground_sprites_forever
      addChild sprite
    end
    
    # skyline
    sky_texture = SKTexture.textureWithImageNamed "sky"
    sky_texture.filteringMode = SKTextureFilteringNearest

    move_sky_sprite = SKAction.moveByX(-sky_texture.size.width, y: 0, duration: 0.1 * sky_texture.size.width)
    reset_sky_sprite = SKAction.moveByX(sky_texture.size.width, y: 0, duration: 0.0)
    move_skype_sprites_forever = SKAction.repeatActionForever(SKAction.sequence([move_sky_sprite, reset_sky_sprite]))

    limit = size.width / sky_texture.size.width
    for i in 0..limit.ceil
      sprite = SKSpriteNode.alloc.initWithTexture sky_texture
      sprite.zPosition = -20
      sprite.position = [i * sprite.size.width, sprite.size.height / 2.0 + ground_texture.size.height]
      sprite.runAction move_skype_sprites_forever
      addChild sprite
    end
    
    # spawn the pipes
    spawn = SKAction.runBlock -> { spawn_pipes }
    delay = SKAction.waitForDuration 4.0
    spawn_then_delay = SKAction.sequence([spawn, delay])
    spawn_then_delay_forever = SKAction.repeatActionForever spawn_then_delay
    runAction spawn_then_delay_forever
    
    # setup our bird
    animation = SKAction.animateWithTextures([texture_for("bird-01"), texture_for("bird-02")], timePerFrame: 0.2)
    flap = SKAction.repeatActionForever animation

    bird.position = [size.width * 0.35, size.height * 0.6]
    bird.runAction flap
    addChild bird
    
    # create the ground
    puts ground_texture.size.height
    ground = SKNode.new
    ground.position = [0, ground_texture.size.height / 2]
    ground.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize [size.width, ground_texture.size.height / 2]
    ground.physicsBody.dynamic = false

    addChild ground
  end

  def bird
    @bird ||= begin
      bird = SKSpriteNode.spriteNodeWithTexture texture_for "bird-01"

      bird.physicsBody = SKPhysicsBody.bodyWithCircleOfRadius bird.size.height
      bird.physicsBody.dynamic = true
      bird.physicsBody.allowsRotation = false
      bird
    end
  end

  def spawn_pipes
    pipe_pair = SKNode.new
    pipe_pair.position = [size.width + pipe_texture_up.size.width, 0]
    pipe_pair.zPosition = -10

    height = size.height / 4
    y = rand(40) - 20 % height + height
    
    pipe_down = SKSpriteNode.alloc.initWithTexture pipe_texture_down
    pipe_down.position = [0, y + pipe_down.size.height + vertical_pipe_gap]

    pipe_down.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize pipe_down.size
    pipe_down.physicsBody.dynamic = false
    pipe_pair.addChild pipe_down

    pipe_up = SKSpriteNode.alloc.initWithTexture pipe_texture_up
    pipe_up.position = [0, y]
    
    pipe_up.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize pipe_up.size
    pipe_up.physicsBody.dynamic = false
    pipe_pair.addChild pipe_up

    pipe_pair.runAction move_pipes_and_remove
    addChild pipe_pair
  end

  def move_pipes_and_remove
    distance_to_move = size.width + 2.0 * pipe_texture_up.size.width
    move_pipes = SKAction.moveByX(-distance_to_move, y:0.0, duration:0.02 * distance_to_move)
    remove_pipes = SKAction.removeFromParent
    SKAction.sequence [move_pipes, remove_pipes]
  end

  def vertical_pipe_gap
    150.0
  end

  def texture_for(image_name)
    @textures = {} unless @textures

    @textures[image_name] = begin
      texture = SKTexture.textureWithImageNamed image_name
      texture.filteringMode = SKTextureFilteringNearest
      texture
    end
  end

  def pipe_texture_up
    texture_for("pipe_up")
  end

  def pipe_texture_down
    texture_for("pipe_down")
  end

  def touchesBegan(touches, withEvent: event)
    touches.each do |touch|
      location = touch.locationInNode self

      bird.physicsBody.velocity = CGVectorMake(0, 0)
      bird.physicsBody.applyImpulse(CGVectorMake(0, 60))
    end
  end
    
  def clamp(min, max, value)
    if value > max
      max
    elsif value < min
      min
    else
      value
    end
  end

  def update(currentTime)
    bird.zRotation = clamp(-1, 0.5, bird.physicsBody.velocity.dy * (bird.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ))
  end
end
