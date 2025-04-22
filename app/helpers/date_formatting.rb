# frozen_string_literal: true

module DateFormatting
  def format_date(date)
    date.strftime('%Y-%m-%d')
  end

  def format_time(time)
    time.strftime('%H:%M')
  end

  def format_datetime(datetime)
    "#{format_date(datetime)} #{format_time(datetime)}"
  end
end
