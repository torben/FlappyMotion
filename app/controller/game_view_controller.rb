class GameViewController < UIViewController
  def viewDidLoad
    super

    scene = GameScene.unarchive_from_file "GameScene"
    scene.scaleMode = SKSceneScaleModeAspectFill
    sk_view.presentScene scene

    view.addSubview sk_view
  end

  # Views
  def sk_view
    @sk_view ||= begin
      sk_view = SKView.alloc.initWithFrame view.frame
      sk_view.showsFPS = true
      sk_view.showsNodeCount = true
      # sk_view.ignoresSiblingOrder = true

      sk_view
    end
  end
end