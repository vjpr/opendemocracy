# Add a line for each submodule which needs to be installed.
#(cd lib/foo && npm install)

# Install vendor assets with Bower
# TODO: See how this goes because it will be slow on Heroku because of the ephemeral file system for caching.
bower install
