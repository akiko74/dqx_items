


module DqxItems
  module DataLoader

    class ManualWorkLoader

      def self.execute
        file_path = ARGV[0]
        DqxItems::ManualWork::Parser.parse(file_path).each do |recipe|
p recipe
        end
      end

    end

  end
end
