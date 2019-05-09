# Install all dependencies for the project
# And then set up the database
puts "Installing external dependencies..."
system(`echo brew install imagemagick@6`)
system(`echo brew link --force imagemagick@6`)
puts "...Done"
puts
# puts "Updating bundle..."
# system(`echo bundle update`)
puts "Installing gems..."
system(`echo bundle install --with imagemagick`)
puts "...Done"
puts
system(`echo rake setup_db`)
