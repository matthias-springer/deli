#! /bin/bash

echo $PWD
git clone https://github.com/knub/maglevrecord.git
cd maglevrecord
git checkout develop

gem build *.gemspec
maglev-gem install --no-rdoc --no-ri ./*.gem

cd ..
# End of script
exit 0
