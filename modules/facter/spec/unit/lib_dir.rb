#!/usr/bin/env rspec

require 'spec_helper'

describe "Lib_dir fact" do
    it "should default to /usr/lib" do
        Facter.fact(:architecture).stubs(:value).returns("bogus")
        Facter.fact(:lib_dir).value.should == "/usr/lib/"
    end

    archs = Hash.new
    # TODO add arm 64 and others
    archs = {
        "i586" => "/usr/lib/",
        "x86_64" => "/usr/lib64/",
    }
    archs.each do |arch, dir|
        it "should be #{dir} on #{arch}" do
            Facter.fact(:architecture).stubs(:value).returns(arch)
            Facter.fact(:lib_dir).value.should == dir
        end
    end
end
