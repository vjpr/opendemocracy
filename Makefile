debug:

	nodemon --watch src --watch lib --watch app.js --debug app.js

run:

	nodemon --watch src --watch lib --watch app.js app.js

compile:

	node app.js

prod:

	NODE_ENV=production node app.js

debug-inspector:

	node-inspector &

debug1:

	node --debug app

debug-brk:

	node --debug-brk app

test:

	@./node_modules/.bin/mocha $(arg)

testfe:

	open http://localhost:3030/test/

watch:

	guard

.PHONY: test testfe run debug watch prod debug-inspector debug1 debug-brk compile
