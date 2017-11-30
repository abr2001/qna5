module CommentableSerializer
  extend ActiveSupport::Concern
  included do
    has_many :comments

    def comments
      object.comments.map{ |e| {id: e.id, body: e.body} }
    end
  end
end
