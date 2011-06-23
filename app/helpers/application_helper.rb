module ApplicationHelper
  
  def title(title)
    @title ||= title
  end
  
  def yield_title
    [@title, 'GitBook', 'Project Discussion'].compact.join(' - ')
  end
  
  class ContentBlock < BlockHelpers::Base
    
    def initialize(title, options = {})
      @title = title
      @float = options[:float] || ''
      @tabs = []
    end
    
    def display(body)
      content_tag(:div, class: css_classes) do
        render_header + render_body(body) + render_footer
      end
    end
    
    private
    
    def css_classes
      list = ['block', @float]
      list << 'small' if @float.present?
      list.join(' ')
    end
    
    def render_header
      content_tag(:div, class: 'head') do
        content_tag(:div, '', class: 'bheadl') +
        content_tag(:div, '', class: 'bheadr') +
        content_tag(:h2, @title)
      end
    end
    
    def render_body(body)
      content_tag(:div, body, class: 'content')
    end
    
    def render_footer
      ['bendl', 'bendr'].map do |klass|
        content_tag(:div, '', class: klass)
      end.join.html_safe
    end
    
  end
  
end
