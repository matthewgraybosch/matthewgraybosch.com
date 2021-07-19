.DEFAULT: build

include .depend

update:
	bundle install

build: update
	bundle exec jekyll build

serve: update
	bundle exec jekyll serve --watch

entry:
	./commonplace.sh

install: build
	rsync --rsh="ssh ${SSH_OPTS}" \
		  --delete-delay \
		  -acvz \
		  _site/ ${REMOTE_HOST}:${REMOTE_PATH}
