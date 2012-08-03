run:

	nodemon --watch src --watch app.js --debug app.js

compile:

	node app.js

prod:

	NODE_ENV=production node app.js

debug-inspector:

	node-inspector &

debug:

	node --debug app

debug-brk:

	node --debug-brk app

test:

	@./node_modules/.bin/mocha $(arg)

testfe:

	open http://localhost:3030/test/

watch:

	guard

.PHONY: test testfe run watch prod debug-inspector debug debug-brk compile
