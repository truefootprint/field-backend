class TopicsController < ApplicationController
  def index
    render json: present(Topic.where(topic_params))
  end

  def create
    topic = Topic.create!(topic_params)
    render json: present(topic), status: :created
  end

  def show
    render json: present(topic)
  end

  def update
    topic.update!(topic_params)
    render json: present(topic)
  end

  def destroy
    render json: present(topic.destroy)
  end

  private

  def present(object)
    TopicPresenter.present(object, presentation)
  end

  def topic
    Topic.find(topic_id)
  end

  def topic_id
    params.fetch(:id)
  end

  def topic_params
    params.permit(:name)
  end
end
