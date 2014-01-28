class Entry < ActiveRecord::Base

  belongs_to :project
  after_create :set_billable_and_bootstrap_from_project_name
  after_create :set_running
  after_create :set_date

  default_scope { order('date desc, created_at desc') } 

  scope :bootstrapping, -> { where(bootstrapping: true) }
  scope :billable, -> { where(billable: true) }
  scope :complete, -> {where(running: false)}
  scope :for_date, ->(for_date) { where(:date => for_date) }
  scope :other, -> { where(billable: false, bootstrapping: false) }
  scope :running, -> {where(running: true)}
  scope :today, -> {where(:date => Date.today)}
  scope :yesterday, -> {where(:date => Date.today - 1)}
  scope :with_journal_text, -> {where("journal > ''")}

  def elapsed_time
    Time.now - self.created_at
  end

  def is_first_of_all?
    Entry.first == self
  end

  # Public: is this Entry the first one for the day
  def is_first_for_day?
    Entry.for_date(self.date).first == self
  end

  # Public: sets project based on either a project_id or project name
  #
  # project_id_or_name - The String value of either an id or name of a project
  # 
  # Examples
  #
  #   project.project_id_or_name=("New project")
  #   project.project_id_or_name=("123")
  #
  # Returns the project
  def project_id_or_name=(project_id_or_name)
    if project_id_or_name.is_i?
      self.project_id = project_id_or_name
    else
      self.project_id = Project.find_or_create_by(name: project_id_or_name).id
    end
  end

  def project_id_or_name
    self.project.id unless self.project.blank?
  end

  # Public: sets billable and bootstrapping flags based on project name
  #
  # If name ends in "-", it is not billable
  # If name ends in "+", it is for bootstrapping
  # Else it is billable
  def set_billable_and_bootstrap_from_project_name
    if project
      if project.name.last == "-"
        self.update_columns(billable: false, bootstrapping: false)
      elsif project.name.last == "+"
        self.update_columns(billable: false, bootstrapping: true)
      else
        self.update_columns(billable: true, bootstrapping: false)
      end
    end
  end

  # Public: sets running to true if minutes is null
  def set_running
    self.update_column(:running, self.minutes.blank?)
  end

  def set_date
    self.update_column(:date, Date.today)
  end

  def start
    self.running = true
    self.save
  end

  def stop
    self.minutes = (self.minutes || 0 ) + (Time.now() - self.updated_at).to_i / 60
    self.running = false
    self.save
  end

  # Public: number of days backwards from today that has at least one Entry
  #
  # Returns: Integer streak length
  def self.streak_days
    streak = 0
    date = Date.today 
    while Entry.bootstrapping.for_date(date).size > 0 || date.wday == 0
      streak += 1
      date -= 1
    end
    streak
  end

end
