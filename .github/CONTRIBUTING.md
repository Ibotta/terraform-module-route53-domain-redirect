# Contributing

### Prerequisites

We use `mise-en-place` as a tool manager.  Install the following:

- [mise-en-place](https://mise.jdx.dev/)

Once installed, you can install our version of `terraform` and `terraform-docs` with:

```sh
mise install
```

## Important Notes
* Module versions should follow best practices for [Semantic Versioning](https://semver.org/).

## Creating a new AND latest version of a module

These steps are for creating a new version of the module that is **based off of the latest version of the module**.  This is the most common use case for creating a new module version. If you are updating a previously released module that is not currently the latest version of the module, see [Patching Released Tags](#patching-released-tags) instead. The main difference being patches to previous versions should not be merged into `main` and should be tagged with the previous version number and closed unmerged instead.

  1. Create a branch off of `main`
  1. Make changes to the module
  1. Update the [CHANGELOG.md](./CONTRIBUTING.md) file with the new version and changes
  1. Run the formatting and docs script [Documentation and Formatting](#documentation-and-formatting)
  1. Test your changes with [Module Testing](#module-testing)
  1. Create a PR for review
  1. Once approved, merge the PR into `main` 
  1. Follow the steps below to create a new tag using the Github Release process.

### Using Github Releases to create a new tag

Follow these steps to create a new tag and release in Github.  This can also be used for patched released tags.  The benefit of the release process is to notify subscribers of the new tag.

1. After merging your branch into `main`, navigate to the [Releases page for this module](https://github.com/Ibotta/terraform-module-route53-domain-redirect/releases).
1. Click `Draft a new release`.
1. Click `Choose a tag`, and type in the _new_ tag version you want to create.  You'll see an option for "Create new tag: **<TAG_NAME>** on publish".
  1. For updates to the latest version of a module, keep the `Target` as `main`.
  1. For patching released tags (backporting), change the `Target` to the tag that you branched from.
1. Use the tag name as the `Release title`.
1. Create your own Release Notes.  You can use your CHANGELOG notes as an easy option, or click `Generate release notes`.  This will generate notes based on the latest merged PRs but can sometimes create extra noise for merged PRs without associated releases. The goal is having a descriptive message with what features are being added, changed, or deprecated.
1. Keep the `Set as the latest release`.
1. Click `Publish Release`.

## Patching Released Tags

It is sometimes necessary to make changes to previously released module tags (also known as "backporting") for a repository that may not be able to update to newer versions of Terraform or the Terraform AWS Provider. Introducing a patch version of a previously released tag can allow fixes and even new features to help maintain the infrastructure.

You can follow the Release process detailed above after the tag is created and pushed to notify users of the new tag being available.

### Review Process and Creating a new tag

Proceed with making commits, adhering to the style of the repository at the time (in some cases, we may not have had `CHANGELOG` documents or `terraform-docs` for formatting yet).  Once done, push up your branch to create a pull request for review.  Follow the guide below on [Module Testing](#module-testing) to make sure the changes work as expected.

**⚠️ IMPORTANT ⚠️:** Instead of merging the PR after the review process, you will create a new tag locally and push that up.  Once it is available on GitHub, you can close your PR without merging. Finally, follow the [Github Releases](#using-github-releases-to-create-a-new-tag) process to publish the tag to subscribers.

```
git tag -a <VERSION-TAG> -m "<CHANGELOG-MESSAGE>"
git push origin <VERSION-TAG>
```

## Module Testing

After pushing up changes in a new branch and creating a PR, you can reference the branch in the module definition:

```hcl
module "module_name" {
  source = "git::ssh://git@github.com/Ibotta/terraform-module-route53-domain-redirect.git?ref=<branch>"
}
```

## Documentation and Formatting

This module is configured through [terraform-docs](https://github.com/terraform-docs/terraform-docs) and can be updated by adjusting either `docs-header.md` or the variable/output descriptions and re-running the following:

Short version: Run `./scripts/terraform_format_and_docs.sh`.

This script runs `terraform fmt` and `terraform-docs` on the module.

### Details
This module utilizes `terraform-docs` to generate the `README.md` file.

A few important points:
* You can see the terraform docs config file in [.terraform-docs.yml](../.terraform-docs.yml)
* You can see the version of `terraform-docs` and `terraform` in the [.tool-versions](../.tool-versions) asdf config at the root of the repository.

In order to update the documentation the following steps should be taken:
1. Update code as required.
1. Update the `docs-header.md` file if needed to provide updated usage instructions or new examples.
1. In `variables.tf` all `variables` should have a complete `description` field. 
1. All `output` attributes should include a comment immediately preceding the output defintion; this comment becomes the description of the attribute in the documentation. 
1. Add a `CHANGELOG.md` record indicating the change and the new version.
1. Run `./scripts/terraform_format_and_docs.sh`.