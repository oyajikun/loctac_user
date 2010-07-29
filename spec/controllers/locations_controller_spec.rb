require 'spec_helper'

describe LocationsController do

  #Delete these examples and add some real ones
  it "should use LocationsController" do
    controller.should be_an_instance_of(LocationsController)
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'result'" do
    it "should be successful" do
      get 'result'
      response.should be_success
    end
  end
end
