require 'spec_helper'

describe Lecturer do
  describe "#free_cells_at(week)" do
    let(:week) { Week.new }
    let(:lecturer) { Lecturer.new }
    let(:lesson) { Lesson.new}

    before { week.stub(:cells).and_return({"1" => [1,2,3], "2" => [1,3,4]}) }
    before { lecturer.stub_chain(:lessons, :where).and_return([lesson]) }
    before { lesson.stub(:day).and_return("2") }
    before { lesson.stub(:lesson_time).and_return(3) }

    it { lecturer.free_cells_at(week).should == {"1" => [1,2,3], "2" => [1,4]} }
  end
end
