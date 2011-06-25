class ActivityJob < Struct.new(:repository)
  
  def initialize(repo)
    super
    fire_event
  end
  
  def enqueue
    record_stat "enqueueing activity for #{repository.slug}"
  end
  
  def perform
    repository.fetch_recent_activity
  end
  
  def before(job)
    record_stat "starting fetch for #{repository.slug}"
  end
  
  def after(job)
    notice.destroy if notice.respond_to?(:destroy)
  end
  
  def success(job)
    record_stat "successful fetch for #{repository.slug}"
  end
  
  def error(job, exception)
    #notify_hoptoad(exception)
  end
  
  def failure
    record_stat "failure for #{repository.slug}"
  end
  
  private
  
  def record_stat(msg)
    puts msg
  end
  
  def fire_event
    Repository::fire(:fetching,
      subject: repository,
      secondary_subject: notice,
      secondary_subject_data: notice.to_yaml,
      occurred_at: 3.weeks.from_now #push it to the top of the list
    )
  end
  
  def notice
    @notice ||= repository.notices.create(message: Repository::ENQUE_NOTICE)
    
  end
  
end