== 0.8.0
* Replace deprecated before_filter to before_action for rails 5+ support

== 0.7.9
* Import active_model/serializers/xml since it's been move to external gem

== 0.7.4, 0.5.6
* Send options to serializer attribute block.

== 0.7.3, 0.5.5
* Use multi json for json response.

== 0.7.2, 0.5.4
* Added total_count support to serializer.

== 0.7.1, 0.5.3
* Ability to serialize assigned resources.

== 0.7.0
* update/create block callback will send old_resource as second parameter
* Removed deprecated repository methods.
* BREAKING CHANGE: service methods update/create will not send attributes to build, it will use set_resource_attributes.

== 0.6.1
* Fix deprecations
* Ability to use finder methods as method-missing

== 0.6.0
* BREAKING CHANGE: build_resource, build_collection, resource_scope, find_resource, save_resource, delete_resource, default_resource_attributes methods have neeb moved to repository
* Sending string as resource decorator/serializer/repository is deprecated. Please send class defination.
* Sending class_name to resource is deprecated. Please send class.
* Added repositories


== 0.5.2
* BREAKING CHANGE: removed `collection` method in resource. please always use `read_all`
* Added simple authorization helper

== 0.5.1
* BREAKING CHANGE: add_errors_from changed to sync_errors_with
* Added localization for service methods
* Added assignment helper for has_response
* Serializer know about accessor

== 0.5.0
* BREAKING CHANGE: Add model errors to response by default
* BREAKING CHANGE: Response errors are always key-value hash now
* Removed callbacks
* Removed BaseResource class change deprecation
* Removed DecoratedCollectionPresenter class change deprecation

== 0.4.0
* Cyrax.strong_parameters = true by default
* One syntax for all injected classes, e.g. decorators, presenters, etc
* Added dependency injection on resource initialization

== 0.3.8
* Added relation serialization to Cyrax::Serializer
* Added some documentation
* Added serializer sample

== 0.3.7
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
