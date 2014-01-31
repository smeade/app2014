module EntriesHelper

  def any_entries_for_day?(date)
    Entry.for_date(date).size > 0
  end

  def day_in_current_streak?(date)
    day = Date.today
    while any_entries_for_day?(day)
      return true if date == day
      day -= 1
    end
    return false
  end

  def class_day_in_current_streak?(date)
    day_in_current_streak?(date) ? 'streak-icon' : ''
  end

end
