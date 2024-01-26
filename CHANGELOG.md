# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.3] - 2024-01-26
### :bug: Bug Fixes
- [`837864c`](https://github.com/clouddrove/terraform-aws-ec2/commit/837864cf57d5ed4a9b8a1d8c328eebb3cca477f7) - shutdown behavior for the instance defaults to STOP *(PR [#66](https://github.com/clouddrove/terraform-aws-ec2/pull/66) by [@h1manshu98](https://github.com/h1manshu98))*

### :construction_worker: Build System
- [`592d4ed`](https://github.com/clouddrove/terraform-aws-ec2/commit/592d4edd2c51560e36f1f2e83c8bb5b53f34cfcb) - **deps**: bump clouddrove/github-shared-workflows *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*

### :memo: Documentation Changes
- [`0d16756`](https://github.com/clouddrove/terraform-aws-ec2/commit/0d16756ee156cb75169a9c3aa0b1244e809d7b2b) - update CHANGELOG.md for 2.0.2 *(commit by [@clouddrove-ci](https://github.com/clouddrove-ci))*


## [2.0.2] - 2024-01-12
### :construction_worker: Build System
- [`2475949`](https://github.com/clouddrove/terraform-aws-ec2/commit/247594902bba486cb4df7533de7fe99d1d4bfca8) - **deps**: bump clouddrove/subnet/aws in /_example/complete *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`4007b9e`](https://github.com/clouddrove/terraform-aws-ec2/commit/4007b9e0e9d156cf5a88b121de67aa5dfac6e02b) - **deps**: bump actions/setup-python from 4 to 5 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`b8f9bdb`](https://github.com/clouddrove/terraform-aws-ec2/commit/b8f9bdb52270e94a34655b893779f3b98822a8fe) - **deps**: bump clouddrove/github-shared-workflows *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*

### :memo: Documentation Changes
- [`7bcfa83`](https://github.com/clouddrove/terraform-aws-ec2/commit/7bcfa8324a2a573a87673f78f1484e8850f79254) - update CHANGELOG.md for 2.0.1 *(commit by [@clouddrove-ci](https://github.com/clouddrove-ci))*


## [2.0.1] - 2023-11-22
### :bug: Bug Fixes
- [`a95d8c8`](https://github.com/clouddrove/terraform-aws-ec2/commit/a95d8c8ce420494fcb56724038d72f294a69cc21) - kms policy fixed *(PR [#55](https://github.com/clouddrove/terraform-aws-ec2/pull/55) by [@d4kverma](https://github.com/d4kverma))*

### :construction_worker: Build System
- [`1e27c43`](https://github.com/clouddrove/terraform-aws-ec2/commit/1e27c43183daa92b3b65b1f4fde63b5cccef690e) - **deps**: bump clouddrove/github-actions from 9.0.2 to 9.0.3 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*

### :memo: Documentation Changes
- [`19e732a`](https://github.com/clouddrove/terraform-aws-ec2/commit/19e732a921b49985a65f954ee4f1c1d703e79a91) - update CHANGELOG.md for 2.0.0 *(commit by [@clouddrove-ci](https://github.com/clouddrove-ci))*


## [2.0.0] - 2023-09-06
### :sparkles: New Features
- [`639f19a`](https://github.com/clouddrove/terraform-aws-ec2/commit/639f19ade34e03f8d4f8a309b9b8820754cb79cc) - auto changelog action added *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`2f9367e`](https://github.com/clouddrove/terraform-aws-ec2/commit/2f9367ea5a238dc24f6326fec0fcae2e9867ee15) - auto changelog action added *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`f6ad766`](https://github.com/clouddrove/terraform-aws-ec2/commit/f6ad76641ff1da90cf7b2873a04998cb46db9113) - added dependabot.yml file *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`9501122`](https://github.com/clouddrove/terraform-aws-ec2/commit/95011227698201a367e418bec528f375d2b1eaaf) - add deepsource & added assignees,reviewer in dependabot *(commit by [@Tanveer143s](https://github.com/Tanveer143s))*
- [`d25dd33`](https://github.com/clouddrove/terraform-aws-ec2/commit/d25dd33d8cafd62a5505ac31d47de3957699b9cc) - add deepsource & added assignees,reviewer in dependabot *(commit by [@Tanveer143s](https://github.com/Tanveer143s))*
- [`785a0b3`](https://github.com/clouddrove/terraform-aws-ec2/commit/785a0b312c9bf5f7aed7ae0e30a1d5a7869f95e8) - add deepsorce file *(commit by [@Tanveer143s](https://github.com/Tanveer143s))*
- [`aa714d3`](https://github.com/clouddrove/terraform-aws-ec2/commit/aa714d3b288b41f4c263fa4a45e6fc642ebdfdb9) - add deepsorce file *(commit by [@Tanveer143s](https://github.com/Tanveer143s))*
- [`e597f20`](https://github.com/clouddrove/terraform-aws-ec2/commit/e597f2029311ac36a7424e5c31ec6a9e3400c68e) - added security-group-rule and kms main.tf *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`224c4d9`](https://github.com/clouddrove/terraform-aws-ec2/commit/224c4d94743f5514856421eb6206995895b949c1) - added security-group-rule and kms main.tf *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`7093a75`](https://github.com/clouddrove/terraform-aws-ec2/commit/7093a756830c33845b4666209d87c26f4050fff8) - added key-pair and spot instance main.tf *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`4225f40`](https://github.com/clouddrove/terraform-aws-ec2/commit/4225f400a9daef811cdddaac0b879f60060791fe) - added key-pair and spot instance main.tf *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`887e684`](https://github.com/clouddrove/terraform-aws-ec2/commit/887e684a334dc85d67e74759afadfa57c36008fb) - added key-pair and spot instance testing *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`00b23c4`](https://github.com/clouddrove/terraform-aws-ec2/commit/00b23c4c2210db82b57388fa78417632cdf142f3) - added key-pair and spot instance testing *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`fed8d3e`](https://github.com/clouddrove/terraform-aws-ec2/commit/fed8d3eba5af92136dad816d44dadd4b7c5c1bae) - added key-pair and spot instance testing *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`2315645`](https://github.com/clouddrove/terraform-aws-ec2/commit/2315645e656add51f39eedee3727419cdc1ac308) - fix tflint and added vpc and subnet tag *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`70f539c`](https://github.com/clouddrove/terraform-aws-ec2/commit/70f539cef609a145d2630b3a337c9e3bdfb00cee) - fix tflint and added vpc and subnet tag *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`8d6af6c`](https://github.com/clouddrove/terraform-aws-ec2/commit/8d6af6c24523ea484b63ba13d3c4642762945746) - update subnet and vpc tag *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*

### :bug: Bug Fixes
- [`8610ee3`](https://github.com/clouddrove/terraform-aws-ec2/commit/8610ee3c11ce11960191371dfaf40078bc77feb3) - Update user-data.sh *(PR [#54](https://github.com/clouddrove/terraform-aws-ec2/pull/54) by [@13archit](https://github.com/13archit))*

### :construction_worker: Build System
- [`6dec4c8`](https://github.com/clouddrove/terraform-aws-ec2/commit/6dec4c8d52f8b3afcb99dba7dc57d71531000f0b) - **deps**: bump clouddrove/vpc/aws in /_example/basic_example *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`64126fd`](https://github.com/clouddrove/terraform-aws-ec2/commit/64126fd9254bbf174d0c6fa125730138f83819bc) - **deps**: bump clouddrove/vpc/aws in /_example/ebs_mount *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*


## [1.3.0] - 2023-01-10
### :bug: Bug Fixes
- [`138df1a`](https://github.com/clouddrove/terraform-aws-ec2/commit/138df1af37e3967148c950ba263c9e9dd8c006a5) - update workflows

### :sparkles: New Features
- [`aff98ab`](https://github.com/clouddrove/terraform-aws-ec2/commit/aff98ab6ec1e492e78665f6c58b52539dba11e00) - Added multi_attach ebs volume

## [1.0.2] - 2022-09-16
### :bug: Bug Fixes
- [`3dafc9c`](https://github.com/clouddrove/terraform-aws-ec2/commit/3dafc9c5ba499f2ad182239f05d84e4e535ca1a9) - update terraform letest version


## [1.0.1] - 2022-05-18
### :sparkles: New Features
- [`3ac90df`](https://github.com/clouddrove/terraform-aws-ec2/commit/3ac90df3c1d3c920700a2a67445c649e492c626d) - added hiberation tag


## [0.12.5.2] - 2021-09-07

## [0.12.5.1] - 2021-08-17

## [0.15.1] - 2021-07-08
### :bug: Bug Fixes
- [`c824f12`](https://github.com/clouddrove/terraform-aws-ec2/commit/c824f12ac172b8b524a8e1cea1cd813a9ff543c9) - Fix versions
- [`e154336`](https://github.com/clouddrove/terraform-aws-ec2/commit/e15433686738ed2996dbcc58082af8158dcb41f8) - ipv6 error fixed
- [`b47bfd4`](https://github.com/clouddrove/terraform-aws-ec2/commit/b47bfd4ee3a67b079fd73969469238c8ba5da225) - update github-action


## [0.15.0] - 2021-06-18
### :bug: Bug Fixes
- [`bda3099`](https://github.com/clouddrove/terraform-aws-ec2/commit/bda30991c482fcdfa78ee870bffce261f27ccba6) - fixed ebs volume
- [`795462e`](https://github.com/clouddrove/terraform-aws-ec2/commit/795462e05731e91f184b7dfa89e733c05fd789e9) - Update example.tf
- [`aa59be9`](https://github.com/clouddrove/terraform-aws-ec2/commit/aa59be92333b42b07ae61912f19c61b4dae249f4) - fix the examples and volumes part
- [`89edf54`](https://github.com/clouddrove/terraform-aws-ec2/commit/89edf5498bf0ee385b9702466c41c8c7aae6d6ed) - fix terratest

## [0.14.0] - 2021-05-15
### :bug: Bug Fixes
- [`39e0c01`](https://github.com/clouddrove/terraform-aws-ec2/commit/39e0c012f6a3cad6e7a446c69b0429ba1b4a2ccc) - update module tags
- [`c6594c8`](https://github.com/clouddrove/terraform-aws-ec2/commit/c6594c8ed4a075a2327dda2b1d53ab4f4ab054a3) - version update in modules
- [`5539ee7`](https://github.com/clouddrove/terraform-aws-ec2/commit/5539ee7b0907eef6518a0d0f78ccc9f49bbf5b00) - ebs_mount
- [`39b6d1b`](https://github.com/clouddrove/terraform-aws-ec2/commit/39b6d1bf2a5a199712617d271f2ddcdd47e6e5f6) - auto_ami_enable
- [`5c3c4e8`](https://github.com/clouddrove/terraform-aws-ec2/commit/5c3c4e89469abc82c144000383306ccc6d9032e4) - update in 0.15
- [`4629c8d`](https://github.com/clouddrove/terraform-aws-ec2/commit/4629c8de04da4ced5dfb7fd7b44b8219fcd45e34) - encrypted true
- [`5da31d0`](https://github.com/clouddrove/terraform-aws-ec2/commit/5da31d033e7fd9e0ceb4d476ff3d116dc1b3bdba) - removed variable network
- [`3887fbb`](https://github.com/clouddrove/terraform-aws-ec2/commit/3887fbb00486445eda57a7cc1be3aa8320e3a47a) - improvements for bridgecrew
- [`c5bdfba`](https://github.com/clouddrove/terraform-aws-ec2/commit/c5bdfbacf2540618f010b57024c5ccbd79dd9745) - security fixes added
- [`4670aa5`](https://github.com/clouddrove/terraform-aws-ec2/commit/4670aa5378c9f39daa0193911ef1ecf9b52c598b) - enabled-ebs-optimized
- [`dd40b00`](https://github.com/clouddrove/terraform-aws-ec2/commit/dd40b007746ae2ce6a787837228217c311de30f2) - enable-encrypted
- [`fc3e6cc`](https://github.com/clouddrove/terraform-aws-ec2/commit/fc3e6cc0176f2b3d2a6df5ccaa5273bc9f3c36f8) - enable_monitoring


## [0.13.0] - 2020-10-21
### :bug: Bug Fixes
- [`d427049`](https://github.com/clouddrove/terraform-aws-ec2/commit/d4270491494da9a5131f038ca2e4cd940d47cf36) - upgrade to 0.14
- [`9382198`](https://github.com/clouddrove/terraform-aws-ec2/commit/9382198f1155da46de60930f8310904c52801b08) - change tag name in main.tf
- [`dd1ca4e`](https://github.com/clouddrove/terraform-aws-ec2/commit/dd1ca4e914c671e6b60d2e2973cde4b9d1ff687a) - Upgrade terraform version to 0.14.0

## [0.12.8] - 2020-10-21
### :bug: Bug Fixes
- [`b718512`](https://github.com/clouddrove/terraform-aws-ec2/commit/b718512f3814523b7dbe7c3107258f98e6f22906) - upgrade terraform version and update pipeline
- [`173f604`](https://github.com/clouddrove/terraform-aws-ec2/commit/173f60483529fb30897a4e31fb64a8ccefb4cb6e) - update terratest pipeline
- [`7283c80`](https://github.com/clouddrove/terraform-aws-ec2/commit/7283c800c9e193bcce08ee8721b5ece93ff8256f) - update pre-commit & terraform version
- [`370e587`](https://github.com/clouddrove/terraform-aws-ec2/commit/370e587d96ffb71223b447bf831feeb743f6e727) - upgrade 0.13

## [0.12.7] - 2020-04-28
### :bug: Bug Fixes
- [`1fc2ad7`](https://github.com/clouddrove/terraform-aws-ec2/commit/1fc2ad71519efd616a2a18705f632a9b67e6db1a) - Update outputs.tf

## [0.12.6] - 2020-03-24
### :bug: Bug Fixes
- [`0dc2a97`](https://github.com/clouddrove/terraform-aws-ec2/commit/0dc2a97cb6c0f7c9a5d95f5455bdcdb0b2cd9f3b) - fix tag in readme
- [`2f3b6d7`](https://github.com/clouddrove/terraform-aws-ec2/commit/2f3b6d7d565ee43145122f574f904ee8a1e7e19b) - enable encryption with EBS

## [0.12.5] - 2020-01-23
### :bug: Bug Fixes
- [`c7929a3`](https://github.com/clouddrove/terraform-aws-ec2/commit/c7929a3a8d2a0bf5072034aeef5f5890d4f1bdc3) - fix labels

## [0.12.4] - 2019-12-28
### :sparkles: New Features
- [`66c687c`](https://github.com/clouddrove/terraform-aws-ec2/commit/66c687cd161f29b026666f07552f6d37430b4371) - add enable count in all resources

## [0.12.3] - 2019-11-05
### :bug: Bug Fixes
- [`38af014`](https://github.com/clouddrove/terraform-aws-ec2/commit/38af01451c5b60e5ba7e6049d711c99401a724fb) - github action

## [0.12.2] - 2019-10-14
### :bug: Bug Fixes
- [`5bcf414`](https://github.com/clouddrove/terraform-aws-ec2/commit/5bcf4141624fd9aca696a84af2308d8f47d867b7) - update lable order
- [`01ccf91`](https://github.com/clouddrove/terraform-aws-ec2/commit/01ccf9162916d5ea8d248c7f4a93792bbed3be5a) - update tags dns iam profile

## [0.12.1] - 2019-09-05
### :sparkles: New Features
- [`d83a91f`](https://github.com/clouddrove/terraform-aws-ec2/commit/d83a91f11d032242f5f9abf1b2366b607a7fc0d6) - add dynamic tags

## [0.12.0] - 2019-08-12
### :bug: Bug Fixes
- [`3c7e291`](https://github.com/clouddrove/terraform-aws-ec2/commit/3c7e291aad6baddc04eb431e58089ce0f4b9ea44) - update url

## [0.11.0] - 2019-08-12
### :bug: Bug Fixes
- [`b905b18`](https://github.com/clouddrove/terraform-aws-ec2/commit/b905b180a3e145255e6184d7de570d45055cb405) - terraform 0.12.0


[0.11.0]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.11.0...master
[0.12.0]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.0...master
[0.12.1]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.1...master
[0.12.2]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.2...master
[0.12.3]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.3...master
[0.12.4]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.4...master
[0.12.5]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.5...master
[0.12.6]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.6...master
[0.12.7]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.12.7...master
[0.12.8]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.11.8...master
[0.13.0]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.13.0...master
[0.14.0]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.14.0...master
[0.15.0]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.15.0...master
[0.15.1]: https://github.com/clouddrove/terraform-aws-ec2/compare/0.15.1...master
[0.12.5.1]: https://github.com/clouddrove/terraform-aws-ec2/releases/tag/0.12.5.1
[0.12.5.2]: https://github.com/clouddrove/terraform-aws-ec2/releases/tag/0.12.5.2
[1.0.1]: https://github.com/clouddrove/terraform-aws-ec2/compare/1.0.1...master
[1.0.2]:https://github.com/clouddrove/terraform-aws-ec2/compare/1.0.2...master
[1.3.0]: https://github.com/clouddrove/terraform-aws-ec2/compare/1.3.0...master


[2.0.0]: https://github.com/clouddrove/terraform-aws-ec2/compare/1.3.0...2.0.0
[2.0.1]: https://github.com/clouddrove/terraform-aws-ec2/compare/2.0.0...2.0.1
[2.0.2]: https://github.com/clouddrove/terraform-aws-ec2/compare/2.0.1...2.0.2
[2.0.3]: https://github.com/clouddrove/terraform-aws-ec2/compare/2.0.2...2.0.3