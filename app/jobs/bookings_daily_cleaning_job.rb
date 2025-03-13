class BookingsDailyCleaningJob < ApplicationJob
  queue_as :default

  def perform
    # bookings en pending (ni acceptés ni refusés)
    pending_bookings = Booking.where(status:"pending")
    pending_bookings.each do |booking|
      # si la date de début est passée -> rejected
      if booking.start_date < Date.today
        booking.update(status:"rejected")
      # si la date de fin est passée -> abandoned
      elsif booking.end_date < Date.today
        booking.update(status:"abandoned")
      end
    end

    # bookings accepted
    accepted_bookings = Booking.where(status:"accepted")
    accepted_bookings.each do |booking|
      # si la date de fin est passée -> ended
      if booking.end_date < Date.today
        booking.update(status:"ended")
      end
    end

    # bookings rejected
    rejected_bookings = Booking.where(status:"rejected")
    rejected_bookings.each do |booking|
      # si la date de fin est passée -> abandoned	if booking.end_date < Date.today
      if booking.end_date < Date.today
        booking.update(status:"ended")
      end
    end
  end
end
