class Api::ReportsController
  class Report
    def self.data_json(message, value)
      { data: {
        report: {
          details: message,
          value: value
        }
      }}.to_json
    end
  end
end
