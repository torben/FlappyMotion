class BirdNode < SKSpriteNode
  def init
    if initWithTexture(texture_for("bird-01"))
      configure_node
    end

    self
  end

  def configure_node
    self.physicsBody = SKPhysicsBody.bodyWithCircleOfRadius size.height / 2
    physicsBody.dynamic = true
    physicsBody.allowsRotation = false

    animation = SKAction.animateWithTextures([texture_for("bird-01"), texture_for("bird-02")], timePerFrame: 0.2)
    runAction SKAction.repeatActionForever animation
  end

  def texture_for(image_name)
    texture = SKTexture.textureWithImageNamed image_name
    texture.filteringMode = SKTextureFilteringNearest

    texture
  end
end