class PoliciesController < ApplicationController
  def create
    user_id = JsonWebToken.decode(cookies[:login])["id"]
    resource_server = ResourceServer.find_by_name(policy_params[:resource_server])
    resource = Resource.find_by_name(policy_params[:resource])
    policy = Policy.new(user_id: user_id, resource_server_id: resource_server.id, resource_id: resource.id, permission: policy_params[:permission])
    if policy.save
      render json: {policy: {id: policy.id, resource_server: resource_server.name, resource: resource.name}}
    else
      render json: policy.errors, status: :unprocessable_entity
    end
  end

  def index
    user_id = JsonWebToken.decode(cookies[:login])["id"]
    render json: {policies: Policy.where(user_id: user_id)}
  end

  def update

  end

  def destroy

  end

  def policy_params
    params.require(:policy).permit(:resource_server, :resource, :permission)
  end
end
