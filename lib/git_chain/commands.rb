module GitChain
  module Commands
    autoload :Branch, 'git_chain/commands/branch'
    autoload :Command, 'git_chain/commands/command'
    autoload :List, 'git_chain/commands/list'
    autoload :Rebase, 'git_chain/commands/rebase'
    autoload :Push, 'git_chain/commands/push'
    autoload :Setup, 'git_chain/commands/setup'
    autoload :Arcdiff, 'git_chain/commands/arcdiff'
    autoload :Up, 'git_chain/commands/up'
    autoload :Down, 'git_chain/commands/down'

    ArgError = Class.new(ArgumentError)

    def self.commands
      @commands ||= constants
        .map(&method(:const_get))
        .select { |c| c < Command }
        .map { |c| [c.command_name, c] }
        .to_h
    end
  end
end
