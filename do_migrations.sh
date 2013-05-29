#!/bin/zsh

source ~/.zshrc

mopt none > /dev/null
export MAGLEV_OPTS="-W0"

cd $MAGLEV_HOME > /dev/null
use ruby > /dev/null
rake maglev:reload_everything > /dev/null
echo "Created a new MagLev stone."
use maglev > /dev/null
cd ~/deli > /dev/null
rm -rf migrations > /dev/null

foreach sha (eb59acd9dd47480c31ef18ad770294b16b87d1b2
	289df211993af0f7c9d4aa86cd1e93134b016dda
	2500bc545ecf840f6626924f2ddc70a3edea3cb0
	bf4338fce61f8bed579f3dc39492df1e94a70f34
	05882a6b515c5642ac4c8b0ecb7cf895236a0210)
	git checkout $sha 2> /dev/null
	echo "Checked out $sha"
	bundle exec rake migrate:auto > /dev/null
	echo "Created snapshot."
	bundle exec rake migrate:up
	echo "Executed migrations."
	echo "----------------------------------------------------------------------"
end

#git checkout eb59acd9dd47480c31ef18ad770294b16b87d1b2 2> /dev/null
#echo "Checked out first commit."
#rm -rf migrations > /dev/null
#bundle exec rake migrate:up
#echo "Created snapshot."
#
#git checkout 289df211993af0f7c9d4aa86cd1e93134b016dda 2> /dev/null
#echo "Checked out second commit."
#bundle exec rake migrate:auto > /dev/null
#echo "Created snapshot."
#bundle exec rake migrate:up
#echo "Executed migrations."
#
#git checkout 2500bc545ecf840f6626924f2ddc70a3edea3cb0 2> /dev/null
#echo "Checked out third commit."
#bundle exec rake migrate:auto > /dev/null
#echo "Created snapshot."
#bundle exec rake migrate:up
#echo "Executed migrations."
#
#git checkout bf4338fce61f8bed579f3dc39492df1e94a70f34 2> /dev/null
#echo "Checked out fourth commit."
#bundle exec rake migrate:auto > /dev/null
#echo "Created snapshot."
#bundle exec rake migrate:up
#echo "Executed migrations."
#
#git checkout 05882a6b515c5642ac4c8b0ecb7cf895236a0210 2> /dev/null
#echo "Checked out fifth commit."
#bundle exec rake migrate:auto > /dev/null
#echo "Created snapshot."
#bundle exec rake migrate:up
#echo "Executed migrations."
#
