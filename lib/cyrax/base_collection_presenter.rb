class Cyrax::BaseCollectionPresenter
  def initialize(collection, options = {})
    @collection = collection
  end

  def fetched_collection
    if collection.is_a?(ActiveRecord::Relation)
      collection.to_a
    elsif collection.respond_to?(:all)
      collection.all
    else
      Array.wrap collection
    end
  end
end