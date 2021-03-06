class LessonsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :show]
  before_action :is_accessible?, only: [:show]

  def index
    @lessons = Lesson.where(checked: true)
    @users = User.all
  end

  def show
    @comment = Comment.new
    @comments = Comment.all
    @lesson = Lesson.find(params[:id])
    @students = [Lesson.find(params[:id]).students]
  end
  
  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(
      title: params[:lesson][:title], 
      content: params[:lesson][:content],
      category: params[:lesson][:category],
      price: params[:lesson][:price],
      summary: params[:lesson][:summary],
      teacher: current_user,
      checked: false)
    if @lesson.save 
      flash[:info] = "Votre cours est en cours de validation !"
      redirect_to root_path
    else
      render "new"
    end
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    Lesson.destroy(@lesson.id)
    if @lesson.destroy 
      flash[:warning] = "Votre cours a bien été supprimé !"
      redirect_to root_path
    else
      render "new"
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    if @lesson.update(
      title: params[:lesson][:title], 
      content: params[:lesson][:content],
      category: params[:lesson][:category],
      price: params[:lesson][:price],
      summary: params[:lesson][:summary],
      checked: false)
      redirect_to @lesson
    else
      render :edit
    end
  end

  private

  def is_accessible?
    @lesson = Lesson.find(params[:id])
    paid_lesson = @lesson.classrooms.map {|c| c.student}.include?(current_user)
    if @lesson.price == 0 || @lesson.price == nil || paid_lesson
    elsif @lesson.teacher.id == current_user.id
    elsif current_user.admin == true
    else
      redirect_to  new_lesson_charge_path(@lesson.id)
    end
  end
end
