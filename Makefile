run:

	NODE_PATH='lib:app' nodemon --watch app --watch lib app.js

debug:

	NODE_PATH='lib:app' nodemon --watch app --watch lib --debug app.js

prod:

	NODE_ENV=production node app.js

test:

	@NODE_ENV=test NODE_PATH='lib:app' ./node_modules/.bin/mocha $(arg)

test_watch:

	@NODE_ENV=test NODE_PATH='lib:app' ./node_modules/.bin/mocha \
		--growl \
		--watch \
		$(arg)

test_web:

	open http://localhost:3030/test

.PHONY: run debug prod test test_watch test_web
