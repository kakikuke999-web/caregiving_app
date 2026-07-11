class CareDocument < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :uploaded_by, class_name: "User"
  has_one_attached :file

  TYPES = %w[rehab_plan care_plan day_service_plan other].freeze

  LABELS = {
    "rehab_plan" => "リハビリテーション実施計画書",
    "care_plan" => "居宅サービス計画書",
    "day_service_plan" => "通所介護計画書",
    "other" => "その他"
  }.freeze

  validates :document_type, inclusion: { in: TYPES }
  validate :file_attached
  validate :valid_until_after_valid_from

  def label
    LABELS[document_type]
  end

  private

  def file_attached
    errors.add(:file, "を選択してください") unless file.attached?
  end

  def valid_until_after_valid_from
    return if valid_from.blank? || valid_until.blank?

    errors.add(:valid_until, "は開始日より後にしてください") if valid_until < valid_from
  end
end
