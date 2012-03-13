class Settings

  attr_accessor :settings
  
  def initialize(file_writer)
    @file_writer = file_writer
    read_settings_to_new_hash
  end

  def read_settings_to_new_hash
    @settings = fabricate_hash
    @settings.replace(@file_writer.read_keys)
  end

  def fabricate_hash
    InterceptedHash.new( &hash_saved_proc )
  end

  def hash_saved_proc
    Proc.new do |key, value|
      @file_writer.write_key(key, value)
    end
  end

  def method_missing(m, *args, &block)
    if @settings.has_key?(m) || args[0]
      if args[0]
        @settings[m.to_s.sub("=","").to_sym] = args[0]
      else
        @settings[m]
      end
    else
      raise "unknown setting"
    end
  end

end

# Not implemented. This should continue the logic to interact with whatever you want.
class SettingsFileManager
  def initialize(file)
    @file = file
  end

  # write the key and its value somewhere.
  def write_key(key, value)
    puts 'write_key', key, value
  end

  # should return hash of keys.
  def read_keys
    puts 'read_keys'
    Hash.new
  end
end

class InterceptedHash < Hash
  def initialize(&block)
    super
    @block = block
  end

  def store(key, value)
    super(key, value)
    @block.call(key, value)
  end

  def []=(key, value)
    store(key, value)
  end
end
