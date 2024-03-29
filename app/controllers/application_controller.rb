class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_new_messages


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :email, :password, :image, :role, :college, :major, :graduation_year])
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to login_path, :alert => 'ログインしてください'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def set_new_messages
    if user_signed_in?
      joining_post_ids = current_user.team_members.where(accepted: true).map{|m| m.post_id}
      sorted_post_ids = joining_post_ids.sort_by do |id|
        if GroupMessage.find_by(post_id: id).present?
          GroupMessage.where(post_id: id).last.created_at
        else
          Post.find(id).created_at
        end
      end.reverse
      @sorted_posts_and_messages = sorted_post_ids.map{|id| [Post.find(id), GroupMessage.where(post_id: id).last, unread_messages_count(id)]}
    end
  end

  def unread_messages_count(post_id)
    message_read_time = current_user.message_read_times.find_by(post_id: post_id)
    if message_read_time.nil?
      return GroupMessage.where(post_id: post_id).count
    end

    last_read_at = message_read_time.last_read_at
    return GroupMessage.where(post_id: post_id).where('created_at > ?', last_read_at).count
  end


end
