require 'spec_helper'

module Makeloc
  
  describe DoGenerator do

    # loaded once at beginning
    let!(:ref_hash_with_root) { YAML.load(File.read(REF_LANG_FP)) }
    let!(:ref_hash) { ref_hash_with_root[REF_LANG] }
    let!(:incomplete_target_hash_with_root) { YAML.load(File.read(TARGET_INCOMPLETE_ORIGINAL_FP)) }
    let!(:incomplete_target_hash) { incomplete_target_hash_with_root[TARGET_LANG] }

    EXTRA_KEYS = %w{ date.extra_key_1 date.formats.extra_key_2 }
    MISSING_KEYS = %w{ datetime.distance_in_words.about_x_hours.other date.abbr_day_names }

    # loaded at runtime after each generation
    let(:target_hash_with_root) { YAML.load(File.read(TARGET_LANG_FP)) }
    let(:target_hash) { target_hash_with_root[TARGET_LANG] }
    
    shared_examples "a brand new generated locale file" do
      it "should generate a #{TARGET_LANG_FP.basename} file in the same dir" do
        File.exists? TARGET_LANG_FP
      end
      it "#{TARGET_LANG_FP.basename} hash has '#{TARGET_LANG}' as root key" do
        target_hash_with_root.keys.should ==([TARGET_LANG])
      end
    end

    shared_examples "a new generated locale file with identical structure" do
      it "#{TARGET_LANG_FP.basename} hash has identical keys set as #{REF_LANG_FP.basename} hash" do
        target_hash.flatten_keys.should eql(ref_hash.flatten_keys)
      end
    end

    with_input "y\n"  do
      
      context "when #{TARGET_LANG_FP.basename} doesn't exist" do
        with_args "en", REF_LANG_FP

        before(:each) do
          FileUtils.rm_rf TARGET_LANG_FP
          subject.should generate 
        end

        it_should_behave_like "a brand new generated locale file"
        it_should_behave_like "a new generated locale file with identical structure"
        it "gets created with nil leaves" do
          all_values = []
          target_hash.parse_leaves{|k,v| all_values << v }
          all_values.compact.should be_empty
        end
      end

      context "when #{TARGET_LANG_FP.basename} already exists with some missing keys (ie.: #{MISSING_KEYS.join(', ')}) and some extra keys (ie.: #{EXTRA_KEYS.join(', ')})" do
        with_args "en", REF_LANG_FP

        before(:each) do
          FileUtils.cp TARGET_INCOMPLETE_ORIGINAL_FP, TARGET_LANG_FP
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
        EXTRA_KEYS.each do |key|
          it "keeps extra key #{key} along with its original value" do
            target_hash.at(key).should == incomplete_target_hash.at(key)
          end
        end
        context "with option --strict" do
          with_args "en", REF_LANG_FP, '--strict'
          it_should_behave_like "a new generated locale file with identical structure"
        end

      end

    end

  end  

end
