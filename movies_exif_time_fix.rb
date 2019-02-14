ExifDate = Struct.new(:year, :month, :day) do
  def to_s
    "#{year}:#{month}:#{day}"
  end
end

ExifTime = Struct.new(:hour, :minute, :second) do
  def to_s
    "#{hour}:#{minute}:#{second}"
  end
end

ExifDateTime = Struct.new(:date, :time) do
  def to_s
    "#{date} #{time}"
  end

  def self.from_file_name(file_name)
    m = file_name.match /(?<date>\d{8})_(?<time>\d{6})\.mp4/
    date = m[:date]
    time = m[:time]
    ExifDateTime.new(
        ExifDate.new(date[0..3], date[4..5], date[6..7]),
        ExifTime.new(time[0..1], time[2..3], time[4..5])
    )
  end
end

class MediaFile
  attr_reader :name

  def initialize(file_name)
    @name = file_name
  end

  def file_creation_date
    original_date = `exiftool -FileModifyDate #{name}`
    original_date.split(': ')[1].chomp
  end

  def exif_creation_date
    ExifDateTime.from_file_name(name)
  end
end

def is_correct_name_format?(file_name)
  file_name_format = Regexp.new('\d{8}_\d{6}.mp4')
  is_correct = file_name.match(file_name_format)
  puts "Incorrect file name format: #{file_name}" unless is_correct
  is_correct
end

def let_user_decide_if_process(media_file)
  puts "Do you want to change file: #{media_file.name}?"
  puts "Change date from #{media_file.file_creation_date} to #{media_file.exif_creation_date}? y/n?"
  response = gets.chomp
  response == 'y'
end

def change_file_date_based_on_name(media_file)
  # Sample command
  # `exiftool '-TrackCreateDate=2015:01:18 12:00:00'`
  name = media_file.name
  overwrite_file = '-overwrite_original_in_place'
  puts "Processing file #{name}"
  `exiftool #{overwrite_file} '-TrackCreateDate=#{media_file.exif_creation_date}' #{name}`
  `exiftool #{overwrite_file} "-CreateDate<TrackCreateDate" #{name}`
  `exiftool "-FileModifyDate<TrackCreateDate" #{name}`
  `exiftool "-FileModifyDate<TrackCreateDate" #{name}`
end

root = Dir.open(Dir.pwd)
root.entries
    .select { |file| file.end_with? '.mp4' }
    .select { |file| is_correct_name_format?(file) }
    .collect { |file| MediaFile.new(file) }
    .select { |media_file| let_user_decide_if_process(media_file) }
    .each { |media_file| change_file_date_based_on_name(media_file) }
