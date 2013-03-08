require 'rubygems'
require 'bundler'
require 'fftw3'
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

def moving_average(array, window_size)
  ma = [] 
  window = []
  array.each do |val|
    if(window.size < window_size)
      ma << val
    else
      ma << window.reduce(0){|sum, v| sum+=v; sum }/window_size
      window.shift
    end
    window << val
  end
  ma
end

def flatten_peaks(array, allowed_standard_deviations=2)
  find_peaks(array, allowed_standard_deviations) do |value, bottom, top|
    (value > top ? top : (value < bottom ? bottom : value) )
  end
end

def cancel_peaks(array, allowed_standard_deviations=2)
  find_peaks(array, allowed_standard_deviations) do |value, bottom, top|
    (value > top ? 0 : (value < bottom ? 0 : value) )
  end
end

def find_peaks(array, allowed_standard_deviations)
  mean = array.reduce(0){|sum, v| sum+=v; sum }/array.size
  sd = (array.reduce(0){|sum, v| sum = (v - mean)**2}/array.size)**0.5
  top = allowed_standard_deviations * sd
  bottom = top * -1
  array.map do |v|
    yield(v, bottom, top)
  end
end

@@original = []
@@transformed = []

SAMPLE_LENGTH = 8 * 44100

WINDOW = 1024
class TestStream < FFI::PortAudio::Stream
    
  def process(input, output, frameCount, timeInfo, statusFlags, userData)
    begin
      
      data  = input.read_array_of_int32(frameCount)
      # p data[10 .. 20]
      data = cancel_peaks(data, 10)
      data = moving_average(data, 50)
      # p data[10 .. 20]
      na    = NArray.to_na(data)

      fc  = FFTW3.fft(na) / na.length

      fc  = NArray.to_na(fc.to_a.map {|i| i * -1})
      nc  = FFTW3.ifft(fc)           
      # nb  = nc.real
      # x   = nb.to_a
      as_amplitude = nc.real.to_a
      #Amplify
      as_amplitude = as_amplitude.map{|v| v * 2}
      output.write_array_of_int32(as_amplitude)

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
stream.open(input, output, 44100, WINDOW)
stream.start


@@run = true
p "Started, press [Enter] to stop"
gets

p "Stopped"

API.Pa_Terminate
exit! 0
