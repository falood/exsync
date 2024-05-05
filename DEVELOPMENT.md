# Publishing a release

1. Update version in mix.exs
2. Update changelog
3. Run `MIX_ENV=docs mix hex.publish`
4. Tag a release (e.g. `git tag 0.4.1`)
5. Push the tag with `git push --tags`
