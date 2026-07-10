class CalendarController < ApplicationController
  def index
    authorize :calendar, :index?, policy_class: CalendarPolicy
  end
end
