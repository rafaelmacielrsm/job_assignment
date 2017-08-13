class BlockSelfReportValidator < ActiveModel::Validator
  def validate(record)
    unless record.survivor_id != record.infected_id
      record.errors[:survivor_id] << "can't report himself/herself"
    end
  end
end
