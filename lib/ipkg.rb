class Ipkg

  def self.try_external_command(param)
    begin
      yield (param)
    rescue Exception
      $!.inspect
    end
  end

  def self.remove(pkg_name)
    try_external_command(pkg_name) do
      `ipkg -force-defaults remove #{pkg_name} </dev/null`
    end    
  end

  def self.install(pkg_name)
    try_external_command(pkg_name) do
      `ipkg -force-defaults install #{pkg_name} </dev/null`
    end
  end

  def self.upgrade(pkg_name)
    try_external_command(pkg_name) do
      `ipkg -force-defaults upgrade #{pkg_name} </dev/null`
    end
  end

  def self.update
    `ipkg update </dev/null`
  end

end