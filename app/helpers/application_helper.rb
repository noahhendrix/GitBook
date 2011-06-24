module ApplicationHelper
  
  def title(title)
    @title ||= title
  end
  
  def yield_title
    [@title, 'GitBook', 'Project Discussion'].compact.join(' - ')
  end
  
  def linked_repo_slug(repo)
    [
      link_to(@repository.username, user_path(@repository.user)),
      link_to(@repository.name, repo_path(@repository))
    ].join(' / ')
  end
  
  def user_path(user)
    repositories_path(user.name)
  end
  
  def repo_path(repo)
    repository_path(repo.username, repo.name)
  end
  
  def time_ago_or_exact_date(datetime)
    datetime < 1.week.ago ? datetime.strftime('on %B %d, %Y at %I:%M%P') : "#{time_ago_in_words(datetime)} ago"
  end
  
  class ContentBlock < BlockHelpers::Base
    
    def initialize(title, options = {})
      @title = title.html_safe
      @float = options[:float] || ''
      @sidebar = options[:sidebar] || nil
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
      list << 'sidebarred' if @sidebar.present?
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
      if @sidebar.present?
        body = render_sidebar + content_tag(:div, body, class: 'sidebar-content')
      end
      
      content_tag(:div, body, class: 'content')
    end
    
    def render_sidebar
      content_tag(:div, content_tag(:p, @sidebar.html_safe), class: 'sidebar') if @sidebar.present?
    end
    
    def render_footer
      ['bendl', 'bendr'].map do |klass|
        content_tag(:div, '', class: klass)
      end.join.html_safe
    end
    
  end
  
end
