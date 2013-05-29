class StandardFormBuilder < ActionView::Helpers::FormBuilder

  alias :unlabeled_text_field :text_field

  def text_field(field_name, label = nil, options = {})
    label ||= field_name
    labeled_control_group(label, field_name, super(field_name, options))
  end

  def text_area(field_name, label = nil, options = {})
    label ||= field_name
    labeled_control_group(label, field_name, super(field_name, options))
  end

  def password_field(field_name, label = nil, options = {})
    label ||= field_name
    labeled_control_group(label, field_name, super(field_name, options))
  end

  def errors(errs)
    if not errs.nil? and errs.any?
      errs.full_messages.inject(nil) do |oldErrs, newErr|
        if oldErrs.nil?
          __error_as_div(newErr)
        else
          oldErrs + __error_as_div(newErr)
        end
      end
    end
  end

  def __error_as_div(message)
    @template.content_tag(:div, :class => 'alert alert-error') do
      @template.content_tag(:div, :class => "close", :type => "button", :'data-dismiss' => "alert") do "×" end + # + is important!
      message
    end
  end

  def labeled_control_group(label, field_name, element)
    @template.content_tag(:div, :class => 'control-group') do
      @template.label_tag("#{@object_name}_#{field_name.to_s}", label.to_s.humanize, :class => 'control-label') + # + is important!
      @template.content_tag(:div, :class => 'controls') do 
        element
      end
    end
  end

end