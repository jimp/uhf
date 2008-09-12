class Category < ActiveRecord::Base
  belongs_to :category_group
  has_many :page_categories
  has_many :pages, :through => :page_categories
  acts_as_list :scope => :category_group_id

  class << self
    # finds all of the categories that have been applied to
    # any of the pages with the given page template
    # If the page_template specified is not the name of an existing page template,
    # then no are returned
    def find_all_by_page_template(page_template,force = false)
      partial = Partial.find_by_name(page_template)
      if partial.nil?
        force ? Category.find(:all,:include => :category_group).group_by(&:category_group).sort_by{|x| x.first.position} : []
      else
        categories = find(:all,
        :conditions => ["categories.id in (select category_id from page_categories where page_id in (select id from pages where partial_id = ?))", partial.id],
        :order => "category_groups.position, categories.position", 
        :include => :category_group).group_by(&:category_group).sort_by{|x| x.first.position}
      end
    end
  end

end
