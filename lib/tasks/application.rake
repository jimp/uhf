namespace :app do
  namespace :piston do

    # svn://rubyforge.org/var/svn/ror-akismet
    # TODO: monitor http://dev.rubyonrails.org/ticket/8532
    # TODO: refactor to make this more scalable
    # TODO: check for existence before adding - that way I don't have to make separate tasks
    desc "Imports all of the necessary and common plugins using piston"
    task :plugins do
      plugins=[
        {:url=>"http://svn.viney.net.nz/things/rails/plugins/acts_as_taggable_on_steroids", :name=>"acts_as_taggable_on_steroids"},
        {:url=>"http://svn.techno-weenie.net/projects/plugins/attachment_fu/", :name=>"attachment_fu"},
        {:url=>"http://svn.nanorails.com/plugins/action_mailer_tls/", :name=>"action_mailer_tls"},
        {:url=>"http://svn.rubyonrails.org/rails/plugins/atom_feed_helper/", :name=>"atom_feed_helper"},
        {:url=>"svn://errtheblog.com/svn/plugins/will_paginate", :name=>"will_paginate"},
        {:url=>"http://svn.techno-weenie.net/projects/plugins/us_states/", :name=>"us_states"},
        {:url=>"svn://rubyforge.org/var/svn/geokit/trunk", :name=>"geokit"},
        {:url=>"svn://caboo.se/plugins/court3nay/spider_test", :name=>"spider_test"},
        {:url=>"svn://rubyforge.org/var/svn/rspec/tags/CURRENT/rspec", :name=>"rspec"},
        {:url=>"svn://rubyforge.org/var/svn/rspec/tags/CURRENT/rspec_on_rails", :name=>"rspec_on_rails"},
        {:url=>"http://svn.pragprog.com/Public/plugins/annotate_models/", :name=>"annotate_models"},
        {:url=>"http://dev.rubyonrails.org/svn/rails/plugins/exception_notification/", :name=>"exception_notification"},
        {:url=>"http://dev.rubyonrails.com/svn/rails/plugins/tztime/", :name=>"tztime"},
        {:url=>"http://dev.rubyonrails.org/svn/rails/plugins/tzinfo_timezone/", :name=>"tzinfo_timezone"},
        {:url=>"svn://rubyforge.org/var/svn/fckeditorp/trunk/fckeditor", :name=>"fckeditor"},
        {:url=>"http://activemerchant.googlecode.com/svn/trunk/active_merchant", :name=>"active_merchant"},
        {:url=>"http://svn.rubyonrails.org/rails/plugins/ssl_requirement/", :name=>"ssl_requirement"},
        {:url=>"svn://rubyforge.org/var/svn/betternestedset/trunk", :name=>"better_nested_set"},
        {:url=>"svn://projects.jkraemer.net/acts_as_ferret/tags/stable/acts_as_ferret", :name=>'acts_as_ferret'}
      ]

      plugins.each do |plugin|
        p "executing svn up..."
        system "svn up"
        p "executing piston import of #{plugin[:name]}..."
        system "piston import #{plugin[:url]} vendor/plugins/#{plugin[:name]}"
      end

      p "committing the changes..."
      system 'svn commit -m "Added rails plugins to vendor/plugins via piston"'

      p "IMPORTANT: You must do a search and replace for @request.relative_url_root (and change it to request) in fck files if you are using edge rails!!"

    end

    task :rails do
      p "executing svn up..."
      system "svn up"
      p "executing piston import of rails trunk to vendor/rails..."
      system "piston import http://svn.rubyonrails.org/rails/trunk/ vendor/rails"
      p "committing the changes..."
      system 'svn commit -m "Added rails trunk to vendor/rails via piston"'
    end

  end

  namespace :data do
    task :swap_title_and_link_text => :environment do
      for page in Page.find(:all)
        title = page.title
        text = page.link_text
        p page.update_attributes(:title => text, :link_text => title)
      end
    end
  end

  # this namespace contain methods that allow you to remove whole features from the site
  namespace :teardown do
    task :messages do
      delete_all('message')
    end

    task :posts do
      delete_all('post')
    end

    def delete_all(model_name)
      # TODO: remove related files, including migrations
      # TODO: print warning about migrating the database, and routes
      p "Not Implemented Yet"
    end
  end

  namespace :setup do
    task :users=>:environment do
      p 'creating users...'
      User.delete_all
      r=Role.find_or_create_by_name('admin')
      u=User.new;u.login='jeff';u.password=u.password_confirmation='jeff';u.email='jeff@jasperdesign.com';u.role = r;p u.save
      u=User.new;u.login='jim';u.password=u.password_confirmation='jasper';u.email='jim@jasperdesign.com';u.role = r;p u.save
      u=User.new;u.login='noah';u.password=u.password_confirmation='jasper';u.email='noah@jasperdesign.com';u.role = r;p u.save
      u=User.new;u.login='bradd';u.password=u.password_confirmation='jasper';u.email='bradd@jasperdesign.com';u.role = r;p u.save
      u=User.new;u.login='gary';u.password=u.password_confirmation='gary';u.email='gary@jasperdesign.com';u.role = r;p u.save
      p 'users created'  
    end

    task :pages=>:environment do
      p 'creating pages...'
      Partial.create(:directory=>'templates', :name=>'partnerships', :description=>'Partnership', :thumbnail=>'partnership_template.gif', :position=>0)
      Partial.create(:directory=>'templates', :name=>'stories', :description=>'Stories from the field', :thumbnail=>'stories_template.gif', :position=>0)
      Partial.create(:directory=>'templates', :name=>'toolbox', :description=>'Toolbox', :thumbnail=>'toolbox_template.gif', :position=>0)
      Partial.create(:directory=>'templates', :name=>'index', :description=>'the template for the index page', :thumbnail=>'index_template.gif', :position=>0)
      Page.create(:partial_id=>Partial.find(:first).id, :path=>'index')
      Alias.update
      p 'pages created'
    end

    #  task :categories=>:environment do
    #   cat = CategoryGroup.create(:name=>"By NORC Blueprint Step")
    #   cat.categories.create(:name=>"Community")
    #   cat.categories.create(:name=>"Partnership")
    #   cat.categories.create(:name=>"Implementation")
    #   cat.categories.create(:name=>"Evaluation")
    #   cat.categories.create(:name=>"Sustainability")
    #   cat = CategoryGroup.create(:name=>"By NORC Type")
    #   cat = CategoryGroup.create(:name=>"By Location")
    #   cat = CategoryGroup.create(:name=>"By Health Issue")
    #   cat = CategoryGroup.create(:name=>"By Community/Social Support Issues")
    # end

    task :icons do
      system "ln -s ~/sites/icons public/images/icons"
    end

    task :uploads do
      system "mkdir public/uploads"
      system "chmod -R o+rw public/uploads"
    end

    task :templates=>:environment do
      PageTemplate.create(:name=>'template1', :thumbnail=>'template1.gif')
      PageTemplate.create(:name=>'template2', :thumbnail=>'template2.gif')
      PageTemplate.create(:name=>'template3', :thumbnail=>'template3.gif')
    end
  end
end

namespace :regex do
  desc "Clear out empty paragraphs"
    task :paragraph=>:environment do
    	ContentBlock.transaction do
			ContentBlock.find(:all).each do |block|
				[[/<p>&nbsp;<\/p>/,""]].each do |pair|
				# [[/Space Replaced/,""]].each do |pair|
					block.text.gsub!(pair[0],pair[1]) unless block.text.empty?
				end
			puts block.text
			block.save!
			end
		end  
	end
end
  

# Tasks to make setting up your local machine easier
namespace :local do
  namespace :db do
    desc "Copies the latest backup of the production database to your local machine using scp, then unzips with gunzip and restores the local database.  Intended for mac osx leopard"
    task :restore => :environment do
      if RAILS_ENV != 'production'
        system "scp deploy@dev.jasper.railsmachina.com:/var/backup/uhf/mysql/mysql-daily-#{Date.today.day.to_s.rjust(2,"0")}.sql.gz production.sql.gz"
        system "gunzip production.sql.gz -f"
        system "/opt/local/bin/mysql5 uhf_development < production.sql"
      else
        puts "You can only run this on non-production sites"
      end
    end
  end
end
