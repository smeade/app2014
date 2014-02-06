module EntriesHelper

  def hours_for_day_bootstrapping(date)
    Entry.bootstrapping.for_date(date).sum(:minutes) / 60
  end

  def hours_for_day_billable(date)
    Entry.billable.for_date(date).sum(:minutes) / 60
  end

  def any_entries_for_day?(date)
    Entry.bootstrapping.for_date(date).size > 0
  end

  def day_in_current_streak?(date)
    day = Date.today
    while any_entries_for_day?(day) || day.wday == 0
      return true if date == day
      day -= 1
    end
    return false
  end

  def class_day_in_current_streak?(date)
    day_in_current_streak?(date) ? 'streak-icon' : ''
  end

end
