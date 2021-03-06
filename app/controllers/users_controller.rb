class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @classrooms = Classroom.where(:student_id => @user.id)
    @taught_lessons = Lesson.where(:teacher_id => @user.id)
  end

  def destroy
    @user = current_user
    @user.destroy
    if @user.destroy 
      flash[:warning] = "Le compte a bien été supprimé !"
      redirect_to root_path
    else
      render "new"
    end
  end

  def new
    @user = User.new
  end
end
