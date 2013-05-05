class SuggestionsController < ApplicationController
  respond_to :html, :xml

  def new
    @suggestion = Suggestion.new
    respond_with @suggestion
  end

  def show
    @suggestion = Suggestion.find params[:id]
    respond_with @suggestion
  end

  def create
    @suggestion = Suggestion.new params[:suggestion]

    if @suggestion.save
      redirect_to :root, flash: {notice: t("suggestions.create.confirmation")}
    else
      render :new
    end

  end
end
