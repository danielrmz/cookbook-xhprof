maintainer        "Daniel Ramirez"
maintainer_email  "hello@danielrmz.com"
license           "MIT License"
description       "Installs xhprof php extension for apache"
version           "0.0.1"
depends           "php::source"
depends           "apache2"
 
recipe "xhprof", "Installs xhprof php extension"
 
%w{ ubuntu }.each do |os|
	supports os
end

