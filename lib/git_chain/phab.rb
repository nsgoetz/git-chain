require 'open3'

module GitChain
  class Phab
    class Failure < StandardError
      def initialize(args, err)
        super("arc #{args.join(' ')} failed: \n#{err}")
      end
    end

    class << self
      def capture3(*args)
        cmd = %w(arc)
        cmd += args
        exec('arc diff')
      end


      def arc(*args)
        out, err, stat = Open3.capture3('arc', *args)
        raise(Failure.new(args, err)) unless stat.success?
        out.chomp
      end

    end
  end
end