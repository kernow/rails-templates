
# Add gems
gem "thoughtbot-clearance", 
  :lib     => 'clearance', 
  :source  => 'http://gems.github.com'

# install and unpack the clearance gem
rake "gems:install", :sudo => true
rake "gems:unpack"
  
gem 'webrat',
  :env => 'test'
gem 'cucumber',
  :env => 'test'
gem 'thoughtbot-factory_girl',
  :lib     => 'factory_girl',
  :source  => "http://gems.github.com",
  :env => 'test'
gem 'mocha',
  :env => 'test'
gem 'thoughtbot-shoulda',
  :lib => 'shoulda',
  :source => 'http://gems.github.com',
  :env => 'test'
  
gem 'mislav-will_paginate',
  :lib => 'will_paginate',
  :source => 'http://gems.github.com'

rake "gems:install", :sudo => true

# run clearance generator
generate :clearance
rake "db:migrate"

environment "# clearance\r\nHOST = 'localhost'", :env => 'test'
environment "# clearance\r\nHOST = 'localhost'", :env => 'development'

domain = ask("What domain will this application run under?")

environment "HOST = \"#{domain}\"", :env => 'production'
append_file 'config/environment.rb', "\r\n\r\n# clearance\r\nDO_NOT_REPLY = 'donotreply@#{domain}'\r\n"

generate :controller, "front", "index"
route "map.root :controller => 'front'"

# remove unwanted files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
%w{application.js controls.js dragdrop.js effects.js prototype.js}.each {|f| run "rm public/javascripts/#{f}" }

git :init

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/example_database.yml"

git :add => '.'
git :commit => "-m 'initial commit'"