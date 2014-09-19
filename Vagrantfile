# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2', &Oscar.run(File.expand_path('../config', __FILE__))) if defined? Oscar

# necessary until Oscar 0.12.0 drops
class ConfigBuilder::Model::Provisioner::File < ConfigBuilder::Model::Base
  def_model_attribute :source
  def_model_attribute :destination

  def to_proc
    Proc.new do |vm_config|
      vm_config.provision :file do |file_config|
        with_attr(:source)        { |val| file_config.source = val }
        with_attr(:destination)   { |val| file_config.destination = val }
      end
    end
  end

  ConfigBuilder::Model::Provisioner.register('file', self)
end
