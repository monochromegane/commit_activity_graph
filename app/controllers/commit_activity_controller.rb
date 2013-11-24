class CommitActivityController < ApplicationController
  def index
    aggregater = CommitActivity.aggregate
    aggregater.since(Date.parse(params[:since])) if params.key?(:since)
    @commit_activity = aggregater.hash

    @high_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(type: 'arearange')
      f.title(text: 'Commit activity')
      f.xAxis(type: 'datetime', title: { text: 'commit day' })
      f.yAxis(type: 'datetime', title: { text: 'commit time' })
      @commit_activity.each do |user, day_activity|
        data = day_activity.sort.map do |activity|
          [
            Date.parse(activity[0]).to_time.to_i    * 1000, # commit day
            time_as_today(activity[1][:first]).to_i * 1000, # commit time low
            time_as_today(activity[1][:last]).to_i  * 1000  # commit time high
          ]
        end
        f.series(name: user, data: data)
      end
    end
  end

  def time_as_today(time)
    today = DateTime.now
    DateTime.new(today.year, today.month, today.day, time.hour, time.min).to_time
  end
end
