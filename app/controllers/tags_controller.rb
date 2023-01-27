class TagsController < ApplicationController
	before_action :set_tag, only: [:edit, :update, :destroy]

	def index
		@tags=Tag.all
	end

	def edit
	end

	def new
		@tag = Tag.new
	end

	def create
		Tag.create(tag_params)
		redirect_to tags_path
	end

	def update
	    tag = @tag.update(tag_params)
		redirect_to vip_kits_path
	end

	def destroy
	    @tag.destroy
	    redirect_to tags_path
	  end

	private
  
	def set_tag
		@tag=Tag.find(params[:id])
	end

	def tag_params
	  params.require(:tag).permit(:description)
  	end
end
