class CatRentalRequest < ActiveRecord::Base

  STATUSES = %w(PENDING APPROVED DENIED)

  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: "Cat"

  after_initialize :assign_pending_status

  validates(
    :cat_id,
    :start_date,
    :end_date,
    :status,
    presence: true
  )

  validates :status, inclusion: STATUSES
  validate :does_not_overlap_approved_requests
  validate :start_date_precedes_end_date

  def denied?
    self.status == "DENIED"
  end


  def approve!
    raise "not pending" unless self.status == "PENDING"
    transaction do
      self.status = "APPROVED"
      self.save

      overlapping_pending_requests.update_all(status: "DENIED")
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end

  protected

  def assign_pending_status
    self.status ||= "PENDING"
  end

  def overlapping_requests
    CatRentalRequest
      .where("(:id IS NULL) OR (id != :id)", id: self.id)
      .where(cat_id: cat_id)
      .where(<<-SQL, start_date: start_date, end_date: end_date)
       NOT( (start_date > :end_date) OR (end_date < :start_date) )
SQL
  end

  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def does_not_overlap_approved_requests
    return if self.denied?
    unless overlapping_approved_requests.empty?
      errors[:base]<< "Request conflicts with existing approved request"
    end
  end

  def start_date_precedes_end_date
    return if start_date.nil? || end_date.nil?
    unless self.start_date < self.end_date
      errors[:base] << "Start date must precede end date"
    end
  end

end
