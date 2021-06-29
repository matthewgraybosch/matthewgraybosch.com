.DEFAULT: build

update:
	bundle install

build: update
	bundle exec jekyll build

serve: update
	bundle exec jekyll serve --watch
