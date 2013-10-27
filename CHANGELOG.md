== 0.3.1
* Deprecate callbacks
* Add action method aliases, e.g. read!, read_all!

=== 0.3.0
* Cyrax::DecoratedCollectionPresenter renamed to Cyrax::Presenters::DecoratedCollection
* Cyrax::BaseCollectionPresenter renamed to Cyrax::Presenters::BaseCollection
* Cyrax::BasePresenter renamed to Cyrax::Presenter
* Cyrax::BaseResource renamed to Cyrax::Resource
* Decorator#decorate_collection has been removed
* Cyrax::Serializer has been added
* Added transaction to services

=== 0.2.5 - 0.2.12
* Small improvements

=== 0.2.4
* Remove `wrapped_collection` from has_resource
* Ability to pass Cyrax::Response to `respond_with`
* Fix respond_with on Cyrax::Base

=== 0.2.3
* Added collection decorator, to decorate collections with decorator use Decorator.decorate_collection(collection)
* Added presenter logic
* respond_with logic changed, now it works with Presenter