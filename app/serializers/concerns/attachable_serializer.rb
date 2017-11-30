module AttachableSerializer
  extend ActiveSupport::Concern
  included do
    has_many :attachments

    def attachments
      object.attachments.map{|e| e.file}
    end
  end
end
