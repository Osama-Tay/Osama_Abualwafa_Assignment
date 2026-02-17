Vagrant.configure("2") do |config|
  # Use the specified input image
  config.vm.box = "bento/ubuntu-24.04"

  # Forward guest port 7070 to host port 9090
  config.vm.network "forwarded_port", guest: 7070, host: 9090

  # Set up VM memory to 2GB
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Provisioning script to install Java 8 and Apache Tomcat 9
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y openjdk-8-jdk tomcat9
    
    # Change Tomcat port to 7070
    sudo sed -i 's/port="8080"/port="7070"/' /etc/tomcat9/server.xml
    sudo systemctl restart tomcat9
  SHELL
end
