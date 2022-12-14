#!/bin/bash

TEST=$1
SECOND_ARG=$2
COMMAND_LINE_ARGS=${@:2}

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
	if [ -z "$SECOND_ARG" ]
	  then
	    /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_graphql.xml
	else
        /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_graphql.xml $COMMAND_LINE_ARGS
	fi
}

run_unit()
{
	echo "##############################################################################################"
	echo "                                 RUNNING UNIT TESTS                                           "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	if [ -z "$SECOND_ARG" ]
	  then
	    vendor/bin/phpunit -c dev/tests/unit/adc_phpunit.xml.ci
	else
	    vendor/bin/phpunit -c dev/tests/unit/adc_phpunit.xml.ci $COMMAND_LINE_ARGS
	fi
}

run_rest()
{
	echo "##############################################################################################"
	echo "                                 RUNNING REST TESTS                                           "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	cd dev/tests/integration
	if [ -z "$SECOND_ARG" ]
	  then
	    /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_rest.xml
	else
	    /var/www/html/magento2/vendor/bin/phpunit -c ../api-functional/adc_phpunit_rest.xml $COMMAND_LINE_ARGS
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

run_phpcbf()
{
	echo "##############################################################################################"
	echo "                              RUNNING PHPCBF                                                  "
	echo "##############################################################################################"
	cd "$ROOT_PATH"
	vendor/bin/phpcbf --standard=Magento2 extensions
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
	'phpcbf')
	run_phpcbf
	;;

  	*)
  	    if [ -z "$TEST" ]
  	        then
  	            run_all
  	    else
  	        echo "Invalid test name"
  	    fi
	;;
esac
