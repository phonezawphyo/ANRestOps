Pod::Spec.new do |s|
  s.name              = "ANRestOps"
  s.version           = "1.0.2"
  s.summary           = "ANRestOps is a simple lightweight library to make REST calls"
  s.description       = <<-DESC ANRestOps is a simple library based on the NSURLConnection and NSOperationQueue APIs. It abstracts away most of the complexity to set up these objects and allows you to make simple REST calls in a single line of code. DESC
  s.homepage          = "https://github.com/ayushn21/ANRestOps"
  s.license           = 'MIT'
  s.author            = { "Ayush Newatia" => "ayush.newatia@icloud.com" }
  s.source            = { :git => "https://github.com/ayushn21/ANRestOps.git", :tag => s.version.to_s }
  s.social_media_url  = 'https://twitter.com/ayushn21'
  s.platform          = :ios, '7.0'
  s.requires_arc      = true
  s.source_files      = 'ANRestOps/*.{h,m}'
  s.frameworks        = 'Foundation'
end
