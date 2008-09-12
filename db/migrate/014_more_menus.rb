class MoreMenus < ActiveRecord::Migration
  def self.up
    Partial.create(:directory=>'templates', :name=>'template_caregivers_no_menu', :description=>'Family Caregivers w/o menus', :thumbnail=>'caregiver_template.gif', :position=>0)
    Partial.create(:directory=>'templates', :name=>'template_providers_no_menu', :description=>'Health Care Providers w/o menus', :thumbnail=>'provider_template.gif', :position=>0)
  end

  def self.down
    item = Partial.find_by_name  'template_caregivers_no_menu'
    Partial.delete item
    item = Partial.find_by_name 'template_providers_no_menu'
    Partial.delete item
  end
end
