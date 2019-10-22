#!/usr/bin/env bash

rm text_test/test_output_30days.txt
ruby text_test/30days_fixture.rb 30 >> text_test/test_output_30days.txt
diff  text_test/test_output_30days.txt  text_test/master_output_30days.txt
