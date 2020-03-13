class ApplicationController < ActionController::Base
  def search
    if params[:q].nil?
      render json: { error: "'q' is a required search parameter" }
    elsif !params[:q].is_a?(String)
      render json: { error: "q must be a string" }
    else
      packages = CranPackage.where("lower(name) like ?", "%#{params[:q].downcase}%").limit(20)
      render json: packages
    end
  end
end
