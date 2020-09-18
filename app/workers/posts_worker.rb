class PostsWorker
  include Sidekiq::Worker

  def perform post_id
    @post = Post.find_by id: post_id
    return unless @post

    PostsMailer.status_changed(@post).deliver_now
  end
end
