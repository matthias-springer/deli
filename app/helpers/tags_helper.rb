module TagsHelper
  def labeled_control_group(name, form_element)
    content_tag(:div, :class => 'control-group') do
      label_tag(name, nil, :class => 'control-label') + # + is important!
      content_tag(:div, :class => 'controls') do 
        form_element
      end
    end
  end

  def control_group(form_element)
    content_tag(:div, :class => 'control-group') do 
      content_tag(:div, :class => 'controls') do 
        form_element
      end
    end
  end

  def mini_button(body, url, options = {})
    options.update :class => "#{options[:class]} btn btn-mini"
    link_to(body, url, options)
  end

end