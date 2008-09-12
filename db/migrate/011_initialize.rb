class Initialize < ActiveRecord::Migration
  def self.up
    p 'creating users...'
    User.delete_all
    r=Role.find_or_create_by_name('admin')
    u=User.new;u.login='jeff';u.password=u.password_confirmation='jeff';u.email='jeff@jasperdesign.com';u.role = r;p u.save
    u=User.new;u.login='jim';u.password=u.password_confirmation='jasper';u.email='jim@jasperdesign.com';u.role = r;p u.save
    u=User.new;u.login='noah';u.password=u.password_confirmation='jasper';u.email='noah@jasperdesign.com';u.role = r;p u.save
    u=User.new;u.login='bradd';u.password=u.password_confirmation='jasper';u.email='bradd@jasperdesign.com';u.role = r;p u.save
    u=User.new;u.login='gary';u.password=u.password_confirmation='gary';u.email='gary@jasperdesign.com';u.role = r;p u.save
    p 'users created'  
    
    p 'creating pages...'
    index_template = Partial.create(:directory=>'templates', :name=>'template_index', :description=>'The index page', :thumbnail=>'index_template.gif', :position=>0)
    caregiver_template = Partial.create(:directory=>'templates', :name=>'template_caregivers', :description=>'Family Caregivers', :thumbnail=>'caregiver_template.gif', :position=>0)
    provider_template = Partial.create(:directory=>'templates', :name=>'template_providers', :description=>'Health Care Providers', :thumbnail=>'provider_template.gif', :position=>0)
    menu_template = Partial.create(:directory=>'templates', :name=>'template_menu', :description=>'Menu', :thumbnail=>'menu_template.gif', :position=>0)
    # Partial.create(:directory=>'templates', :name=>'toolbox', :description=>'Toolbox', :thumbnail=>'toolbox_template.gif', :position=>0)

    Page.create(:partial_id=>index_template.id, :path=>'index')
    Page.create(:partial_id=>caregiver_template.id, :path=>'caregivers.html')
    Page.create(:partial_id=>provider_template.id, :path=>'providers.html')
    Page.create(:partial_id=>menu_template.id, :path=>'left_top_menu')
    Page.create(:partial_id=>menu_template.id, :path=>'left_bottom_menu')
    Page.create(:partial_id=>menu_template.id, :path=>'moving_from_caregivers_menu')
    Page.create(:partial_id=>menu_template.id, :path=>'moving_from_providers_menu')
    
    # Alias.update
    p 'pages created'        
  end

  def self.down
    User.delete_all
    Partial.delete_all
    Page.delete_all
    Alias.update
  end
end
