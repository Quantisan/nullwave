require 'rubygems'
require 'bundler'
Bundler.require
include WaveFile

SAMPLES_PER_BUFFER = 4096

Writer.new(File.join(File.dirname(__FILE__), *%w[data newfile.wav]), Format.new(:stereo, :pcm_16, 44100)) do |writer|
  Reader.new(File.join(File.dirname(__FILE__), *%w[data ambience.wav])).each_buffer(SAMPLES_PER_BUFFER) do |buffer|

    # STDERR.puts (buffer.methods - Object.new.methods).sort
    # STDERR.puts buffer.samples
    # STDERR.puts buffer.class
    # STDERR.puts buffer.samples.inspect
      
    new_buffer = Buffer.new(buffer.samples.map {|x| [x.first * -1, x.last * -1]}, buffer.send(:format))
    writer.write(new_buffer)
  end
end