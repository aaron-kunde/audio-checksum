# audio-checksum
This project contains a shell-Skript, which produces MD5-Checksums of audio files (like .ogg, .mp3, .flac...).

Checksum tools like md5sum regarding everything in a file to calculate the checksum. I only want to know, if the audio data without tags (comments, author, images, ...) has changed. Therefore, for each file is made a tempporary copy, from which all tags are removed. Then the checksum is calculated.
