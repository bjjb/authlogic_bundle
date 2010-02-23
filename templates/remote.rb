REPOSITORY = template.sub(%r{^\w+//}, '').sub(%r{(/raw/master)?/templates/remote.rb}, '')
puts "Using repository: #{REPOSITORY}"

ENV['SCM'] = 'git' if yes?('Use git as scm? (y/n)')

def git?
  ENV['SCM'] == 'git'
end

load_template("http://#{REPOSITORY}/raw/master/templates/git_init.rb") if git?

rails_edge_path = ask("If you want to symbol link rails edge, please give absolute path or press enter to skip:")
run "ln -s #{rails_edge_path} vendor/rails" unless rails_edge_path.blank?

plugin 'authlogic_bundle', :submodule => git?, 
  :git => "git://#{REPOSITORY}.git"

load_template("vendor/plugins/authlogic_bundle/templates/base.rb")

%w(testing monitor).each do |suite|
  if yes?("Do you want to include bundled #{suite} suite? (y/n)")
    load_template("vendor/plugins/authlogic_bundle/templates/#{suite}.rb") 
  end
end
