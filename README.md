dockerclean
===========
A simple utility to make it easier to cleanup Docker images and containers.

Usage
-----
`dockerclean [OPTIONS]`

- `-c PATTERN`: Remove all containers matched by `PATTERN`
- `-d`: Remove all images tagged as `<none>`
- `-r`: By default `dockerclean` executes in `dry-run` mode to give you a chance
  to preview any images or containers that will get deleted. Use the `-r` flag
  to remove matched images and containers.
- `-t PATTERN`: Remove all images matched by `PATTERN`
- `-h`: Print usage and options
