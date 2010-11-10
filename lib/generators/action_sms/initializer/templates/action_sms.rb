# see also http://github.com/dwilkie/action_sms
# for more configuration options and details on how to make your own adapter

# Built In Adapters

<% ActionSms::Base.adapters(:sample_configuration, :environment => "test").each do |adapter| -%>
<% config =  adapter.sample_configuration -%>
<%= "## #{config[:adapter].titleize}" %>

# ActionSms::Base.establish_connection(
<% config.each do |key, value| -%>
<% output = "#   :#{key} => \"#{value}\"" -%>
<% unless config.keys.last == key -%>
<% output << "," -%>
<% end -%>
<%= output %>
<% end -%>
# )

<% end -%>
# Custom Adapters

# ActionSms::Base.establish_connection(
#   :adapter => "your_adapter"
#   # adapter specific configuration...
# )

# Incoming Message Authentication

# Using an authentication key in conjunction with a secure connection helps protect you against someone faking incoming messages to your server.

# ActionSms::Base.establish_connection(
#   :use_ssl => true,
#   :authentication_key => "my_secret"
# )

# Testing

# Setting: `:environment => "test"` gives you get some additional test helpers useful for testing

# ActionSms::Base.establish_connection(
#   :environment => "test"
# )

