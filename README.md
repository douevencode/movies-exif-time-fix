# movies-exif-time-fix

Script that extracts movie created date and time from its name and sets them in EXIF metadata. Currently works on mp4 files with name in format YYYYMMDD_HHMMSS like "20190501_123045" but can be easily extended to support other cases.

**Important: It requires [ExifTool](https://www.sno.phy.queensu.ca/~phil/exiftool/)**

### Usage

Just run `ruby movies_exif_time_fix.rb` - script will process files in the current directory.

You can also specify directory as first argument e.g. `ruby movies_exif_time_fix.rb path/to/dir`. Here script will process only files in that directory.

For more info see: http://www.douevencode.com/articles/2019-02/fix-movies-created-time/
