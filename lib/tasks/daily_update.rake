namespace :daily_update do
    task info: :environment do
      SchoolpostInfo.new.get
    end

    task content: :environment do
      SchoolpostContent.new.get
    end

    task file: :environment do
      SchoolpostFile.new.get
    end

    task image: :environment do
      SchoolpostImage.new.get
    end
  end