require "ine/places/version"
require "csv"
require "ostruct"
require "active_support/all"
require "open-uri"

module INE
  module Places

    require "ine/places/csv_record"
    require "ine/places/autonomous_region"
    require "ine/places/autonomous_regions_collection"
    require "ine/places/province"
    require "ine/places/provinces_collection"
    require "ine/places/place"
    require "ine/places/places_collection"

    ROOT = File.expand_path('../places/', __FILE__)

    def self.preload
      AutonomousRegionsCollection.records
      ProvincesCollection.records
      PlacesCollection.records

      nil
    end

    def self.hydratate(klass, data_path, options)
      data = CSV.read(open(data_path), headers: true)

      data.each do |row|
        if obj = klass.find(row[options[:id_column]])
          value = row[options[:value_column]]
          case options[:convert_to]
          when :float
            value = value.to_f
          when :integer, :int
            value = value.to_i
          end

          obj.data.send((options[:as].to_s + '=').to_sym, value)
        end
      end

      nil
    end
  end
end
