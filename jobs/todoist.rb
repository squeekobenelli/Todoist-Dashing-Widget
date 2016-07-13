require "net/http"
require "json"

todoist_token = <ADD_YOUR_TOKEN_HERE>

SCHEDULER.every '5m', :first_in => 0 do |job|
    uri = URI.parse("https://todoist.com/API/v7/get_productivity_stats?token=#{todoist_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    if response.code == "200"
        result = JSON.parse(response.body)
        completed = result["completed_count"]
        karma = result["karma"]
        karmatrend = result["karma_trend"]
        send_event('todoist', { todoist_completed: completed, todoist_karma: karma, todoist_trend: karmatrend})
    end
end
