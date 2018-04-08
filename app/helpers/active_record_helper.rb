module ActiveRecordHelper
  class << self
    def set_order sorted, table_id
      sorted.split(',').map do |s|
        array    = s.split(':')
        array[0] = array[0].underscore
        array[0] = 'id' if (array[0].eql? table_id)
        array.join(' ')
      end.join(', ')
    end

    def set_filter filtered, options={}
      @options = options
      fields = []
      values = []

      filtered.split(',').map do |f|
        array = f.split(':')
        fields << set_field(array[0].underscore)
        values << URI.decode(URI.decode array[1]).downcase
      end

      [fields.join(' and ')].concat values
    end

    private

      attr_reader :options

      def set_field field
        field = 'id' if field.eql? options[:table_id]

        return [field, '=?'].join if field.eql? 'id'
        return 'created_at >= ?' if options[:date_from] && field.eql?('date_from')
        return 'created_at <= ?' if options[:date_to] && field.eql?('date_to')

        ['lower(', field, ')=?'].join
      end
  end
end
