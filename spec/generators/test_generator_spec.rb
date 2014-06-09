require 'spec_helper'

module Makeloc
  
  describe DoGenerator do

    with_args "en", REF_LANG_FP do
      with_input "y\n"  do
        
        before(:each) do
          FileUtils.rm TARGET_LANG_FP
        end

        # loaded once at beginning
        let!(:ref_hash_with_root) { YAML.load(File.read(REF_LANG_FP)) }
        let!(:ref_hash) { ref_hash_with_root[REF_LANG] }
        
        # loaded at runtime after each generation
        let(:target_hash_with_root) { YAML.load(File.read(TARGET_LANG_FP)) }
        let(:target_hash) { target_hash_with_root[TARGET_LANG] }
        
        shared_examples "a brand new generated locale file" do
          it "should generate a #{TARGET_LANG_FP.basename} file in the same dir" do
            File.exists? TARGET_LANG_FP
          end
          it "#{TARGET_LANG_FP.basename} hash has same structure as hash for #{REF_LANG_FP.basename}" do
            ref_hash.flatten_keys.should eql(target_hash.flatten_keys)
          end
          it "#{TARGET_LANG_FP.basename} hash has '#{TARGET_LANG}' as root key" do
            target_hash_with_root.keys.should ==([TARGET_LANG])
          end
        end

        MISSING_KEYS = %w{ datetime.distance_in_words.about_x_hours.other date.abbr_day_names }
        context "when #{TARGET_LANG_FP.basename} already exists with some missing keys (ie.: #{MISSING_KEYS.join(', ')})" do
          
          # loaded once at beginning
          let!(:incomplete_target_hash_with_root) { YAML.load(File.read(TARGET_INCOMPLETE_BK_FP)) }
          let!(:incomplete_target_hash) { incomplete_target_hash_with_root[TARGET_LANG] }

          before(:each) do
            FileUtils.cp TARGET_INCOMPLETE_BK_FP, TARGET_LANG_FP
            subject.should generate 
          end
          it_should_behave_like "a brand new generated locale file"

          MISSING_KEYS.each do |key|
            it "value at '#{key}' is nil" do
              target_hash.at(key).should be_nil
            end
          end
          it "keeps old values (value at 'date.abbr_month_names' is in lang #{TARGET_LANG})" do
            target_hash.at('date.abbr_month_names').should ==(incomplete_target_hash.at('date.abbr_month_names'))
          end
        end

        context "when #{TARGET_LANG_FP.basename} doesn't exist" do
          before(:each) do
            subject.should generate 
          end
          it_should_behave_like "a brand new generated locale file"
          it "gets created with nil leaves" do
            all_values = []
            target_hash.parse_leaves{|k,v| all_values << v }
            all_values.compact.should be_empty
          end
        end

      end
    end

  end  

end
