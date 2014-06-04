class GameViewController < UIViewController
  def viewDidLoad
    super

    scene = GameScene.unarchive_from_file("GameScene")
  end
end