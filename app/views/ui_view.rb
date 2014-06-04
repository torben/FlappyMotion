class UIView
  def height
    self.frame.size.height
  end

  def height=(height)
    frame = self.frame
    frame.size.height = height
    self.frame = frame
  end

  def width
    self.frame.size.width
  end

  def width=(width)
    frame = self.frame
    frame.size.width = width
    self.frame = frame
  end

  def x
    self.frame.origin.x
  end

  def x=(x)
    frame = self.frame
    frame.origin.x = x
    self.frame = frame
  end

  def y
    self.frame.origin.y
  end

  def y=(y)
    frame = self.frame
    frame.origin.y = y
    self.frame = frame
  end

  def addSubviews(*args)
    args.each do |view|
      addSubview view if view
    end
  end
end