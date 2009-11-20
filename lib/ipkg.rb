class Ipkg

  def self.remove(pkg_name)
    `ipkg -force-defaults remove #{pkg_name} </dev/null`
  end

  def self.install(pkg_name)
    `ipkg -force-defaults install #{pkg_name} </dev/null`
  end

  def self.upgrade(pkg_name)
    `ipkg -force-defaults upgrade #{pkg_name} </dev/null`
  end

  def self.update
    `ipkg update </dev/null`
  end

end