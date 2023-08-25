# Set up Nix along with caching

A set of GitHub actions for setting up a multi-user Nix environment with a binary cache for uploading and fetching derivation outputs.

The repository contains the following actions:
* `by-root`: Sets up `nix.conf` with a `post-build-hook` so that intermediate and final build outputs are uploaded by the root.
* `by-runner`: Starts a background upload job as the action runner and sets up `nix.conf` with a `post-build-hook` so that intermediate and final build outputs are passed to the action runner for cache uploads.
* `copy-root-aws-credentials`: Copies the AWS credentials of the action runner to the root user. This is meant to be used for giving the root user access to binary caches. In the case of a `by-root` workflow, this can be used to give root write permissions and in the case of a private cache, it can be used to give root read permissions.

Depending on the binary cache in question, these actions can be used together in a number of ways, some example use cases:
* A public AWS S3 bucket: A `by-root` + `copy-root-aws-credentials` setup is recommended. One can also use `by-runner` only, but `by-runner` adds around a minute of setup time to each run.
* A private AWS S3 bucket: `by-root` + `copy-root-aws-credentials` will work same as before. If `by-runner` is preferred, it will also `copy-root-aws-credentials` since otherwise the Nix builder won't be able to read from the private S3 bucket.
* Other kind of cache (e.g. over SSH, etc.): As long as the github action runner has access to the cache, `by-runner` can be used to enable cache uploads, but if the cache is private, a custom step will be required to give the root user access to it. If root is given access, then `by-root` can also be used instead of `by-runner` in order to avoid the setup overhead.

## Example

Please check [.github/workflows/test.yml](.github/workflows/test.yml) for an example using an AWS S3 bucket as a Nix cache.
