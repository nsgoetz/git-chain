require 'optparse'

module GitChain
  module Commands
    class Up < Command
      include Options::ChainName

      def description
        "checkouts a branch relative to the current chain"
      end

    def run(options)
        current_branch_name = Git.current_branch

        raise(Abort, "Current branch '#{current_branch_name}' is not in a chain.") unless options[:chain_name]

        current_branch = Models::Branch.from_config(current_branch_name)
        parent_branch = Models::Branch.from_config(current_branch.parent_branch)
        parent_branch_name = parent_branch.name

        puts_info("Checking out {{info:#{parent_branch_name}}}")

        Git.checkout(branch: parent_branch_name)
      end 

    end
  end
end