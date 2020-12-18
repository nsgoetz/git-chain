require 'optparse'

module GitChain
  module Commands
    class Down < Command
      include Options::ChainName

      def description
        "checkouts a branch relative to the current chain"
      end

    def run(options)
      current_branch_name = Git.current_branch

      raise(Abort, "Current branch '#{current_branch_name}' is not in a chain.") unless options[:chain_name]

      chain = GitChain::Models::Chain.from_config(options[:chain_name])

      current_branch = Models::Branch.from_config(current_branch_name)
      
      down_levels = 0
      number_to_go = 1  # todo: add in command line numbers 

      chain.branches.each do |branch|

        if branch.parent_branch == current_branch_name
          current_branch_name = branch.name 
          down_levels = down_levels + 1 

          if down_levels == number_to_go
            break
          end
        end 
      end
      
      if current_branch_name != Git.current_branch
        puts_info("Checking out {{info:#{current_branch_name}}}")
        Git.checkout(branch: current_branch_name)
      else
        puts_info("Already at the end of the chain: {{info:#{current_branch_name}}}")
      end 

    end 
    end
  end
end