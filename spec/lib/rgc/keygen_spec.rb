# require 'spec_helper'

# describe Rgc::Keygen do
#   context :initialize do
#     it 'should abort when key file exists' do
#       File.open(file = "/tmp/#{SecureRandom.hex(32)}", "w")

#       stderr = capture_stderr do
#         expect {
#           Rgc::Keygen.new({}, {}, [file])
#         }.to raise_error(SystemExit)
#       end

#       stderr.should eq("Key file already exists.\n")

#       File.delete(file)
#     end

#     it 'should abort when file cannot be opened for writing' do
#       path = "/this/file/does/not/exist"

#       stderr = capture_stderr do
#         expect {
#           Rgc::Keygen.new({}, {}, [path])
#         }.to raise_error(SystemExit)
#       end

#       stderr.should eq("Cannot open #{path} for writing.\n")
#     end

#     it 'should create a file and insert secure key to it' do
#       file = "/tmp/#{SecureRandom.hex(32)}"

#       Rgc::Keygen.new({}, {}, [file])

#       File.read(file).length.should > 0

#       File.delete(file)
#     end
#   end

#   context :generate_secure_key do
#     it 'should invoke `random_key` method of OpenSSL::Cipher' do
#       file = "/tmp/#{SecureRandom.hex(32)}"

#       keygen = Rgc::Keygen.new({}, {}, [file])

#       OpenSSL::Cipher.any_instance.should_receive(:random_key)

#       keygen.send(:generate_secure_key)

#       File.delete(file)
#     end
#   end
# end
