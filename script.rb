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

API.Pa_Initialize

input = API::PaStreamParameters.new
input[:device] = API.Pa_GetDefaultInputDevice
input[:channelCount] = 1
input[:sampleFormat] = API::Int16
input[:suggestedLatency] = 0
input[:hostApiSpecificStreamInfo] = nil

output = API::PaStreamParameters.new
output[:device] = API.Pa_GetDefaultOutputDevice
output[:channelCount] = 1
output[:sampleFormat] = API::Int16
output[:suggestedLatency] = 0
output[:hostApiSpecificStreamInfo] = nil

stream = FFI::PortAudio::Stream.new
stream.open(input, output, 44100, 1024)
stream.start
while 1 == 1 do
  p "OMG"
end
puts output.inspect
