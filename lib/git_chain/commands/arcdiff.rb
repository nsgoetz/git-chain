require 'optparse'

module GitChain
  module Commands
    class Arcdiff < Command
      include Options::ChainName

      def description
        "creates a phab dif with only the changes since the prev branch in the chain"
      end

      def run(options)
        # TODO: warn on no rebase
        current_branch_name = Git.current_branch

        raise(Abort, "Current branch '#{current_branch_name}' is not in a chain.") unless options[:chain_name]

        if Git.rebase_in_progress?
          raise(Abort, "A rebase is in progress. Please finish the rebase first and run 'git chain phabdiff' after.")
        end

        current_branch = Models::Branch.from_config(current_branch_name)
        parent_branch = Models::Branch.from_config(current_branch.parent_branch)
        parent_branch_name = parent_branch.name
        parent_sha = Git.rev_parse(parent_branch_name)

        raise(Abort, "Current branch '#{Git.current_branch}' is not up to date with '#{parent_branch_name}'. Please rebase before continuing") unless parent_sha == current_branch.branch_point

        GitChain::Logger.warn("arc diff #{parent_branch_name}")
        
        exec('arc', 'diff', current_branch.branch_point)

      end

    end
  end
end
