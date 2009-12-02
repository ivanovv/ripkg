class Ipkg

  def initialize(server = nil, port = nil, password = nil)
    @server = server
    @port  = port
    @pass = password
  end

  def self.try_external_command(param)
    begin
      if @server
        # server was specified,  should use net-ssh
        require 'net-ssh' unless defined? Net::SSH
        Net::SSH.start(@server, "admin", {:verbose=> :debug, :compression => true,
          :user_known_hosts_file => ['"C:/Documents and Settings/VIvanov/.ssh/known_hosts"'],
          :keys => ['C:/Documents and Settings/VIvanov/.ssh/id_rsa'],
          :port => @port}) do |ssh|
          result = ssh.exec!("#{param}")
        end
      else
        result = yield(param)
      end
      result
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
