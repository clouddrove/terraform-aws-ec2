# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2023-04-05
### :bug: Bug Fixes
- [`019d7dd`](https://github.com/clouddrove/terraform-aws-elasticache/commit/019d7dd7daae3b49a1a24e94adf7f56c657ffdc6) - updated deprecated variables
- [`55d833a`](https://github.com/clouddrove/terraform-aws-elasticache/commit/55d833a0fac8420284db0a06379c750b215d511a) - update workflows

## [1.0.3] - 2022-09-16
### :bug: Bug Fixes
- [`72c7b9f`](https://github.com/clouddrove/terraform-aws-elasticache/commit/72c7b9f70a3e9dfe5a6d1e41535575cbc2cb6668) - added arn outputs for redis/memcache

## [1.0.2] - 2022-08-18
### :sparkles: New Features
- [`93a2d36`](https://github.com/clouddrove/terraform-aws-elasticache/commit/93a2d36bc8dc8e153f04b4b286143c6fe7ecb940) - added retention_in_days


## [1.0.1] - 2022-05-19
### :sparkles: New Features
- [`272aa17`](https://github.com/clouddrove/terraform-aws-elasticache/commit/272aa17ab7d4a038cf0e37ebd7d1abf25c30095d) - add cloudwatch_log_group and enabled redis logs

## [0.15.1] - 2021-12-03
### :bug: Bug Fixes
- [`41eb6a8`](https://github.com/clouddrove/terraform-aws-elasticache/commit/41eb6a841f205e5c15ebccec260e8aabcbb3988c) - update version
- [`6157bfa`](https://github.com/clouddrove/terraform-aws-elasticache/commit/6157bfa79ca7a3a607daacac9e8fbfe385c03813) - update github-action


## [0.12.7] - 2021-08-17

## [0.15.0] - 2021-01-24
### :bug: Bug Fixes
- [`c5f7937`](https://github.com/clouddrove/terraform-aws-elasticache/commit/c5f7937cfc2215201c2f9d8a035b9de96139cd89) - added extra_tags variable for custom tags
- [`6405934`](https://github.com/clouddrove/terraform-aws-elasticache/commit/640593463a0c125818ed536da31be5e8180dca98) - update example.tf and added coustom tags with tag variable
- [`f2076be`](https://github.com/clouddrove/terraform-aws-elasticache/commit/f2076be7d25a2d757d10841f49100888e0a1bd36) - fix terratest
- [`1a9f237`](https://github.com/clouddrove/terraform-aws-elasticache/commit/1a9f2375e111d41ad63062223eb53afd5a669a4d) - fix terratest

## [0.14.0] - 2021-05-10
### :bug: Bug Fixes
- [`9d3aea3`](https://github.com/clouddrove/terraform-aws-elasticache/commit/9d3aea30030b2a5e59a8e44163477eb416690ef5) - upgrade redis version in example
- [`eef1a37`](https://github.com/clouddrove/terraform-aws-elasticache/commit/eef1a37695dce7012188f9e919de0626ca780117) - upgrade terraform version 0.15

## [0.13.0] - 2020-20-23
### :bug: Bug Fixes
- [`85acad0`](https://github.com/clouddrove/terraform-aws-elasticache/commit/85acad025ecdcb09520ba534cf9ed76c3424411f) - snapshot_retention_limit
- [`3c7cd8a`](https://github.com/clouddrove/terraform-aws-elasticache/commit/3c7cd8aa922f0d83552ba34f4e46b9a91c4533e9) - fix the security bugs
- [`0f9e401`](https://github.com/clouddrove/terraform-aws-elasticache/commit/0f9e401c990bfdf346ebfdde8fed91bd5e51a335) - Upgrade terraform version to 0.14 and update
- [`dda84e7`](https://github.com/clouddrove/terraform-aws-elasticache/commit/dda84e77616114c7120000955d1fd960475b30e8) - precommit updated

## [0.12.6] - 2020-06-10
### :bug: Bug Fixes
- [`03ab463`](https://github.com/clouddrove/terraform-aws-elasticache/commit/03ab463cd2e94cba60ff796a037c967c39bd2b97) - terraform.yml changes
- [`4b5613a`](https://github.com/clouddrove/terraform-aws-elasticache/commit/4b5613aacb419cde8ba7a994578c5847a8dd79a4) - upgrade terrafomr to 0.13

## [0.12.5] - 2020-05-25
### :sparkles: New Features
- [`7295372`](https://github.com/clouddrove/terraform-aws-elasticache/commit/72953724964b3890f53ed09cb959d2e1963cabc1) - add kms for encryption

## [0.12.4] - 2020-03-30
### :bug: Bug Fixes
- [`5af4c3d`](https://github.com/clouddrove/terraform-aws-elasticache/commit/5af4c3dc475fe8699f61d4d4984d73dbe738066e) - create variable for description
- [`dbad321`](https://github.com/clouddrove/terraform-aws-elasticache/commit/dbad321e2b42942b866ca278f740de205d502adb) - Split endpoint to redis_endpoint_address and memcached_endpoint_address
- [`d8ffe30`](https://github.com/clouddrove/terraform-aws-elasticache/commit/d8ffe304d87caed73d18dd8195d393dbf5f0f5eb) - Add endpoint address

## [0.12.3] - 2020-01-23
### :bug: Bug Fixes
- [`50ee184`](https://github.com/clouddrove/terraform-aws-elasticache/commit/50ee184da31b10caccde1608a4219c1fb98a48f2) - fix labels managedby variables

## [0.12.2] - 2019-12-30
### :bug: Bug Fixes
- [`3fdc09a`](https://github.com/clouddrove/terraform-aws-elasticache/commit/3fdc09aa401b09129bafbb88c10e64c149f52b43) - add bool option

## [0.12.1] - 2019-09-24
### :bug: Bug Fixes
- [`aafb837`](https://github.com/clouddrove/terraform-aws-elasticache/commit/aafb8370afe4e4c3f9b914d77e61b2a86b2c456d) - github action

## [0.12.0] - 2019-09-12
### :bug: Bug Fixes
- [`e3a1d17`](https://github.com/clouddrove/terraform-aws-elasticache/commit/e3a1d171cbec5d78b69f662497cad25a8c9f4d30) - change output syntax


[0.12.0]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.12.0...master
[0.12.1]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.12.1...master
[0.12.2]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.12.2...master
[0.12.3]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.12.3...master
[0.12.4]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.12.4...master
[0.12.5]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.12.5...master
[0.12.6]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.12.6...master
[0.13.0]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.13.0...master
[0.14.0]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.14.0...master
[0.15.0]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.15.0...master
[0.12.7]: https://github.com/clouddrove/terraform-aws-elasticache/releases/tag/0.12.7
[0.15.1]: https://github.com/clouddrove/terraform-aws-elasticache/compare/0.15.1...master
[1.0.1]: https://github.com/clouddrove/terraform-aws-elasticache/compare/1.0.1...master
[1.0.2]: https://github.com/clouddrove/terraform-aws-elasticache/compare/1.0.2...master
[1.0.3]: https://github.com/clouddrove/terraform-aws-elasticache/compare/1.0.3...master
[1.0.4]: https://github.com/clouddrove/terraform-aws-elasticache/compare/1.0.4...master

