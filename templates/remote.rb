REMOTE_PATH = "github.com/tsechingho/authlogic_bundle"
REMOTE_SOURCE = "http://#{REMOTE_PATH}/raw/master"

ENV['SCM'] = 'git' if yes?('Use git as scm? (y/n)')

def git?
  ENV['SCM'] == 'git'
end

load_template("#{REMOTE_SOURCE}/templates/git_init.rb") if git?

rails_edge_path = ask("If you want to symbol link rails edge, please give absolute path or press enter to skip:")
run "ln -s #{rails_edge_path} vendor/rails" unless rails_edge_path.blank?

plugin 'authlogic_bundle', :submodule => git?, :git => "git://#{REMOTE_PATH}.git"

load_template("vendor/plugins/authlogic_bundle/templates/base.rb")

%w(testing monitor).each do |suite|
  if yes?("Do you want to include bundled #{suite} suite? (y/n)")
    load_template("vendor/plugins/authlogic_bundle/templates/#{suite}.rb") 
  end
end
