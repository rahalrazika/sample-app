module ApplicationHelper
    #returnes the full title on per_page basis
    def full_title(page_title = '')
        base_title = "Ruby on rails Toturial Sampl App"
        if page_title.empty?
            base_title
        else
            '#{page_title} | #{base_title}'
        end
    
    end
end
