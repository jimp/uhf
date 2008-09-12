module PagesHelper
  # loops through the pages iteratively, and displays a list of links
  # will only recurse to the level you specify in max_level
  def show_page_tree(pages, ul_id='nav', max_level=2, level=0)
    if pages.length > 0
      html = "<ul id=\"#{ul_id}\">\n"
      pages.each do |child|
        if child.include_in_main_menu
          has_children = child.children.length > 0
          html += "<li>\n"
          html += link_to(child.link_text, child.url)
          html += "\n"
          if has_children
            level += 1
            html += show_page_tree(child.children, "list_item_#{child.id}", max_level, level) unless level > max_level
          end
          html += "</li>\n"
        end
      end
      html += "</ul>\n"
    end
  end

end
