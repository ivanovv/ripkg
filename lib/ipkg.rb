class Ipkg

  def initialize(server = nil, port = nil, password = nil)
    @server = server
    @port  = port
    @pass = password
  end

  def try_external_command(param)
    begin
      if @server
        # server was specified,  should use net-ssh
        require 'net-ssh' unless defined? Net::SSH
        Net::SSH.start(@server, "admin",
          {#:verbose=> :debug, 
          :compression => true,
          :key_data => [<<-KEYDATA 
-----BEGIN RSA PRIVATE KEY-----
MIICWQIBAAKBgHeFSScXzc4dqdIq3gzmeHG+3dOmX2+q2NXgf2h4MXWmcvO6hZ2L
yuTObcdaqVF7KVPlZHDe11rsTU6zY8WjigTbW7rx6AgF9sMkV4LO/TMvUM1TrkYN
UlUA9W3nKKmgmdeKYSnujLU81O5PRr/MF3X/QBF0ErQDuM2hmkMukBmNAgElAoGA
apl4mH0Dqf7H5PXM9r+3iAsY310JArr4vsFPCiYCmV0aaq1GvPJNLO92quIoT5dc
NhHISP4aBPxE8ypf55+yccdC8UR55iJMA04/cNoKpl/Uf1z8ZqI/2BMwja/PsC6+
8jqVMSeu+3bAgdXBIsrXds7nk0ERHmgXcN3OqtauGy0CQQDf4mwy8mDeTr7T/VGO
KV+E2JSRahpH7rW2rL2O2106dJLsuHINmSEGnAzMWHKokTNRZ8eu8CceQBNFLSxq
kkvtAkEAiKpfQ6NICPWzCCKTsTR9+TSiMziw8HFfctQwg6pBCvIV/uJpfiehDiq8
i4JcbqQx1WBHk3Q0gEcsTHXbGRuQIQJAbOqxLYqrqmt/bgyIillREDIDFk9LDjzH
Gpk5n3Gi+dfYxjA3fDyoSGeXhgGD402Olk4pyroFMU+arAgjch2oZQJAax3AScUq
nz0dnpekMPHKhQ2T4vUVD3t0UxUDbh2omeBWbdQNfo3Da/f7j/CNotO4WyHy6TGQ
7uutGVV0X8l+zQJBALCEaJ3anPeneMHvwHhOufOZ4PdcIjJaohX7PzP2ZPrYe3vr
N23peqhFVvaC/nTOAm45GmFGSFco0t99ohQ+Nx8=
-----END RSA PRIVATE KEY-----
KEYDATA
],
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

  def remove(pkg_name)
    try_external_command(pkg_name) do
      `ipkg -force-defaults remove #{pkg_name} </dev/null`
    end
  end

  def install(pkg_name)
    try_external_command(pkg_name) do
      `ipkg -force-defaults install #{pkg_name} </dev/null`
    end
  end

  def upgrade(pkg_name)
    try_external_command(pkg_name) do
      `ipkg -force-defaults upgrade #{pkg_name} </dev/null`
    end
  end

  def update
    `ipkg update </dev/null`
  end

end
