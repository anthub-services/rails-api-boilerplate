module ActiveRecordHelper
  class << self
    attr_reader :options

    def set_order sorted, table_id
      sorted.split(',').map do |s|
        array    = s.split(':')
        array[0] = array[0].underscore
        array[0] = 'id' if (array[0].eql? table_id)
        array.join ' '
      end.join ', '
    end

    def set_filter filtered, options={}
      @options = options
      fields = []
      values = []

      filtered.split(',').map do |f|
        array = f.split(':')
        field = array[0].underscore
        value = decode_value(array[1]).downcase
        type = :string

        if options[:replace] && options[:replace][field.to_sym]
          replace = options[:replace][field.to_sym]
          field = replace[:field]
          value = replace[:value]
          type = replace[:type]
        end

        fields << set_field(field, value, type)
        values = set_values field, value, values
      end

      [fields.join(' AND ')].concat values
    end

    def decode_value value
      URI.decode(URI.decode value)
    end

    def set_field field, value, type
      field = 'id' if field.eql? options[:table_id]

      return set_fields_or(field, value, type) if value.is_a?(Array)
      return [field, '=?'].join if field.eql?('id')
      return 'created_at >= ?' if options[:date_from] && field.eql?('date_from')
      return 'created_at <= ?' if options[:date_to] && field.eql?('date_to')
      return set_fields_tilde(field, value) if options[:match] && options[:match].index(field).present?

      ['LOWER(', field, ')=?'].join
    end

    def set_values field, value, values
      return values.concat(set_values_tilde(value)) if options[:match] && options[:match].index(field)
      return values.concat value if value.is_a? Array
      values << value
    end

    def set_fields_or field, value, type
      i = 0
      where_or = []

      while i < value.count
        if type.eql? :integer
          where_or << [field, '=?'].join
        else
          where_or << ['LOWER(', field, ')~?'].join
        end
        i += 1
      end

      ['(', where_or.join(' OR '), ')'].join
    end

    def set_fields_tilde field, value
      i = 0
      where_tilde = []

      while i < value.split(' ').count
        where_tilde << ['LOWER(', field, ')~?'].join
        i += 1
      end

      where_tilde.join ' AND '
    end

    def set_values_tilde value
      value.split(' ').map do |v|
        ['\y', v, '\y'].join
      end
    end
  end
end
