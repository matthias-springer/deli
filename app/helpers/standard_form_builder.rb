class StandardFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(field_name, label = nil, options = {})
    label ||= field_name
    labeled_control_group(label, super(field_name, options))
  end

  def text_area(field_name, label = nil, options = {})
    label ||= field_name
    labeled_control_group(label, super(field_name, options))
  end

  def labeled_control_group(label, element)
    @template.content_tag(:div, :class => 'control-group') do
      @template.label_tag("#{@object_name}_#{label}", label.to_s.humanize, :class => 'control-label') + # + is important!
      @template.content_tag(:div, :class => 'controls') do 
        element
      end
    end
  end

end