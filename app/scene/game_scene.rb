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
end
