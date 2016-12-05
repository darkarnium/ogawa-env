# ogawa-env

Provides a Chef environment cookbook for provisioning an Ogawa node.

## Requirements

### Platforms

Per the `.kitchen.yml` in the root of this cookbook, support is as follows:

* Ubuntu 16.04

Although this cookbook may be compatible with other distributions, it only contains a `systemd` compatible init script for the Ogawa service.

### Chef

* Chef >= 12.X

### Cookbooks

* apt (~> 5.0.0)
* ntp (~> 3.2.0)
* ark (~> 2.0.0)
* java (~> 1.42.0)
* sysctl (~> 0.8.0)
* poise-python (~> 1.5.1)
* elasticsearch (~> 3.0.1)

## Configuration

A configuration shim has been provided with this cookbook which will attempt to 'deep merge' a set of Chef attributes with the Ogawa distribution configuration provided by the Ogawa service. The net result of this is that any deployment specific configuration can be added to either this environment cookbook or a Chef server / override JSON document, which will take precedence over the Ogawa distribution configuration (`ogawa.dist.yaml`).

## Attributes

The following attributes should be overridden through this cookbooks, or another mechanism (such as attribute JSON, or Chef server attributes).

* `node['ogawa']['conf']['bus']['input']['queue']`
  * The SQS URL of the Amazon Web Services (AWS) queue the Ogawa service should use when long-polling for results.
* `node['ogawa']['conf']['bus']['output']['elasticsearch']`
  * The HTTP URL of the ElasticSearch cluster topic the Ogawa service should use when posting results.

## Additional Reading

See the Ogawa project documentation at the following URL:

* https://www.github.com/darkarnium/ogawa/
