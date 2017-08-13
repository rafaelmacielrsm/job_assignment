class BlockSelfReportValidator < ActiveModel::Validator
  def validate(record)
    unless record.survivor_id != record.infected_id
      record.errors[:infected_id] << "can't flag yourself as an infected"
    end
  end
end
