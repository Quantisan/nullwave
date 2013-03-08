require 'rubygems'
require 'bundler'
Bundler.require

include WaveFile
include FFI::PortAudio

# SAMPLES_PER_BUFFER = 4096
# 
# Writer.new(File.join(File.dirname(__FILE__), *%w[data newfile.wav]), Format.new(:stereo, :pcm_16, 44100)) do |writer|
#   Reader.new(File.join(File.dirname(__FILE__), *%w[data ambience.wav])).each_buffer(SAMPLES_PER_BUFFER) do |buffer|
#     new_buffer = Buffer.new(buffer.samples.map {|x| [x.first * -1, x.last * -1]}, buffer.send(:format))
#     writer.write(new_buffer)
#   end
# end

WINDOW = 1024
class TestStream < FFI::PortAudio::Stream
  
  # def initialize
  #   @max = 1
  #   @fourier = FourierTransform.new(1024, 44100)
  # end  
  
  def negate(x)
    if x == -32768
      32767
    elsif x == 32767
      -32768
    else
      x * -1
    end
  end
  
  def process(input, output, frameCount, timeInfo, statusFlags, userData)
    begin
      x = input.read_array_of_int32(frameCount).map {|x| [x].pack("l").unpack("ss").map {|x| x * -1}.pack("ss").unpack("l")}.flatten
      p x.inspect
      # x = input.read_array_of_int32(frameCount).map {|x| x * -1}
      output.write_array_of_int32(x)
    rescue => e
      p e.message
    end    

    :paContinue    
  end
end

API.Pa_Initialize

input = API::PaStreamParameters.new
input[:device] = API.Pa_GetDefaultInputDevice
input[:channelCount] = 1
input[:sampleFormat] = API::Int32
input[:suggestedLatency] = 0
input[:hostApiSpecificStreamInfo] = nil


output = API::PaStreamParameters.new
output[:device] = 1
output[:channelCount] = 1
output[:sampleFormat] = API::Int32
output[:suggestedLatency] = 0
output[:hostApiSpecificStreamInfo] = nil

stream = TestStream.new
stream.open(input, output, 44100, 1024)
stream.start

at_exit { 
  stream.close
  API.Pa_Terminate
}

loop { sleep 1 }

