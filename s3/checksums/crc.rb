require "digest"
puts Digest::SHA1.file("myfile.txt")