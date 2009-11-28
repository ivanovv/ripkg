require 'net/ftp'

class RouterDownload

  def self.do_the_job
    ROUTER_NAME = 'myrouter.homelinux.net'
    ROUTER_DIR = '/ipkg'
    ROUTER_LIST_DIR = 'lists'
    LOCAL_TMP_DIR = './tmp'
    STATUS_FILE = 'status'

    ftp = Net::FTP.new(ROUTER_NAME)
    ftp.passive = true
    ftp.login
    ftp.chdir(ROUTER_DIR)
    ftp.gettextfile(STATUS_FILE, File.join(LOCAL_TMP_DIR, STATUS_FILE))

    ftp.chdir(ROUTER_LIST_DIR)

    local_dir = File.join(LOCAL_TMP_DIR, ROUTER_LIST_DIR)
    Dir.mkdir(local_dir) unless File.exists?(local_dir)

    ftp.nlst.each do |ftp_file|
      local_file = File.join(local_dir, ftp_file)
      File.delete (local_file) if File.exists?(local_file)
      ftp.gettextfile(ftp_file, local_file)
    end
    Thread.exit
  end
end
