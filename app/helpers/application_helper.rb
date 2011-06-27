module ApplicationHelper
  
  def title(title)
    @title ||= title
  end
  
  def yield_title
    [@title, 'GitBook', 'Project Discussion'].compact.join(' - ')
  end
  
  def linked_repo_slug(repo)
    [
      link_to(repo.username, user_path(repo.username)),
      link_to(repo.name, repo_path(repo))
    ].join(' / ')
  end
  
  def link_to_user(username = nil, text = nil)
    return 'Unknown' if username.blank?
    link_to((text || username), "https://github.com/#{username}")
  end
  
  def user_path(username)
    repositories_path(username)
  end
  
  def repo_path(repo)
    repository_path(repo.username, repo.name)
  end
  
  def generate_post_comment_path(comment)
    post_comment_path(comment.commentable.class.to_s.tableize, comment.commentable, comment)
  end
  
  def time_ago_or_exact_date(datetime)
    datetime < 1.week.ago ? datetime.strftime('on %B %d, %Y at %I:%M%P') : "#{time_ago_in_words(datetime)} ago"
  end
  
  def repo_stats
    {
      forks: 'network',
      open_issues: 'issues',
      watchers: 'watchers'
    }
  end
  
  class ContentBlock < BlockHelpers::Base
    
    def initialize(title, options = {})
      @title = title.html_safe
      @float = options[:float] || ''
      @sidebar = options[:sidebar] || nil
      @link = options[:link]
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
        content_tag(:h2, @title) + 
        render_link
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
    
    def render_link
      content_tag(:ul, content_tag(:li, @link), class: 'tabs')
    end
    
    def render_footer
      ['bendl', 'bendr'].map do |klass|
        content_tag(:div, '', class: klass)
      end.join.html_safe
    end
    
  end
  
end
