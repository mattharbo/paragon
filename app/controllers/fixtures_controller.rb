class FixturesController < ApplicationController
  def index
    @fixtures=Fixture.all
  end

  def show
  end
end
