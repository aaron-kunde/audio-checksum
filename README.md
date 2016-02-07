# audio-checksum
This project contains a shell-Skript, which produces MD5-Checksums of audio files (like .ogg, .mp3, .flac...).

Checksum tools like md5sum regarding everything in a file to calculate the checksum. I only want to know, if the audio data without tags (comments, author, images, ...) has changed. Therefore, for each file is made a tempporary copy, from which all tags are removed. Then the checksum is calculated.

In general this script shall behave similar to the usual tools in GNU coreutils (http://www.gnu.org/software/coreutils/coreutils.html) for calculating checksums (md5sum, sha1sum, ...). To calculate a checksum for a file, one of these is used. The actual implementation uses md5sum to calculate MD5 checksums

To clear all tags from the temporary audio file an external tag editor is needed. In this script operon (http://quodlibet.readthedocs.org/en/latest/guide/commands/operon.html) is used.
