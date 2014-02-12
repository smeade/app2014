class Entry < ActiveRecord::Base

  belongs_to :project

  after_create :start, if: "minutes.blank?"
  after_create :set_defaults

  default_scope { order('date desc, created_at desc') } 

  scope :bootstrapping, -> { where(bootstrapping: true) }
  scope :billable, -> { where(billable: true) }
  scope :complete, -> {where(running: false)}
  scope :for_date, ->(for_date) { where(:date => for_date) }
  scope :other, -> { where(billable: false, bootstrapping: false) }
  scope :running, -> {where("started_at is not null")}
  scope :today, -> {where(:date => Date.today)}
  scope :yesterday, -> {where(:date => Date.today - 1)}
  scope :with_journal_text, -> {where("journal > ''")}

  scope :last_week, -> {where("date > ? and date < ?", (Date.today - 7).beginning_of_week, (Date.today - 7).end_of_week)}  
  scope :this_week, -> {where("date > ?", Date.today.beginning_of_week) }

  scope :last_month, -> {where("date > ? and date < ?", (Date.today - 1.month).beginning_of_month, (Date.today - 1.month).end_of_month)}  
  scope :this_month, -> {where("date > ?", Date.today.beginning_of_month) }


  def elapsed_time
    (self.minutes || 0 ) + ((Time.now() - self.updated_at).to_i / 60.0)
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

  def set_defaults
    self.update_attributes(date: self.date || Date.today, minutes: self.minutes || 0)

    # If name ends in "-", it is not billable
    # If name ends in "+", it is for bootstrapping
    # Else it is billable
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

  def start
    Entry.running.each { |e| e.stop }
    self.update_attributes(started_at: Time.now)
  end

  def stop
    self.update_attributes(
      minutes:    (self.minutes || 0 ) + (Time.now() - self.started_at).to_i / 60,
      started_at: nil)
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
