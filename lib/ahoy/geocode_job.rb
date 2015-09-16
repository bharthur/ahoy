module Ahoy
  class GeocodeJob < ActiveJob::Base
    queue_as :ahoy

    def perform(visit)
      deckhand = Deckhands::LocationDeckhand.new(visit.ip)
      Ahoy::VisitProperties::LOCATION_KEYS.each do |key|
        if visit.respond_to?(:"#{key}=")
          valu = deckhand.send(key)
          valu = valu.encode('UTF-8') if valu.class.to_s == "String"
          visit.send(:"#{key}=", valu)
        end
      end; visit.save!
    end
  end

end
