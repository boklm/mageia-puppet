#!/usr/bin/env rspec

require 'spec_helper'

describe "Dc_suffix fact" do
    it "should be based on tld domain" do
        Facter.fact(:domain).stubs(:value).returns("test")
        Facter.fact(:dc_suffix).value.should == "dc=test"
    end

    it "should be based on domain" do
        Facter.fact(:domain).stubs(:value).returns("test.example.org")
        Facter.fact(:dc_suffix).value.should == "dc=test,dc=example,dc=org"
    end
end
