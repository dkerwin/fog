Shindo.tests('Fog::Compute.new', ['ProfitBricks']) do

  tests("service options") do
    {
      :profitbricks_api_url => "https://api.profitbricks.com/",
      :persistent => :true
    }.each_pair do |option, sample|
      tests("recognises :#{option}").returns(true) do
        options = {:provider => "ProfitBricks", :profitbricks_username => "joe@example.com", :profitbricks_password => "secret!"}
        options[option] = sample
        begin
          Fog::Compute.new(options)
          true
        rescue ArgumentError
          false
        end
      end
    end
  end
end
