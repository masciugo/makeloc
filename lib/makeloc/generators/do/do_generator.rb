require 'rails/generators'

module Makeloc
  class DoGenerator < Rails::Generators::Base
    desc "Updates, or creates if not exists, the locale file for the provided target language"

    argument :target_lang, :type => :string 
    argument :source_file, :type => :string 

    def do
      ref_locale_fp = Pathname.new(source_file)

      raise "File #{ref_locale_fp} not found" unless ref_locale_fp.exist?

      ref_lang = locale_fn2lang(ref_locale_fp)
      ref_data = YAML.load(File.open(File.expand_path(ref_locale_fp)))[ref_lang]

      target_fp = ref_locale_fp.to_s.gsub(".#{ref_lang}.",".#{target_lang}.")
      
      # initializing target data with ref data keys and nil values
      target_data = ref_data.deep_dup.update_leaves!{|k,v| nil }
      
      # updating target data with original values if they exists
      if File.exist? target_fp
        existing_target_data = YAML.load(File.open(File.expand_path(target_fp)))[target_lang]
        target_data.deep_merge!(existing_target_data) if existing_target_data
      end
      
      create_file(target_fp){ {target_lang => target_data}.to_yaml(:line_width => -1) } # line_width => -1 to disable indentation

    end
  
    private

    def locale_fn2lang(fn)
      File.basename(fn,'.yml').split('.').last
    end

  end
end
