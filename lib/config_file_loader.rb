require 'erb'
require 'yaml'
class ConfigFileLoader

  ## base directory for configuration
  ## typically in rails root / config
  def self.base
    if defined?(@@base)
      @@base
    elsif defined?(Rails)
      @@base||="#{Rails.root}/config/"
    else
      @@base||=File.expand_path(File.dirname(__FILE__)) + "/config/"
    end
  end

  def self.base=(val)
    @@base=val
  end


  def self.env
    if defined?(@@env)
      @@env
    elsif defined?(RAILS_ENV)
      RAILS_ENV
    end
    #else nil
  end
  
  def self.env=(val)
    @@env=val
  end

  def self.load_no_symbolize_keys(*files)
    load_files(*files)
  end

  def self.load(*files, &block)    
    block=lambda() { |hash| self.deep_symbolize_keys(hash) } unless block_given?
    load_files(*files,&block)
  end
  
  def self.load_files(*files, &block)
    raw_hash = nil
    files.each do |file_name|
      second_hash = contents(file_name)
      second_hash = yield second_hash if block_given?
      raw_hash=deep_merge(raw_hash,second_hash)
    end
    raw_hash
  end
  
  #add .yml or rails config root if necessary
  def self.fix_name(name)
    return unless name.is_a?(String)
    #if it is not relative ('./file') or absolute ('/a/b/file') - tack on config directory
    name = "#{self.base}/#{name}" unless ['.','/','~'].include?(name[0,1])
    name+=".yml" unless name.include?('yml') || name.include?('cfg')
    name
  end

  def self.contents(file_name)
    if file_name.nil?
      nil
    elsif (file_name.is_a?(Hash))
      file_name
    else
      file_name=fix_name(file_name)
      load_erb_yaml(file_name) if File.exist?(file_name)
    end
  end

  def self.load_erb_yaml(file_name)
    raw_config = ERB.new(File.read(file_name)).result
    yaml_config = YAML.load(raw_config)
    yaml_config = yaml_config[env] || yaml_config[env.to_s] if env
    yaml_config
  end
  
  # def self.deep_merge(target, extra)
  #   (target && extra) ? target.deep_merge(extra) : (target || extra)
  # end

  # http://snippets.dzone.com/posts/show/4706
  # http://www.francisfish.com/deep_merge_a_ruby_hash_the_joys_of_recursion.htm
  # rails already defines this
  # return target.deep_merge(extra) if target.respond_to?(:deep_merge)
  def self.deep_merge(target, extra)
    # return something if either is nil
    return target || extra if target.nil? || extra.nil?

    extra.each_key do |k1|
      # if the key exists in both sides and they are both "hashes", merge
      # could move this block to the first line, but may want special logic for lists
      if target.key?(k1) && target[k1].respond_to?(:each_key) && extra[k1].respond_to?(:each_key)
        target[k1] = deep_merge(target[k1],extra[k1])
      else
        target[k1] = extra[k1] #dup?
      end
    end
    target    
  end

  def self.deep_symbolize_keys(hash)
    return hash unless hash.is_a?(Hash)

    #hash.symbolize_keys
    hash.inject({}) do |options, (key, value)|
      value=deep_symbolize_keys(value) if value.is_a?(Hash)
      options[(key.to_sym rescue key) || key] = value
      options
    end
    #ret inject value
  end
end