class FixturesController < ApplicationController

  before_action :set_fixture, only: [:show, :edit, :update, :destroy]

  def index
    @fixtures=Fixture.all
  end

  def show
  end

  private 

  def set_fixture
    @fixture = Fixture.find(params[:id])
  end
end
