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

class TestStream < FFI::PortAudio::Stream
    
  def process(input, output, frameCount, timeInfo, statusFlags, userData)
    begin
      
      data  = input.read_array_of_int32(frameCount)
      na    = NArray.to_na(data)

      fc  = FFTW3.fft(na) / na.length
      fc  = NArray.to_na(fc.to_a.map {|i| i * -1})
      nc  = FFTW3.ifft(fc)           
      # nb  = nc.real
      # x   = nb.to_a

      output.write_array_of_int32(nc.real.to_a)
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
output[:device] = API.Pa_GetDefaultOutputDevice
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

