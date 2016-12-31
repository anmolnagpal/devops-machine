.PHONY: release major minor patch

release:

	@git push origin master
	@git push origin master --tags

major:
	@bumpversion major

minor:
	@bumpversion minor

patch:
	@bumpversion patch