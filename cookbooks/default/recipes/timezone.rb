area = "Europe"
city = "Berlin"

execute "change timezone" do
  command "echo \"#{area}/#{city}\" > /etc/timezone && cp /usr/share/zoneinfo/#{area}/#{city} /etc/localtime"
  not_if {`cat /etc/timezone`.chomp == "#{area}/#{city}" }
end
