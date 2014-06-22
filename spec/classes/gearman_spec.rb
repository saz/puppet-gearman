require 'spec_helper'
describe 'gearman' do

  let :default_params do
    {
      :backlog => 32,
      :job_retries => 0,
      :port => 4730,
      :listen => '0.0.0.0',
      :threads => 4,
      :maxfiles => 1024,
      :worker_wakeup => 0,
      :disable_limits_module => false,
      :autoupgrade => false,
      :service_ensure => 'running',
      :service_enable => true,
      :service_hasstatus => false,
      :service_hasrestart => true
    }
  end

  [ {},
    {
      :backlog => 1,
      :job_retries => 5,
      :port => 4731,
      :listen => '127.0.0.1',
      :threads => 8,
      :maxfiles => 2048,
      :worker_wakeup => 5,
      :log_file => '/var/log/gearmand.log',
      :verbose => 'v',
      :queue_type => 'queue',
      :queue_params => '--queue-param=1',
      :disable_limits_module => true,
      :autoupgrade => true,
      :service_ensure => 'running',
      :service_enable => false,
      :service_hasstatus => false,
      :service_hasrestart => true
    },
  ].each do |param_set|
    describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do

      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      context 'on OS family Debian' do

        let :facts do
          {
            :osfamily       => 'Debian',
            :memorysize     => '1000 MB',
            :processorcount => '1',
          }
        end

        it { should_not contain_class('epel') }
        it { should contain_class('gearman::params') }

        let :package_ensure do
          if(param_hash[:autoupgrade])
              'latest'
          else
              'present'
          end
        end

        it { should contain_package('gearman-job-server').with_ensure(package_ensure) }

        it { should contain_file('/etc/default/gearman-job-server').with(
          'owner'   => 'root',
          'group'   => 'root'
        )}

        it { should contain_service('gearman-job-server').with(
          'ensure'     => param_hash[:service_ensure],
          'enable'     => param_hash[:service_enable],
          'hasrestart' => param_hash[:service_hasrestart],
          'hasstatus'  => param_hash[:service_hasstatus]
        )}

        it 'should compile the template based on the class parameters' do
          content = param_value(
            subject,
            'file',
            '/etc/default/gearman-job-server',
            'content'
          )
          expected_lines = [
            "PARAMS=\"--backlog=#{param_hash[:backlog]} \\",
            "--job-retries=#{param_hash[:job_retries]} \\",
            "--port=#{param_hash[:port]} \\",
            "--listen=#{param_hash[:listen]} \\",
            "--threads=#{param_hash[:threads]} \\",
            "--file-descriptors=#{param_hash[:maxfiles]} \\",
            "--worker-wakeup=#{param_hash[:worker_wakeup]} \\",
          ]
          if(param_hash[:log_file])
            expected_lines.push("# --log-file parameter is set via init script and can't be changed!")
          end
          if(param_hash[:verbose])
            expected_lines.push("--verbose=#{param_hash[:verbose]} \\")
          end
          if(param_hash[:queue_type])
            expected_lines.push("--queue-type=#{param_hash[:queue_type]} \\")
            expected_lines.push("#{param_hash[:queue_params]} \\")
          end
          (content.split("\n") & expected_lines).should =~ expected_lines
        end
      end

      context 'on OS family RedHat' do
        let :facts do
          {
            :osfamily       => 'RedHat',
            :memorysize     => '1000 MB',
            :processorcount => '1',
          }
        end

        it { should contain_class('epel') }
        it { should contain_class('gearman::params') }

        let :package_ensure do
          if(param_hash[:autoupgrade])
              'latest'
          else
              'present'
          end
        end

        it { should contain_package('gearmand').with_ensure(package_ensure).with_require(/Class\[Epel\]/i) }

        it { should contain_file('/etc/sysconfig/gearmand').with(
          'owner'   => 'root',
          'group'   => 'root'
        )}

        it { should contain_service('gearmand').with(
          'ensure'     => param_hash[:service_ensure],
          'enable'     => param_hash[:service_enable],
          'hasrestart' => param_hash[:service_hasrestart],
          'hasstatus'  => param_hash[:service_hasstatus]
        )}

        it 'should compile the template based on the class parameters' do
          content = param_value(
            subject,
            'file',
            '/etc/sysconfig/gearmand',
            'content'
          )
          expected_lines = [
            "OPTIONS=\"--backlog=#{param_hash[:backlog]} \\",
            "--job-retries=#{param_hash[:job_retries]} \\",
            "--port=#{param_hash[:port]} \\",
            "--listen=#{param_hash[:listen]} \\",
            "--threads=#{param_hash[:threads]} \\",
            "--file-descriptors=#{param_hash[:maxfiles]} \\",
            "--worker-wakeup=#{param_hash[:worker_wakeup]} \\",
          ]
          if(param_hash[:log_file])
            expected_lines.push("--log-file=#{param_hash[:log_file]} \\")
          end
          if(param_hash[:verbose])
            expected_lines.push("--verbose=#{param_hash[:verbose]} \\")
          end
          if(param_hash[:queue_type])
            expected_lines.push("--queue-type=#{param_hash[:queue_type]} \\")
            expected_lines.push("#{param_hash[:queue_params]} \\")
          end
          (content.split("\n") & expected_lines).should =~ expected_lines
        end
      end

      ['Solaris', 'Darwin', 'FreeBSD'].each do |osfamily|
        describe 'on supported platform' do
          it { "should not support OS family #{osfamily}" }
        end
      end
    end
  end
end
