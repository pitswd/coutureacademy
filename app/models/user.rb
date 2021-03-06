class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
            
has_one_attached :avatar

has_many :followed_lessons, foreign_key: "student_id", class_name: "Classroom", dependent: :destroy
has_many :lessons, through: :followed_lessons
has_many :taught_lessons,  foreign_key: "teacher_id", class_name: "Lesson", dependent: :destroy

has_many :comments

validates :username, presence: true
validates :username, uniqueness: true

  def is_teacher? 
    if @current_user.taught_lessons.count > 0
    else
    end
  end
  
  after_create :welcome_send

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

end
