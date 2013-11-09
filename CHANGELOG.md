== 0.3.6
* Update example to rails 4
* Some bug fixes

== 0.3.6
* More fixes for serializable

== 0.3.5
* Fix wrapping not decorated collection

== 0.3.4
* Better serializers + bug fixes

== 0.3.3
* Pass presenter object in initializer instead of `present` method
* Serializer now supports dynamic attrs
* Serializer/Presenter/Decorator now have one interface

== 0.3.2
* Small fix
* Pass resource to blocks in method aliases

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