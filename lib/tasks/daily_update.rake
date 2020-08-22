namespace :daily_update do
    task info: :environment do
      SchoolpostInfo.new.get
    end
    task content: :environment do
      SchoolpostContent.new.run
    end
  end