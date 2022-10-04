#!/bin/bash

TEST=$1
FILTER_VALUE=$2

ROOT_PATH="/var/www/html/magento2/"


run_phpcs()
{
	echo "##############################################################################################"
	echo "                                 RUNNING PHPCS CHECKS                                         "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	./vendor/bin/phpcs --standard=./vendor/magento/magento-coding-standard/Magento2 extensions
}

run_phpmd()
{
	echo "##############################################################################################"
	echo "                                 RUNNING PHPMD CHECKS                                         "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	./vendor/bin/phpmd extensions html  ./dev/tests/static/testsuite/Magento/Test/Php/_files/phpmd/ruleset.xml > md.html
}

run_graphql()
{
	echo "##############################################################################################"
	echo "                                 RUNNING GRAPHQL TESTS                                         "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	cd dev/tests/integration
	if [ -z "$FILTER_VALUE" ]
	  then
	    /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_graphql.xml
	else
	    /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_graphql.xml --filter "$FILTER_VALUE"
	fi
}

run_unit()
{
	echo "##############################################################################################"
	echo "                                 RUNNING UNIT TESTS                                           "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	if [ -z "$FILTER_VALUE" ]
	  then
	    vendor/bin/phpunit -c dev/tests/unit/adc_phpunit.xml.ci
	else
	    vendor/bin/phpunit -c dev/tests/unit/adc_phpunit.xml.ci --filter "$FILTER_VALUE"
	fi
}

run_rest()
{
	echo "##############################################################################################"
	echo "                                 RUNNING REST TESTS                                           "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	cd dev/tests/integration
	if [ -z "$FILTER_VALUE" ]
	  then
	    /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_rest.xml
	else
	    /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_rest.xml --filter "$FILTER_VALUE"
	fi
}

run_integration()
{
	echo "##############################################################################################"
	echo "                              RUNNING INTEGRATION TESTS                                        "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	cd dev/tests/integration
	/var/www/html/magento2/vendor/bin/phpunit -c adc_phpunit_integration.xml.ci
}

run_all()
{
	run_phpcs
	run_phpmd
	run_graphql
	run_unit
	run_rest
	# run_integration
}

case $TEST in
	'phpcs')
	run_phpcs
	;;
	'phpmd')
	run_phpmd
	;;
	'graphql')
	run_graphql
	;;
	'unit')
	run_unit
	;;
	'rest')
	run_rest
	;;
	'integration')
	run_integration
	;;

  	*)
	run_all
	;;
esac
