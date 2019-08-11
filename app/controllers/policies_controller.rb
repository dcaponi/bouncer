class PoliciesController < ApplicationController
  before_action :set_policy, only: [:destroy]
  def create
    new_policy_requests = []
    writing_errors = []
    user_id = JsonWebToken.decode(cookies[:login])["id"]
    if user_id
      policy_params[:policies].each do |param|
        resource_server = ResourceServer.find_by_name(param[:resource_server])
        resource = Resource.find_by_name(param[:resource])
        new_policy_requests << {user_id: user_id, resource_server_id: resource_server.id, resource_id: resource.id, permission: param[:permission]}
      end

      new_policies = Policy.create(new_policy_requests)

      new_policies.each_with_index do |p, i|
        writing_errors << { index: i, message: p.errors.full_messages} if p.errors.any?
      end

      new_policies.each { |p| p.destroy } if writing_errors.any?

      unless writing_errors.any?
        render json: {policies: new_policies}
      else
        render json: {errors: writing_errors}, status: :unprocessable_entity
      end
    else
      render json: {'unauthorized': 'not authorized to perform this action'}, status: :unauthorized
    end
  end

  def index
    user_id = JsonWebToken.decode(cookies[:login])["id"]
    render json: {policies: Policy.where(user_id: user_id)}
  end

  def update
    # TODO holy fuck this method is ass... fix!!!
    user_id = JsonWebToken.decode(cookies[:login])["id"]
    ids = policy_params[:policies].map { |pp| pp[:id] }
    policies_to_change = Policy.where(user_id: user_id, id: ids)
    policies_to_change.map do |p|
      p.update(permission: policy_params[:policies].select { |i| i[:id] == "56a4c6d3-240c-4024-a8ab-d9f2bd85f6bf" }.first[:permission])
    end
  end

  def destroy
    if @policy
      @policy.destroy
    else
      render json: {'bad request': 'the policy with the given params was not found'}, status: 401
    end
  end

  private;
  def set_policy
    user_id = JsonWebToken.decode(cookies[:login])["id"]
    @policy = Policy.where(user_id: user_id, id: params[:id]).first
  end

  def policy_params
    params.permit({policies: [:id, :resource_server, :resource, :permission]})
  end
end
