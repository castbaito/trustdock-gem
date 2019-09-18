module Trustdock
  module Types
    include Dry.Types(default: :nominal)
  end

  module Response
    class Verification < Dry::Struct
      attribute :id, Types::String
      attribute :id_for_helper, Types::String
      attribute :state, Types::String
      attribute :result, Types::String
      attribute :accepted_at, Types::String
      attribute :plans_selected_at, Types::String
      attribute :document_submitted_at, Types::String
      attribute :prepared_at, Types::String
      attribute :verified_at, Types::String
    end
  end
end
