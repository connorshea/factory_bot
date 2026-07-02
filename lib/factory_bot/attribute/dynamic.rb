module FactoryBot
  class Attribute
    # @api private
    class Dynamic < Attribute
      def initialize(name, ignored, block)
        super(name, ignored)
        @block = block
      end

      def to_proc
        block = @block
        yields_instance = case block.arity
        when 1, -1, -2 then true
        else false
        end

        -> {
          value = if yields_instance
            instance_exec(self, &block)
          else
            instance_exec(&block)
          end
          raise SequenceAbuseError if FactoryBot::Sequence === value

          value
        }
      end
    end
  end
end
