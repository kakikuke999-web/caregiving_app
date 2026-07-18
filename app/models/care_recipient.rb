class CareRecipient < ApplicationRecord

    has_one_attached :photo
    attr_accessor :remove_photo

    belongs_to :primary_care_manager, class_name: "User", optional: true

    has_many :family_memberships, dependent: :destroy
    has_many :family_members, through: :family_memberships, source: :user
    has_many :visit_reports, dependent: :destroy
    has_many :vitals, dependent: :destroy
    has_many :adl_records, dependent: :destroy
    has_many :medication_records, dependent: :destroy
    has_many :emergency_contacts, -> { order(:priority) }, dependent: :destroy
    has_many :personal_schedules, dependent: :destroy
    has_many :care_recipient_visit_types, dependent: :destroy
    has_many :visit_types, through: :care_recipient_visit_types
    has_many :care_documents, dependent: :destroy
    has_many :recurring_schedules, dependent: :destroy
    has_many :support_logs, dependent: :destroy
    has_many :care_plans, dependent: :destroy

    CARE_LEVELS = %w[自立 要支援1 要支援2 要介護1 要介護2 要介護3 要介護4 要介護5].freeze

    CERTIFICATION_WARNING_DAYS = 60

    STALE_THRESHOLD = 7.days

    GENDERS = %w[male female].freeze

    GENDER_LABELS = {
      "male" => "男性",
      "female" => "女性"
    }.freeze

    validates :care_level, inclusion: { in: CARE_LEVELS }, allow_blank: true
    validates :gender, inclusion: { in: GENDERS }, allow_blank: true

    def gender_label
      GENDER_LABELS[gender]
    end

    def certification_expiring?
      return false unless care_level_valid_until.present?

      care_level_valid_until >= Date.current && care_level_valid_until <= CERTIFICATION_WARNING_DAYS.days.from_now.to_date
    end

    def certification_expired?
      care_level_valid_until.present? && care_level_valid_until < Date.current
    end

    # 今月「モニタリング記録」としてマークされた完了済み訪問記録があるか（介護保険の毎月モニタリング義務の実施確認用）
    def monitored_this_month?
      visit_reports.where(is_monitoring: true, status: :completed)
                   .where(visited_at: Time.zone.now.all_month)
                   .exists?
    end

    def last_recorded_at
      [
        vitals.maximum(:recorded_at),
        adl_records.maximum(:recorded_at),
        medication_records.maximum(:recorded_at)
      ].compact.max
    end

    def stale?
      last_recorded_at.nil? || last_recorded_at < STALE_THRESHOLD.ago
    end

    def missed_visit_count
      visit_reports.where(status: :missed).count
    end

    def age
        return nil if birthday.blank?

        today = Date.today
        age = today.year - birthday.year
        age -= 1 if today < birthday + age.years
        age
    end


end
