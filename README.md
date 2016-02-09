# dockerclean
A simple utility to make it easier to cleanup Docker images and containers.

## Usage
`dockerclean [OPTIONS]`

- `-c PATTERN`: Remove all containers matched by `PATTERN`
- `-d`: Remove all images tagged as `<none>`
- `-e`: Remove all exited containers
- `-r`: By default `dockerclean` executes in `dry-run` mode to give you a chance
  to preview any images or containers that will get deleted. Use the `-r` flag
  to remove matched images and containers.
- `-i PATTERN`: Remove all images matched by `PATTERN`
- `-h`: Print usage and options

If `-e` and `-c` are used in conjunction, `dockerclean` will find all containers
that have exited or match the `PATTERN` provided.

## Build status
![master](https://circleci.com/gh/michael-yx-wu/dockerclean/tree/master.png?style=shield&circle-token=810386c47ffeb705bf8c4e52a88c0d2177e82230) (master)

![develop](https://circleci.com/gh/michael-yx-wu/dockerclean/tree/develop.png?style=shield&circle-token=810386c47ffeb705bf8c4e52a88c0d2177e82230) (develop)
